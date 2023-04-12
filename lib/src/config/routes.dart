import 'package:exxe/src/app/pages/chat_room/controllers/chat_room_cubit.dart';
import 'package:exxe/src/app/pages/pages.dart';
import 'package:exxe/src/app/pages/trip_rating/view_trip_rating_page.dart';
import 'package:exxe/src/app/pages/verify/verify_relationship/controllers/verify_relationship_cubit.dart';
import 'package:exxe/src/app/pages/verify/verify_relationship/relationship_list_page.dart';
import 'package:exxe/src/app/pages/verify/verify_relationship/verify_relationship_page.dart';
import 'package:exxe/src/utils/export/ui_export.dart';

import '../app/pages/chat_room/chat_room_page.dart';
import '../app/pages/home/components/promotion/promotion_home_page.dart';
import '../app/pages/my_trip/components/ride_detail.dart';
import '../app/pages/select_province_station/controller/select_province_station_cubit.dart';
import '../app/pages/select_province_station/select_province_station_page.dart';
import '../data/data.dart';
import '../data_chat/data_chat.dart';

class Routes {
  Routes._internal();

  static String get initial => splash;
  static const String splash = '/splash';
  static const String camera = '/camera';

  static const String searchPlace = '/searchPlace';
  static const String chooseDestination = '/chooseDestination';
  static const String selectStationPage = '/selectStationPage';
  static const String shareLocationPage = '/shareLocationPage';
  static const String selectProvinceStationPage = '/selectProvinceStationPage';

  static const String bookingFillForm = '/bookingFillForm';
  static const String bookingJoinFillForm = '/bookingJoinFillForm';

  //one way
  static const String noCompoundingBook = '/noCompoundingBooking';
  static const String promotionPage = '/promotion_page';
  static const String promotionDetailPage = '/promotion_detail_page';
  static const String depositDetail = '/depositDetail';

  //join trip
  static const String joinConvenientTrip = 'jointrip';
  static const String joinConvenientTripDetail = '/joinTrip/detailJoinTripPage';

  static const String selectAddressConvenient =
      'bookConvenient/selectAddressConvenient';

  //booking
  static const String confirmBooking = '/booking/confirm';
  static const String deposit = 'booking/deposit';

  //my trip
  static const String detailDriver = '/detailDriver';
  static const String myTrip = '/myTrip';
  static const String tripDetail = '/tripDetail';
  static const String tripRating = '/tripRating';
  static const String viewTripRating = '/viewTripRating';
  static const String createAccount = 'login/otp/createAccount';
  static const String tripItinerary = '/tripItinerary';

  //login page
  static const String login = "/login";
  static const String otp = '/login/otp';
  static const String formRegister = '/form_register';
  static const String verifyPhoneNumber = '/verify_phone_number';
  static const String verifyIdentityCard = '/verify_identity_card';
  static const String pickupAddress = '/pickup_address';

  //home page
  static const String home = '/home';
  static const String promotionHomePage = '/promotion/promotionHomePage';
  static const String news = '/news';
  static const String newsDetail = '/news/news_detail';

  //profile
  static const String profile = '/profile';
  static const String changePassword = '/change_password';
  static const String changeLanguage = '/change_language';
  static const String changeBankInfo = '/change_bank_info';

  // identity cccd
  static const String identityCCCDIntro = '/profile/editInfo/indentityIntro';
  static const String enterInformationCCCD = '/enterInfoCCCD';

  // relationship
  static const String verifyRelationship = '/verify_relationship';
  static const String relationList = '/relationship_list';

  //wallet
  static const String walletMainPage = '/walletMainPage';
  static const String rechargePage = '/home/wallet/rechargeMoneyPage';
  static const String withdrawPage = '/home/wallet/withDrawerMoneyPage';
  static const String transactionDetail = '/home/wallet/transactionDetail';

  //Notify
  static const String notification = '/home/notification';

  //Chat
  static const String chat = '/home/chat';
  static const String chatRoom = '/home/chat/chatDetail';

  //reason cancel
  static const String cancelReason = 'cancelReason';

  static String? currentRoute;

  static Map<String, Widget Function(BuildContext)> mapRoutes() {
    return {};
  }

  static Route<dynamic> mapGenerateRoutes(RouteSettings settings) {
    MaterialPageRoute mPage(widget) => MaterialPageRoute(
          builder: (_) => widget,
          settings: settings,
        );

    currentRoute = settings.name;

    switch (settings.name) {
      case Routes.splash:
        return mPage(const SplashPage());
      //home
      case Routes.home:
        return mPage(const CallInvitationPage(child: HomePage()));
      case Routes.promotionHomePage:
        return mPage(const PromotionHomePage());

      case Routes.news:
        return mPage(const NewsPage());

      case Routes.login:
        return mPage(BlocProvider<AuthLoginBloc>(
          create: (context) => AuthLoginBloc(GetIt.I(), GetIt.I()),
          // ignore: prefer_const_constructors
          child: LoginPage(),
        ));

      //profile
      case Routes.profile:
        return mPage(const ProfilePage());

      case Routes.changeBankInfo:
        return mPage(BlocProvider(
          create: (context) => RegisterBankAccountCubit(GetIt.I())
            ..getBankAccountInformation()
            ..getListBanks(),
          child: const RegisterFormBankAccountPage(),
        ));

      //my trip
      case Routes.myTrip:
        return mPage(const MyTripPage());

      case Routes.detailDriver:
        return mPage(const DriverDetailPage());

      //wallet
      case Routes.walletMainPage:
        return mPage(BlocProvider(
          create: (_) => MyWalletBloc(GetIt.I())..add(const LoadWalletEvent()),
          child: const WalletPage(),
        ));

      case Routes.rechargePage:
        return mPage(BlocProvider(
          create: (context) =>
              RechargeMoneyCubit(GetIt.I())..getListRechargeMethod(),
          child: const RechargeMoneyPage(),
        ));

      case Routes.withdrawPage:
        return mPage(BlocProvider(
          create: (context) => WithdrawMoneyCubit(GetIt.I()),
          child: const WithdrawMoneyPage(),
        ));

      //Notify
      case Routes.notification:
        return mPage(const NotifyPage());

      //chat
      case Routes.chat:
        return mPage(const ChatPage());
      case Routes.relationList:
        return mPage(const RelationshipListPage());

      case Routes.chatRoom:
        var data = settings.arguments as ChatRoomModel;
        return MaterialPageRoute(
          builder: (context) => ChatRoomPage(
              ChatRoomCubit(GetIt.I(), GetIt.I(), GetIt.I(), GetIt.I(), data)),
        );
      case Routes.cancelReason:
        var data = settings.arguments as CompoundingCarCustomerModel;
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) =>
                CancelReasonCubit(GetIt.I())..getCancelReason(data.state!),
            child: CancelReasonPage(
              compoundingCarCustomerModel: data,
            ),
          ),
        );
      case Routes.noCompoundingBook:
        var args = settings.arguments as Map<String, dynamic>;
        final data =
            args['compounding_car_customer'] as CompoundingCarCustomerModel?;
        final type = args['type'] as CompoundingType;

        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => NoCompoundingBloc(
              GetIt.I<IPlacesRepository>(),
              GetIt.I<IDataControllerRepo>(),
              type,
            )..add(const LoadDefaultGoingOnDate()),
            child: NoCompoundingPage(
              carCustomer: data,
            ),
          ),
        );
      case Routes.otp:
        final args = settings.arguments as Map;
        final phoneNumber = args['phoneNumber'] as String;
        final sendPurpose = args['sendPurpose'] as String?;
        return MaterialPageRoute(
          builder: (_) => OTPPage(
            phoneNumber,
            sendPurpose: sendPurpose,
          ),
        );
      case Routes.formRegister:
        Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) {
              FormRegisterBloc bloc = FormRegisterBloc(GetIt.I());
              return bloc..add(LoadGeneralInfoEvent());
            },
            child: RegisterFormPage(
              title: args['title'],
              description: args['description'],
            ),
          ),
        );
      case Routes.changePassword:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) {
              ChangePasswordCubit cubit = ChangePasswordCubit(GetIt.I(),
                  stringeeToken: args?['stringeeToken']);
              return cubit..checkHasPassword();
            },
            child: ChangePasswordPage(
                onChanged:
                    args?['onChanged'] as Future Function(BuildContext)?),
          ),
        );
      case Routes.changeLanguage:
        return MaterialPageRoute(builder: (_) => const ChangeLanguagePage());
      case Routes.verifyPhoneNumber:
        return MaterialPageRoute(
          builder: (_) => const VerifyPhonePage(),
        );
      case Routes.verifyIdentityCard:
        return MaterialPageRoute(builder: (_) => const IdentityCardPage());
      case Routes.pickupAddress:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) {
              PickupAddressBloc bloc = PickupAddressBloc(GetIt.I());
              return bloc;
            },
            child: const PickupMyAddressPage(),
          ),
        );
      case Routes.deposit:
        var data = settings.arguments as CompoundingCarCustomerModel;
        return MaterialPageRoute(
          builder: (_) => DepositPage(data),
        );
      case Routes.depositDetail:
        Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => DepositDetailPage(
            customer: args['customer'],
            vnpCode: args['vnpCode'],
          ),
        );
      case Routes.transactionDetail:
        var data = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => TransactionDetailPage(
            paymentId: data['paymentId'],
            vnPayCode: data['vnPayCode'],
          ),
        );
      case Routes.tripDetail:
        var data = settings.arguments as CompoundingCarCustomerModel;
        return MaterialPageRoute(
          builder: (_) => RideDetailPage(
            customer: data,
          ),
        );
      case Routes.tripRating:
        var data = settings.arguments as CompoundingCarCustomerModel;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) {
              RatingCubit cubit = RatingCubit();
              cubit.getQuickRatingTag(5);
              return cubit;
            },
            child: TripRatingPage(
              carCustomer: data,
            ),
          ),
        );
      case Routes.viewTripRating:
        var data = settings.arguments as CompoundingCarCustomerModel;
        return MaterialPageRoute(
          builder: (_) => ViewTripRatingPage(
            carCustomer: data,
          ),
        );
      case Routes.searchPlace:
        Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => SearchPlaceBloc(),
            child: SearchPlace(
              searchType: args['searchType'],
              onSelect: args['onSelect'],
              selectedProvince: args['selectedProvince'],
            ),
          ),
        );
      case Routes.chooseDestination:
        Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => ChooseProvincePage(
            searchType: args['searchType'],
            selectLocation: args['selectLocation'],
            currentProvince: args['currentProvince'],
          ),
        );
      case Routes.joinConvenientTripDetail:
        Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => DetailJoinConvenientTripPage(
            compoundingCar: args['compoundingCar'],
          ),
        );
      case Routes.bookingFillForm:
        Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
        final CompoundingCarCustomerModel carCustomModel =
            args['carCustomModel'] as CompoundingCarCustomerModel;
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => BookingFillFormCubit(
              GetIt.I.get(),
              GetIt.I.get(),
              GetIt.I.get(),
            )..mapCompoundingCarToState(carCustomModel),
            child: BookingFillFormPage(
              carCustomModel,
            ),
          ),
        );
      case Routes.bookingJoinFillForm:
        Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
        final CompoundingCarCustomerModel carCustomModel =
            args['carCustomModel'] as CompoundingCarCustomerModel;
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => BookingFillFormCubit(
              GetIt.I.get(),
              GetIt.I.get(),
              GetIt.I.get(),
            )..mapCompoundingCarToState(carCustomModel),
            child: BookingJoinFillFormPage(
              carCustomModel: carCustomModel,
              carModel: args['carModel'] as CompoundingCarModel?,
            ),
          ),
        );
      case Routes.selectStationPage:
        Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => SelectStationPage(
            onSelectStation: args['onSelectStation'],
            provinceModel: args['provinceModel'],
            searchType: args['searchType'],
            initStation: args['initStation'],
            isPickingUpFromStart: args['isPickingUpFromStart'],
            initAddress: args['initAddress'],
          ),
        );
      case Routes.confirmBooking:
        final customer = settings.arguments as CompoundingCarCustomerModel;
        return MaterialPageRoute(
          builder: (context) {
            return BlocProvider(
              create: (context) => ConfirmBookingCubit(
                GetIt.I.get(),
                customer,
              ),
              child: const ConfirmBookingPage(),
            );
          },
        );
      case Routes.joinConvenientTrip:
        Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => JoinConvenientTripCubit(),
                  child: JoinConvenientTripPage(
                    compoundingType: args['compoundingType'],
                  ),
                ));
      case Routes.selectAddressConvenient:
        Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => SelectAddressPage(
            selectAddress: args['selectAddress'],
          ),
        );
      case Routes.promotionPage:
        Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => PromotionCubit()
              ..getListPromotionCanApply(carCustomerId: args['carCustomerId']),
            child: PromotionPage(
              carCustomerId: args['carCustomerId'],
              currentPromo: args['currentPromo'],
            ),
          ),
        );
      case Routes.promotionDetailPage:
        final args = settings.arguments as Map<String, dynamic>;
        int promotionId = args['promotionId'];
        final apply = args['apply'];
        final canApply = args['canApply'];
        return MaterialPageRoute(
          builder: (context) => PromotionDetailPage(
            promotionId: promotionId,
            canApply: canApply,
            apply: apply,
          ),
        );
      case Routes.newsDetail:
        Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => BlocProvider<NewsCubit>(
            create: (context) => NewsCubit()..getNewsDetail(args['postId']),
            child: const NewsDetailPage(),
          ),
        );

      case Routes.selectProvinceStationPage:
        Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => BlocProvider<SelectProvinceStationCubit>(
            create: (context) => SelectProvinceStationCubit(),
            child: SelectProvinceStationPage(
              callback: args['callback'],
              type: args['type'],
              currentProvinceId: args['currentProvinceId'],
            ),
          ),
        );
      case Routes.verifyRelationship:
        final relationship =
            settings.arguments as RelationshipInformationModel?;
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) =>
                VerifyRelationshipCubit(GetIt.I(), relationship),
            child: const VerifyRelationshipPage(),
          ),
        );

      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
