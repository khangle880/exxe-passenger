import 'package:exxe/src/utils/export/ui_export.dart';

class CancelReasonDialog extends StatelessWidget {
  const CancelReasonDialog({
    Key? key,
    required this.onConfirm,
  }) : super(key: key);
  final Function() onConfirm;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
        width: 352,
        height: 403,
        child: Material(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "assets/images/trip/canceled_trip_success.jpg",
                width: 210,
                height: 208, 
              ),
              const SizedBox(height: 16),
              Text("Chuyến đi đã huỷ!", style: AppStyles.s18w7),
              const SizedBox(height: 4),
              Text("Mong được đồng hành cùng bạn trong những chuyến đi tiếp theo",
                  style: AppStyles.s14w4.withColor(AppColors.gray70x76),maxLines: 2,textAlign:TextAlign.center,),
              const SizedBox(height: 16),
              ButtonWidget(
                onClick: onConfirm,
                radius: 12,
                child: Text(
                  "Hoàn tất",
                  style: AppStyles.s16w6.withColor(AppColors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
