import 'package:exxe/src/utils/export/ui_export.dart';

import '../../../../data/data.dart';

class ItemVoucherWidget extends StatelessWidget {
  final PromotionModel promotionModel;
  final double maxWidth;
  final double maxHeight;

  const ItemVoucherWidget(
      {Key? key,
      required this.promotionModel,
      required this.maxWidth,
      required this.maxHeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPaint(
          size: Size(maxWidth, maxHeight),
          painter: DrawVoucher(),
          child: Container(
            width: maxWidth,
            height: maxHeight,
            padding: EdgeInsets.symmetric(
                horizontal: maxWidth - maxWidth * 0.96,
                vertical: maxHeight * 0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  flex: 2,
                  child: SvgPicture.asset(AppIcons.ticket),
                ),
                Expanded(
                  flex: 7,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextWidget(
                          text: '${promotionModel.promotionName}',
                          fontSize: 12,
                          maxLine: 1,
                          colorText: AppColors.textError,
                          weight: FontWeight.w600,
                        ),
                        if (promotionModel.promotionBrief != null) ...[
                          const SizedBox(height: 4.0),
                          SizedBox(
                            width: maxWidth * 0.6,
                            child: TextWidget(
                              text: promotionModel.promotionBrief!,
                              fontSize: 12,
                              colorText: AppColors.gray70x76,
                              maxLine: 2,
                              weight: FontWeight.w300,
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    ).inkWell(
      onTap: () => Navigator.pushNamed(
        context,
        Routes.promotionDetailPage,
        arguments: {"promotionId": promotionModel.promotionId},
      ),
    );
  }
}

class DrawVoucher extends CustomPainter {
  final Radius radius = const Radius.circular(10.0);
  final backgroundColor = AppColors.white;

  @override
  void paint(Canvas canvas, Size size) {
    _drawBackground(canvas, size);
    _drawBorderSide(canvas, size);
    double start = size.height * 0.08;
    double end = size.height * 0.13;
    Paint paintListDot = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.5;

    for (int i = 0; i < size.height ~/ (size.height * 0.1); i++) {
      canvas.drawLine(Offset(size.width * 0.25, start),
          Offset(size.width * 0.25, end), paintListDot);
      if (start >= size.height * 0.8) return;
      start += size.height * 0.1;
      end = start + size.height * 0.05;
    }
  }

  _drawBackground(Canvas canvas, Size size) {
    Paint paintDrawRect = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    Path path = Path();
    path.moveTo(0, size.height * 0.15);
    path.quadraticBezierTo(0, 0, size.width * 0.05, 0);
    path.lineTo(size.width * 0.95, 0);
    path.quadraticBezierTo(size.width, 0, size.width, size.height * 0.15);
    // bẻ center right
    path.lineTo(size.width, size.height * 0.35);
    path.quadraticBezierTo(
        size.width, size.height * 0.4, size.width * 0.98, size.height * 0.4);
    path.arcToPoint(Offset(size.width * 0.98, size.height * 0.6),
        clockwise: false, radius: radius);
    path.quadraticBezierTo(
        size.width, size.height * 0.6, size.width, size.height * 0.65);
    //end
    path.lineTo(size.width, size.height * 0.85);
    path.quadraticBezierTo(
        size.width, size.height, size.width * 0.95, size.height);
    path.lineTo(size.width * 0.05, size.height);
    path.quadraticBezierTo(0, size.height, size.width * 0, size.height * 0.85);
    //bẻ center left
    path.lineTo(0, size.height * 0.75);
    path.quadraticBezierTo(
        0, size.height * 0.6, size.width * 0.02, size.height * 0.6);
    path.arcToPoint(Offset(size.width * 0.02, size.height * 0.4),
        clockwise: false, radius: radius);
    path.quadraticBezierTo(0, size.height * 0.4, 0, size.height * 0.35);
    path.lineTo(0, size.height * 0.15);
    //end
    canvas.drawPath(path, paintDrawRect);
  }

  _drawBorderSide(Canvas canvas, Size size) {
    Paint paintDrawRect = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = .7;
    Path path = Path();
    path.moveTo(0, size.height * 0.15);
    path.quadraticBezierTo(0, 0, size.width * 0.05, 0);
    path.lineTo(size.width * 0.95, 0);
    path.quadraticBezierTo(size.width, 0, size.width, size.height * 0.15);
    // bẻ center right
    path.lineTo(size.width, size.height * 0.35);
    path.quadraticBezierTo(
        size.width, size.height * 0.4, size.width * 0.98, size.height * 0.4);
    path.arcToPoint(Offset(size.width * 0.98, size.height * 0.6),
        clockwise: false, radius: radius);
    path.quadraticBezierTo(
        size.width, size.height * 0.6, size.width, size.height * 0.65);
    //end
    path.lineTo(size.width, size.height * 0.85);
    path.quadraticBezierTo(
        size.width, size.height, size.width * 0.95, size.height);
    path.lineTo(size.width * 0.05, size.height);
    path.quadraticBezierTo(0, size.height, size.width * 0, size.height * 0.85);
    //bẻ center left
    path.lineTo(0, size.height * 0.75);
    path.quadraticBezierTo(
        0, size.height * 0.6, size.width * 0.02, size.height * 0.6);
    path.arcToPoint(Offset(size.width * 0.02, size.height * 0.4),
        clockwise: false, radius: radius);
    path.quadraticBezierTo(0, size.height * 0.4, 0, size.height * 0.35);
    path.lineTo(0, size.height * 0.15);
    //end
    canvas.drawPath(path, paintDrawRect);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
