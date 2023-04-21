import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../config/themes.dart';
import '../controllers/token/token_cubit.dart';
import '../data/data.dart';
import '../utils/export/main_app.dart';
import 'pages/chat_fb/chat_fb_core/chat_fb_core.dart';
import 'pages/pages.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    handleNotification();
    [
      Permission.camera,
      Permission.microphone,
      Permission.locationAlways,
    ].request();
    super.initState();
  }

  loadAppData() {
    final appState = GetIt.I<AppState>();
    final dataRepo = DataControllerRepo();
    // get information to compute price
    dataRepo.informationToComputePriceUnit().then((value) {
      value.fold((failure) => log(failure.toString()),
          (data) => appState.computePriceModel = data);
    });
    // get car types
    dataRepo.getCarTypes().then((value) {
      value.fold(
          (failure) => log(failure.toString()), (data) => appState.cars = data);
    });
    // get car brands
    dataRepo.getCarBrands().then((value) {
      value.fold((failure) => log(failure.toString()),
          (data) => appState.carBrands = data);
    });
  }

  handleNotification() {
    final notiHelper = OneSignalNotificationHelper.I;
    notiHelper.openedHandler = (data) async {
      if (data.additionalData != null) {
        final roomId = data.additionalData?['room_id'];
        if (roomId != null) {
          _openChatRoom(roomId, data);
        }
        final num? compoundingCarCustomerId =
            data.additionalData?['compounding_car_customer_id'];
        if (compoundingCarCustomerId != null) {
          _openRideDetail(compoundingCarCustomerId, data);
        }
      }
    };
    notiHelper.onForeGroundMessage = (data) {
      final appState = GetIt.I<AppState>().currentState;
      if (appState.state == UserStateEnum.signIn &&
          data.additionalData != null) {
        final compoundingCarCustomerId =
            data.additionalData?['compounding_car_customer_id'];
        if (compoundingCarCustomerId != null) {
          _syncTrip(compoundingCarCustomerId);
        }
      }
    };
    notiHelper.init();
  }

  _syncTrip(num compoundingCarCustomerId) async {
    final result = await GetIt.I<ICompoundingCarCtrlRepo>()
        .getDetailCompoundingCarCustomer(compoundingCarCustomerId);
    result.fold((l) {}, (data) {
      GetIt.I<AppState>().createAction(ActionStateEnum.syncTrip, object: data);
    });
  }

  _openRideDetail(num compoundingCarCustomerId, OSNotification data) async {
    final either = await GetIt.I<ICompoundingCarCtrlRepo>()
        .getDetailCompoundingCarCustomer(compoundingCarCustomerId);

    either.fold((l) {
      l.showDefaultDialog();
      if (l.toString() == "Token không có hiệu lực!") {
        OneSignalNotificationHelper.I.notiSaved = data;
      }
    }, (data) {
      Future.delayed(const Duration(seconds: 2), () {
        navigatorKey.currentState?.pushNamed(
          Routes.tripDetail,
          arguments: data,
        );
      });
    });
  }

  void _openChatRoom(roomId, OSNotification data) async {
    var room = FirebaseChatCore.instance.room(roomId);
    Future.delayed(const Duration(seconds: 2), () {
      navigatorKey.currentState?.pushNamed(
        Routes.chatRoom,
        arguments: room,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            TokenCubit tokenCubit = TokenCubit();
            tokenCubit.checkToken();
            return tokenCubit;
          },
        ),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('vi', "VN"),
          Locale('ar'),
          Locale('ja'),
        ],
        locale: const Locale('vi'),
        title: 'Production',
        debugShowCheckedModeBanner: false,
        theme: AppThemes.themeLights,
        navigatorObservers: [FlutterSmartDialog.observer],
        builder: FlutterSmartDialog.init(
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: child!,
            );
          },
        ),
        routes: Routes.mapRoutes(),
        onGenerateRoute: Routes.mapGenerateRoutes,
        home: const SplashPage(),
      ),
    );
  }
}
