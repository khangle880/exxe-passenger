import 'package:exxe/src/utils/export/ui_export.dart';

class ViewButtonDetails extends StatelessWidget {
  const ViewButtonDetails(
      {Key? key, required this.onClick, required this.isDetailsView})
      : super(key: key);
  final Function() onClick;
  final bool isDetailsView;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      child: Container(
        margin:
            EdgeInsets.symmetric(horizontal: size.width * 0.3, vertical: 5.0),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            !isDetailsView
                ? SvgPicture.asset(
                    AppIcons.directionTop,
                    color: AppColors.primaryButton,
                  )
                : SvgPicture.asset(
                    AppIcons.directionDown,
                    color: AppColors.primaryButton,
                  ),
            TextWidget(
              text: !isDetailsView ? 'Xem chi tiết' : 'Thu gọn',
              fontSize: AppDimens.text12,
              colorText: AppColors.primaryButton,
            ),
          ],
        ).inkWell(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 7.0),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: AppStyles.border10,
          ),
          onTap: () => onClick(),
        ),
      ),
    );
  }
}
