import '../../../../data/data.dart';
import '../../../../utils/export/ui_export.dart';

class BottomButtons extends StatelessWidget {
  const BottomButtons({
    super.key,
    required this.customer,
    this.responseCode,
  });

  final CompoundingCarCustomerModel customer;
  final String? responseCode;

  @override
  Widget build(BuildContext context) {
    if (customer.state == null) {
      return SizedBox(
        width: double.maxFinite,
        child: ButtonWidget(
          onClick: () {
            Navigator.popUntil(
              context,
              ModalRoute.withName(Routes.home),
            );
          },
          radius: 12,
          enableBackgroundColor: AppColors.primaryMain.withAlpha(10),
          child: Text(
            'Trang chủ',
            style: AppStyles.s16w6.withColor(AppColors.primaryMain),
          ),
        ),
      );
    }
    if (customer.state!.index >= CompoundingCarCustomerState.deposit.index) {
      return ButtonWidget(
        onClick: () {
          Navigator.pop(context);
        },
        radius: 12,
        enableBackgroundColor: AppColors.primaryMain.withAlpha(10),
        child: Text(
          'Trang chủ',
          style: AppStyles.s16w6.withColor(AppColors.primaryMain),
        ),
      );
    }
    if (responseCode == null || responseCode == "00") {
      return const SizedBox();
    }
    return ButtonWidget(
      onClick: () {
        Navigator.pushReplacementNamed(
          context,
          Routes.deposit,
          arguments: customer,
        );
      },
      radius: 12,
      enableBackgroundColor: AppColors.primaryMain,
      child: Text(
        'Thanh toán lại',
        style: AppStyles.s16w6.withColor(AppColors.primaryLight),
      ),
    );
  }
}
