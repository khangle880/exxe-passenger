import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:exxe/src/app/pages/pages.dart';
import 'package:exxe/src/utils/export/ui_export.dart';

import '../../../controllers/token/token_cubit.dart';
import '../../common/dialog/invalid_token_dialog.dart';
import '../../common/widgets/keep_alive_page.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ValueNotifier<int> _index = ValueNotifier<int>(0);
  late RemoveListener removeListener;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final PageController _pageController =
      PageController(initialPage: 0, keepPage: true);

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await Connectivity().checkConnectivity();
    } on PlatformException catch (e) {
      log('Couldn\'t check connectivity status', error: e);
      return;
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    if (result == ConnectivityResult.none) {
      AppDialog.I.showNotification(
        message: "Vui lòng kiểm tra lại kết nối mạng của bạn",
      );
    }
  }

  void _handleListenAppState() {
    // listen app state
    removeListener = GetIt.I.get<AppState>().addListener((state) {
      if (state.state == UserStateEnum.notSignIn) {
        Navigator.pushNamedAndRemoveUntil(
            context, Routes.login, (route) => false);
      } else if (state.isNewAction) {
        if (state.action == ActionStateEnum.invalidToken) {
          InvalidTokenDialog.show(context, onConfirm: () {
            AppDialog.I.closeDialog();
            context.read<TokenCubit>().logOut();
          });
        }
      }
    });
  }

  @override
  void initState() {
    // check connectivity
    // initConnectivity();
    ChatSocketHelper.I.loadSocket();
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {});

    _handleListenAppState();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    removeListener();
    _index.dispose();
    _connectivitySubscription.cancel();
    ChatSocketHelper.I.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.greyLight,
          body: PageView(
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (page) {
              _index.value = page;
            },
            controller: _pageController,
            children: [
              KeepAlivePage(
                child: BodyHomePage(
                  jumpToWallet: () {
                    _pageController.jumpToPage(2);
                  },
                ),
              ),
              const KeepAlivePage(child: MyTripPage()),
              KeepAlivePage(
                child: BlocProvider(
                  create: (_) =>
                      MyWalletBloc(GetIt.I())..add(const LoadWalletEvent()),
                  child: const WalletPage(),
                ),
              ),
              const KeepAlivePage(child: ChatPage()),
              KeepAlivePage(
                child: ProfilePage(
                  jumpToWallet: () {
                    _pageController.jumpToPage(2);
                  },
                ),
              ),
            ],
          ),
          bottomNavigationBar: ValueListenableBuilder(
            valueListenable: _index,
            builder: (context, int index, child) {
              return BottomNavigatorWidget(
                currentIndexPage: index,
                onClick: (index) {
                  _pageController.jumpToPage(index);
                },
              );
            },
          ),
        ),
        const DraggableSupportButton(),
      ],
    );
  }
}
