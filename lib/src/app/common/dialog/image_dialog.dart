import 'package:exxe/src/utils/export/main_app.dart';

class ImageDialog extends StatelessWidget {
  final String image;
  const ImageDialog({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 2,
        decoration: BoxDecoration(
            image:
                DecorationImage(image: NetworkImage(image), fit: BoxFit.fill)),
      ),
    );
  }
}
