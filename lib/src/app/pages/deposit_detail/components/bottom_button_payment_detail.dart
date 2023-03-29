import 'package:exxe/src/utils/export/main_app.dart';

class BottomButtonPaymentDetail extends StatelessWidget {
  const BottomButtonPaymentDetail({
    super.key,
    required this.state,
    this.onTap,
  });
  final String state;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    if (state == 'success') {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          height: 44,
          margin: const EdgeInsets.only(left: 25, bottom: 25, right: 25),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.accBlueMain),
            borderRadius: BorderRadius.circular(12),
            color: AppColors.primaryLight,
          ),
          child: TextWidget(
            text: 'Quay lại trang chủ',
            weight: AppStyles.fontWeightW600,
            colorText: AppColors.accBlueMain,
            fontSize: AppDimens.text16,
          ),
        ),
      );
    }
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: 44,
        margin: const EdgeInsets.only(left: 25, bottom: 25, right: 25),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.accBlueMain,
        ),
        child: TextWidget(
          text: 'Thanh toán lại',
          weight: AppStyles.fontWeightW600,
          colorText: AppColors.primaryLight,
          fontSize: AppDimens.text16,
        ),
      ),
    );
  }
}
