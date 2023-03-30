import '../../../core/base_state.dart';
import '../../../data/models/models.dart';
import '../../../utils/export/ui_export.dart';
import 'components/body_wallet.dart';
import 'components/wallet_drawer.dart';
import 'controllers/mywallet_bloc.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  BaseState<WalletPage, MyWalletBloc> createState() => _WalletPageState();
}

class _WalletPageState extends BaseState<WalletPage, MyWalletBloc> {
  @override
  late final MyWalletBloc bloc;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late RemoveListener removeListener;

  @override
  void dispose() {
    removeListener();
    super.dispose();
  }

  @override
  void initState() {
    bloc = context.read<MyWalletBloc>();
    removeListener = GetIt.I.get<AppState>().addListener((state) {
      if (state.action == ActionStateEnum.updateWallet &&
          state.payload is WalletModel &&
          state.isNewAction) {
        bloc.add(UpdateWalletEvent((state.payload as WalletModel)));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        backgroundColor: AppColors.white,
        child: BlocBuilder<MyWalletBloc, MyWalletState>(
          builder: (context, state) {
            return WalletDrawer(
              range: state.filterRange,
              paymentPurposeGroup: state.filterPaymentGroup,
              onRangeChanged: (range, paymentPurposeGroup) {
                context.read<MyWalletBloc>().add(
                      UpdateFilter(
                          range: range,
                          paymentPurposeGroup: paymentPurposeGroup),
                    );
              },
            );
          },
        ),
      ),
      backgroundColor: AppColors.greyLight,
      appBar: CustomAppBarWidget(
        centerTitle: false,
        autoGeneraIconLeading: false,
        title: 'Tài khoản của bạn',
        fontSizeTitle: 24,
        context: context,
        actions: const [SizedBox()],
        backgroundColor: AppColors.primaryMain.withAlpha(20),
      ),
      body: Stack(
        fit: StackFit.loose,
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: AppColors.primaryMain.withAlpha(20),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
          ),
          BlocBuilder<MyWalletBloc, MyWalletState>(
            builder: (context, state) {
              if (state.wallet == null) {
                return const SizedBox().appCenterProgressLoading;
              }
              return BodyWallet(
                wallet: state.wallet!,
                range: state.filterRange,
                paymentPurposeGroup: state.filterPaymentGroup,
              );
            },
          ),
        ],
      ),
    );
  }
}
