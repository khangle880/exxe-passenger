import '../../../../data/data.dart';
import '../../../../utils/export/ui_export.dart';
import '../controllers/confirm_booking_cubit.dart';

class VoucherPicker extends StatelessWidget {
  const VoucherPicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ConfirmBookingCubit>();
    return BlocBuilder<ConfirmBookingCubit, ConfirmBookingState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              Routes.promotionPage,
              arguments: {
                'carCustomerId': state.customerModel.compoundingCarCustomerId,
                'currentPromo': state.customerModel.promotion,
              },
            ).then((value) {
              if (value is CompoundingCarCustomerModel) {
                bloc.updateField(customerModel: value);
              }
            });
          },
          child: Container(
              decoration: BoxDecoration(
                color: AppColors.gray60x9d +
                    AppColors.primaryLight.withOpacity(0.9),
                borderRadius: BorderRadius.circular(8),
              ),
              height: 44,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 15.33, right: 11.3),
                    alignment: Alignment.centerLeft,
                    child: SvgPicture.asset(
                      AppIcons.ticket_discount,
                      width: 19,
                      height: 19,
                      color:
                          state.customerModel.promotion?.promotionCode != null
                              ? AppColors.primaryMain
                              : AppColors.gray90 +
                                  AppColors.gray90.withOpacity(0.9),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                        state.customerModel.promotion?.promotionCode ??
                            "Chọn mã giảm giá",
                        style: state.customerModel.promotion?.promotionCode !=
                                null
                            ? AppStyles.s14w4.withColor(AppColors.primaryMain)
                            : AppStyles.s14w4.withColor(AppColors.gray70x76)),
                  ),
                  Expanded(
                      flex: 1,
                      child: Container(
                        margin: const EdgeInsets.only(right: 18.17),
                        alignment: Alignment.centerRight,
                        child: const Icon(
                          Icons.keyboard_arrow_right,
                          color: AppColors.gray70x76,
                          size: 20,
                        ),
                      ))
                ],
              )),
        );
      },
    );
  }
}
