import '../../../core/base_state.dart';
import '../../../utils/export/ui_export.dart';
import 'controllers/recharge_money_cubit.dart';

class RechargeMoneyPage extends StatefulWidget {
  const RechargeMoneyPage({Key? key}) : super(key: key);

  @override
  BaseState<RechargeMoneyPage, RechargeMoneyCubit> createState() =>
      _RechargeMoneyPageState();
}

class _RechargeMoneyPageState
    extends BaseState<RechargeMoneyPage, RechargeMoneyCubit> {
  @override
  late final RechargeMoneyCubit bloc;
  final _formKey = GlobalKey<FormState>();

  @override
  void initData() {
    bloc = context.read<RechargeMoneyCubit>();
    super.initData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RechargeMoneyCubit, RechargeMoneyState>(
      listener: (context, state) {
        if (state.paymentRequest != null) {
          Future.delayed(const Duration(milliseconds: 0), () {
            Navigator.pushReplacementNamed(
              context,
              Routes.transactionDetail,
              arguments: {
                'paymentId': state.paymentRequest!.paymentId,
                'vnPayCode': state.paymentRequest!.vnpayCode,
              },
            );
          });
          AppMethodChannel.I
              .openVnpaySdk(state.paymentRequest!.vnpayPaymentUrl!);
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: _buildBody(state),
        );
      },
    );
  }

  _buildBody(RechargeMoneyState state) {
    return Form(
      key: _formKey,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBarWidget(
          backgroundColor: AppColors.greyLight,
          title: "Nạp tiền",
          context: context,
        ),
        backgroundColor: AppColors.gray05,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          child: Column(
            children: [
              MoneyInputWidget(
                hintText: "Nhập số tiền cần nạp",
                onChanged: (int value) {
                  bloc.changeAmount(value);
                },
              ),
              Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 24, bottom: 16),
                  child: Text("Phương thức nạp tiền", style: AppStyles.s18w7)),
              state.paymentMethods == null
                  ? const SizedBox()
                  : state.paymentMethods!.isEmpty
                      ? Text("Không có phương thức nạp tiền phù hợp",
                          style: AppStyles.s16w6)
                      : PaymentMethodsWidget(
                          paymentMethods: state.paymentMethods,
                          currentPaymentMethod: state.currentMethod,
                          onChanged: (e) => bloc.changeCurrentMethod(e),
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
                      "Mọi thông tin của bạn đều sẽ được chúng tôi mã hóa để bảo mật thông tin khách hàng",
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
            onClick: state.amount != null && state.currentMethod != null
                ? () {
                    if (_formKey.currentState!.validate()) {
                      bloc.createPaymentRequest();
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
