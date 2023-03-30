import '../../../../utils/export/ui_export.dart';

class PickupCard<T> extends StatelessWidget {
  const PickupCard({
    Key? key,
    required this.isSelected,
    required this.onSelected,
    required this.child,
    this.width,
    this.height,
    this.padding,
  }) : super(key: key);
  final bool isSelected;
  final Function() onSelected;
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelected,
      child: Container(
        width: width,
        height: height,
        padding:
            padding ?? const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        alignment: Alignment.topLeft,
        decoration: isSelected
            ? BoxDecoration(
                color: AppColors.primaryMainBlur,
                border: Border.all(color: AppColors.primaryMain),
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                    BoxShadow(
                        offset: const Offset(0, 1),
                        blurRadius: 7,
                        spreadRadius: -2,
                        color: AppColors.primaryLight.withOpacity(0.05)),
                    BoxShadow(
                        offset: const Offset(0, 10),
                        blurRadius: 15,
                        spreadRadius: -3,
                        color: const Color(0xFFCACACA).withOpacity(0.1)),
                  ])
            : BoxDecoration(
                color: AppColors.primaryLight,
                border: Border.all(color: Colors.transparent),
                borderRadius: BorderRadius.circular(5),
                boxShadow: const [
                  BoxShadow(
                      color: AppColors.gray20, blurRadius: 1, spreadRadius: 1)
                ],
              ),
        child: child,
      ),
    );
  }
}
