
import 'package:flutter/material.dart';

class OverlayShape extends StatelessWidget {
  const OverlayShape({
    Key? key,
    required this.width,
    required this.ratio,
  }) : super(key: key);
  final double width;

  final double ratio;

  @override
  Widget build(BuildContext context) {
    double height = width / ratio;
    return Align(
      alignment: Alignment.center,
      child: CustomPaint(
        foregroundPainter: BorderPainter(),
        child: SizedBox(
          width: width,
          height: height * 0.80,
        ),
      ),
    );
  }
}

class BorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.1237458, 0);
    path_0.lineTo(size.width * 0.06688963, 0);
    path_0.cubicTo(size.width * 0.02994749, 0, 0, size.height * 0.04919945, 0,
        size.height * 0.1098901);
    path_0.lineTo(0, size.height * 0.1428571);
    path_0.lineTo(size.width * 0.01672241, size.height * 0.1428571);
    path_0.lineTo(size.width * 0.01672241, size.height * 0.1098901);
    path_0.cubicTo(
        size.width * 0.01672241,
        size.height * 0.06437198,
        size.width * 0.03918294,
        size.height * 0.02747253,
        size.width * 0.06688963,
        size.height * 0.02747253);
    path_0.lineTo(size.width * 0.1237458, size.height * 0.02747253);
    path_0.lineTo(size.width * 0.1237458, 0);
    path_0.close();
    path_0.moveTo(size.width * 0.8762542, size.height * 0.02747253);
    path_0.lineTo(size.width * 0.8762542, 0);
    path_0.lineTo(size.width * 0.9331104, 0);
    path_0.cubicTo(size.width * 0.9700535, 0, size.width,
        size.height * 0.04919951, size.width, size.height * 0.1098901);
    path_0.lineTo(size.width, size.height * 0.1428571);
    path_0.lineTo(size.width * 0.9832776, size.height * 0.1428571);
    path_0.lineTo(size.width * 0.9832776, size.height * 0.1098901);
    path_0.cubicTo(
        size.width * 0.9832776,
        size.height * 0.06437198,
        size.width * 0.9608161,
        size.height * 0.02747253,
        size.width * 0.9331104,
        size.height * 0.02747253);
    path_0.lineTo(size.width * 0.8762542, size.height * 0.02747253);
    path_0.close();
    path_0.moveTo(size.width * 0.8762542, size.height * 0.9725275);
    path_0.lineTo(size.width * 0.9331104, size.height * 0.9725275);
    path_0.cubicTo(
        size.width * 0.9608161,
        size.height * 0.9725275,
        size.width * 0.9832776,
        size.height * 0.9356264,
        size.width * 0.9832776,
        size.height * 0.8901099);
    path_0.lineTo(size.width * 0.9832776, size.height * 0.8516484);
    path_0.lineTo(size.width, size.height * 0.8516484);
    path_0.lineTo(size.width, size.height * 0.8901099);
    path_0.cubicTo(size.width, size.height * 0.9508022, size.width * 0.9700535,
        size.height, size.width * 0.9331104, size.height);
    path_0.lineTo(size.width * 0.8762542, size.height);
    path_0.lineTo(size.width * 0.8762542, size.height * 0.9725275);
    path_0.close();
    path_0.moveTo(size.width * 0.01672241, size.height * 0.8516484);
    path_0.lineTo(size.width * 0.01672241, size.height * 0.8901099);
    path_0.cubicTo(
        size.width * 0.01672241,
        size.height * 0.9356264,
        size.width * 0.03918294,
        size.height * 0.9725275,
        size.width * 0.06688963,
        size.height * 0.9725275);
    path_0.lineTo(size.width * 0.1237458, size.height * 0.9725275);
    path_0.lineTo(size.width * 0.1237458, size.height);
    path_0.lineTo(size.width * 0.06688963, size.height);
    path_0.cubicTo(size.width * 0.02994753, size.height, 0,
        size.height * 0.9508022, 0, size.height * 0.8901099);
    path_0.lineTo(0, size.height * 0.8516484);
    path_0.lineTo(size.width * 0.01672241, size.height * 0.8516484);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_fill);
  }

  @override
  bool shouldRepaint(BorderPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(BorderPainter oldDelegate) => false;
}
