import 'package:exxe/src/utils/export/ui_export.dart';

class NoCompoundingNote extends StatelessWidget {
  const NoCompoundingNote({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: DrawNoteNoCompounding(),
      child: Container(
        padding:
            const EdgeInsets.only(bottom: 8.0, left: 8.0, top: 8.0, right: 8.5),
        width: MediaQuery.of(context).size.width * 0.33,
        height: 50,
        color: AppColors.primaryButton,
        child: TextWidget(
          text: 'Kéo để xem những chuyến đi phù hợp',
          fontSize: AppDimens.text12,
          colorText: AppColors.textLight,
          weight: FontWeight.w600,
          maxLine: 3,
        ),
      ),
    );
  }
}

class DrawNoteNoCompounding extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    //border right container
    path.lineTo(size.width * 0.9, 0.0);
    path.quadraticBezierTo(size.width * 0.95, size.height * 0.0,
        size.width * 0.95, size.height * 0.15);
    path.lineTo(size.width * 0.95, size.height * 0.2);
    path.lineTo(size.width, size.height * 0.3);
    path.lineTo(size.width * 0.95, size.height * 0.4);
    path.lineTo(size.width * 0.95, size.height * 0.85);
    path.quadraticBezierTo(
        size.width * 0.95, size.height, size.width * 0.9, size.height);

    //border left container
    path.lineTo(size.width * 0.05, size.height);
    path.quadraticBezierTo(0, size.height, size.width * 0, size.height * 0.85);
    path.lineTo(size.width * 0, size.height * 0.15);
    path.quadraticBezierTo(
        size.width * 0, 0, size.width * 0.05, size.height * 0);
    path.lineTo(size.width * 0.05, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
