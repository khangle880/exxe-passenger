import 'package:exxe/src/utils/export/ui_export.dart';

class AvatarDriverWidget extends StatelessWidget {
  const AvatarDriverWidget({Key? key, this.radius = 30.0, this.image})
      : super(key: key);
  final double radius;
  final String? image;
  @override
  Widget build(BuildContext context) {
    if (image == null || image == 'false') {
      return Container(
        padding: const EdgeInsets.all(3.0),
        decoration: const ShapeDecoration(
          shape: CircleBorder(side: BorderSide(color: AppColors.primaryButton)),
          color: AppColors.primaryLight,
        ),
        child: CircleAvatar(
          radius: radius,
          backgroundImage: const AssetImage(
            AppIcons.userImage,
          ),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.all(3.0),
      decoration: const ShapeDecoration(
        shape: CircleBorder(side: BorderSide(color: AppColors.primaryButton)),
        color: AppColors.primaryLight,
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundImage:  NetworkImage(image!),
      ),
    );
  }
}
