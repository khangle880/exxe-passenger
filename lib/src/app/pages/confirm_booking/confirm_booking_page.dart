import 'package:exxe/src/utils/export/ui_export.dart';
import '../../../core/base_state.dart';
import '../../../data/data.dart';
import '../deposit/components/invoice_checker.dart';
import 'components/components.dart';
import 'controllers/confirm_booking_cubit.dart';

class ConfirmBookingPage extends StatefulWidget {
  const ConfirmBookingPage({Key? key}) : super(key: key);

  @override
  State<ConfirmBookingPage> createState() => _ConfirmBookingPageState();
}

class _ConfirmBookingPageState
    extends BaseState<ConfirmBookingPage, ConfirmBookingCubit> {
  late final ScrollController _controller;
  final _formKey = GlobalKey<FormState>();

  late final ConfirmBookingCubit cubit;

  @override
  ConfirmBookingCubit get bloc => cubit;

  @override
  void initData() {
    cubit = context.read<ConfirmBookingCubit>();
    _controller = ScrollController();
    super.initData();
  }

  @override
  void dispose() {
    _controller.dispose();
    final customerModel = bloc.state.customerModel;
    if (customerModel.state!.index <
        CompoundingCarCustomerState.confirm.index) {
      GetIt.I<IPromotionRepo>()
          .cancelApplyPromotion(customerModel.compoundingCarCustomerId!);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: AppColors.gray05,
        appBar: CustomAppBarWidget(
          backgroundColor: AppColors.greyLight,
          title: "Xác Nhận",
          context: context,
        ),
        bottomNavigationBar:
            BlocBuilder<ConfirmBookingCubit, ConfirmBookingState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, bottom: 20, top: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const ExxeRuleChecker(),
                  const SizedBox(height: 8),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: ButtonWidget(
                      onClick: state.isExxeRuleChecked
                          ? () {
                              if (_formKey.currentState!.validate()) {
                                bloc.onConfirm().then((value) {
                                  if (mounted) {
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      Routes.deposit,
                                      ModalRoute.withName(Routes.home),
                                      arguments: value,
                                    );
                                  }
                                });
                              }
                            }
                          : null,
                      radius: 12.0,
                      child: Text("Tiếp tục",
                          style: AppStyles.s16w6
                              .withColor(AppColors.primaryLight)),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        body: BlocBuilder<ConfirmBookingCubit, ConfirmBookingState>(
          builder: (context, state) {
            return SingleChildScrollView(
              controller: _controller,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, bottom: 16, top: 8),
                    child: BookingInfoWidget.topCollapsed(state.customerModel),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        //thong tin chuyen di
                        Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Thông tin chuyến đi",
                              style:
                                  AppStyles.s18w7.withColor(AppColors.gray95),
                            )),
                        const SizedBox(height: 8),
                        ConfirmBookingTripInfo(state.customerModel),

                        const SizedBox(height: 12),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text("Mã giảm giá",
                              style:
                                  AppStyles.s15w6.withColor(AppColors.gray95)),
                        ),

                        // promotion
                        const SizedBox(height: 8),
                        const VoucherPicker(),

                        const SizedBox(
                          height: 8,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.centerLeft,
                          child: Text("Chi phí",
                              style:
                                  AppStyles.s18w7.withColor(AppColors.gray95)),
                        ),

                        const SizedBox(height: 8),
                        RidePaymentInfo(
                          state.customerModel,
                          onChangedDownPaymentPercent: (percent) {
                            bloc.updateDepositPercent(percent);
                          },
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '(*) Số tiền này chưa bao gồm chi phí cầu đường, bãi bến',
                                style: AppStyles.s14w4
                                    .withColor(AppColors.gray70x76),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  InvoiceChecker(
                    phone: state.companyPhone,
                    name: state.companyName,
                    address: state.companyAddress,
                    taxCode: state.companyTaxCode,
                    email: state.companyEmail,
                    onNameChanged: (value) =>
                        bloc.updateField(companyName: value),
                    onAddressChanged: (value) =>
                        bloc.updateField(companyAddress: value),
                    onTaxCodeChanged: (value) =>
                        bloc.updateField(companyTaxCode: value),
                    onPhoneChanged: (value) =>
                        bloc.updateField(companyPhone: value),
                    onEmailChanged: (value) =>
                        bloc.updateField(companyEmail: value),
                    onCheckChanged: (value) {
                      bloc.updateField(isExportInvoiceChecked: value);
                      if (value) {
                        Future.delayed(const Duration(milliseconds: 200), () {
                          _controller.animateTo(
                              _controller.position.maxScrollExtent,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut);
                        });
                      }
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    ).gestureDetector(onTap: () {
      FocusManager.instance.primaryFocus?.unfocus();
    });
  }
}
