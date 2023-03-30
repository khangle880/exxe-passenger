import 'package:exxe/src/utils/export/ui_export.dart';

class IconArrowBackCircle extends StatelessWidget {
  const IconArrowBackCircle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child:
          Icon(Icons.arrow_back_ios, size: 20.0, color: AppColors.primaryDark),
    ).inkWell(
      onTap: () => Navigator.pop(context),
      height: 40,
      width: 40,
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      decoration: const ShapeDecoration(
        color: AppColors.primaryLight,
        shape: CircleBorder(),
      ),
    );
  }
}
