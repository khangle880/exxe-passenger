import '../../../core/base_state.dart';
import '../../../core/error/error.dart';
import '../../../data/data.dart';
import '../../../utils/export/ui_export.dart';
import 'controllers/withdraw_money_cubit.dart';

class WithdrawMoneyPage extends StatefulWidget {
  const WithdrawMoneyPage({Key? key}) : super(key: key);

  @override
  BaseState<WithdrawMoneyPage, WithdrawMoneyCubit> createState() =>
      _WithdrawMoneyPageState();
}

class _WithdrawMoneyPageState
    extends BaseState<WithdrawMoneyPage, WithdrawMoneyCubit> {
  final _formKey = GlobalKey<FormState>();
  int? availableWithdraw;

  @override
  late final WithdrawMoneyCubit bloc;

  @override
  void initState() {
    bloc = context.read<WithdrawMoneyCubit>();
    super.initState();
    bloc.getAvailableMoney();
    GetIt.I<IWalletRepo>().getAvailableMoneyCanWithdrawing().then((value) {
      value.fold((l) => log(l.toString()), (r) {
        setState(() {
          availableWithdraw = r.ceil();
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WithdrawMoneyCubit, WithdrawMoneyState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: _buildBody(state),
        );
      },
    );
  }

  _buildBody(WithdrawMoneyState state) {
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: AppColors.greyLight,
        appBar: CustomAppBarWidget(
          backgroundColor: AppColors.greyLight,
          title: "Rút tiền",
          context: context,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 16),
              MoneyInputWidget(
                hintText: "Nhập số tiền cần rút",
                onChanged: (int value) {
                  bloc.changeAmount(value);
                },
                isWithdraw: true,
              ),
              const SizedBox(height: 4),
              if (availableWithdraw != null)
                Container(
                  alignment: Alignment.centerLeft,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: Text(
                    "(*) Số tiền tối đa bạn có thể rút là: ${availableWithdraw!.currencyFormat}",
                    style: AppStyles.s15w4,
                  ),
                ),
              const Spacer(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset(AppIcons.security,
                      height: 20, width: 20, color: AppColors.green60),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      "Mọi thông tin đều sẽ được chúng tôi mã hóa để bảo mật",
                      style: AppStyles.s14w4.withColor(AppColors.gray50),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: ButtonWidget(
            onClick: state.amount != null
                ? () {
                    if (_formKey.currentState!.validate()) {
                      final phoneNumber =
                          GetIt.I<AppState>().currentState.user?.phone;
                      if (phoneNumber == null) {
                        AppDialog.I.showWarning(
                            message:
                                "Bạn không thể rút tiền vì chưa đăng ký số điện thoại");
                      } else {
                        Navigator.pushNamed(
                          context,
                          Routes.otp,
                          arguments: phoneNumber.convertToCountryPhoneCode(),
                        ).then((value) {
                          if (value is String) {
                            bloc.createPaymentRequest().then((value) {
                              GetIt.I
                                  .get<AppState>()
                                  .createAction(ActionStateEnum.withdraw);
                              Navigator.pushReplacementNamed(
                                context,
                                Routes.transactionDetail,
                                arguments: {'paymentId': value.paymentId},
                              );
                            }).catchError((failure) {
                              if (failure is Failure) {
                                failure.showDefaultDialog();
                              }
                            });
                          }
                        });
                      }
                    }
                  }
                : null,
            child: Text("Tiếp tục",
                style: AppStyles.s16w6.withColor(AppColors.primaryLight)),
          ),
        ),
      ),
    );
  }
}
