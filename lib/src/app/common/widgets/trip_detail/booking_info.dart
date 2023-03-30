import '../../../../data/models/models.dart';
import '../../../../utils/export/ui_export.dart';
import '../measure_size.dart';

class BookingInfoWidget extends StatefulWidget {
  const BookingInfoWidget({
    Key? key,
    this.customer,
    this.separateColor,
    this.title,
    this.paymentInfo,
    this.onCancel,
    required this.topView,
    required this.bottomView,
  }) : super(key: key);

  final CompoundingCarCustomerModel? customer;
  final Color? separateColor;
  final String? title;
  final PaymentModel? paymentInfo;
  final Function()? onCancel;
  final Widget topView;
  final Widget bottomView;

  factory BookingInfoWidget.normal(CompoundingCarCustomerModel customer) {
    return BookingInfoWidget(
      customer: customer,
      topView: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: TripDistanceDetail.info(
            title: Text('Loại chuyến', style: AppStyles.s16w7),
            customer: customer),
      ),
      bottomView: Padding(
        padding: const EdgeInsets.only(top: 18, bottom: 12),
        child: BookingMoneyInfo(
          customer: customer,
        ),
      ),
    );
  }

  /// collapse distance detail top section
  factory BookingInfoWidget.topCollapsed(
      CompoundingCarCustomerModel carCustomer) {
    return BookingInfoWidget(
      customer: carCustomer,
      topView: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Chuyến đi của bạn",
              style: AppStyles.s16w6.withColor(AppColors.gray90x27),
            ),
            TypeStatusWidget.compoundingType(carCustomer.compoundingType!),
          ],
        ),
      ),
      bottomView: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: DistanceInfoWidget.info(carCustomer),
      ),
    );
  }

  factory BookingInfoWidget.topCollapsedPickStation(
    CompoundingCarCustomerModel customer, {
    required Function() onTapFromProvinceName,
    required Function() onTapToProvinceName,
  }) {
    return BookingInfoWidget(
      topView: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Chuyến đi của bạn",
              style: AppStyles.s16w6.withColor(AppColors.gray90x27),
            ),
            TypeStatusWidget.compoundingType(customer.compoundingType!),
          ],
        ),
      ),
      bottomView: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: DistancePickStation(
          onTapFromProvinceName: onTapFromProvinceName,
          onTapToProvinceName: onTapToProvinceName,
          pickupPoint: customer.fromLocation,
          destinationPoint: customer.toLocation,
          pickupAddress: customer.isPickingUpFromStart ?? false
              ? customer.fromAddress
              : null,
        ),
      ),
    );
  }

  @override
  State<BookingInfoWidget> createState() => _BookingInfoWidgetState();
}

class _BookingInfoWidgetState extends State<BookingInfoWidget> {
  double separateTop = 146;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: SeparateSectionHasClipDraw(separateTop),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            MeasureSize(
              onChange: (size) {
                separateTop = size.height - 18;
                log(size.height.toString());
                setState(() {});
              },
              child: widget.topView,
            ),
            widget.bottomView,
          ],
        ),
      ),
    );
  }
}

class BookingMoneyInfo extends StatelessWidget {
  const BookingMoneyInfo({Key? key, required this.customer}) : super(key: key);
  final CompoundingCarCustomerModel customer;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "Thông tin chuyến đi",
              style: AppStyles.s16w6.withColor(AppColors.gray95x14),
            )),
        const SizedBox(height: 8),
        RideInfoRow(
          "Mã chuyến đi",
          value: customer.compoundingCarCustomerCode,
          padding: const EdgeInsets.only(bottom: 4.0),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Thời gian xuất phát',
              style: AppStyles.s14w4.withColor(AppColors.gray70x76),
            ),
            Text(
              customer.expectedGoingOnDate!.getDateTimeString,
              style: AppStyles.s14w4.withColor(AppColors.primaryMain),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Loại xe",
              style: AppStyles.s14w4.withColor(AppColors.gray70x76),
            ),
            Text(
              customer.car!.name!,
              style: AppStyles.s14w4.withColor(AppColors.gray95x14),
            ),
          ],
        ),
        const SizedBox(height: 4),
        if (customer.numberAvailableSeat != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Số khách",
                style: AppStyles.s14w4.withColor(AppColors.gray70x76),
              ),
              Text(
                '${customer.numberSeat!.ceil()} khách',
                style: AppStyles.s14w4.withColor(AppColors.gray95x14),
              ),
            ],
          ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Giá tiền",
              style: AppStyles.s14w6.withColor(
                  AppColors.primaryMain + AppColors.black.withOpacity(0.4)),
            ),
            Text(
              (customer.priceUnit?.priceUnit ?? customer.amountTotal)!
                  .ceil()
                  .currencyFormat,
              style: AppStyles.s16w6.withColor(AppColors.utilRed),
            ),
          ],
        ),
      ],
    );
  }
}

class SeparateSectionHasClipDraw extends CustomPainter {
  final double separateTop;

  SeparateSectionHasClipDraw(this.separateTop);

  @override
  void paint(Canvas canvas, Size size) {
    relativeY(double y) => y - 172 + separateTop + 17;
    Path path_0 = Path();
    path_0.moveTo(0, size.height * 0.03197674);
    path_0.cubicTo(0, size.height * 0.01431686, size.width * 0.01375698, 0,
        size.width * 0.03072626, 0);
    path_0.lineTo(size.width * 0.9692737, 0);
    path_0.cubicTo(size.width * 0.9862430, 0, size.width,
        size.height * 0.01431686, size.width, size.height * 0.03197674);
    path_0.lineTo(size.width, relativeY(154.165));
    // corner right start
    path_0.cubicTo(size.width, relativeY(160.176), size.width * 0.9831006,
        relativeY(165.121), size.width * 0.9757067, relativeY(170.517));
    path_0.cubicTo(
        size.width * 0.9739162,
        relativeY(171.824),
        size.width * 0.9729106,
        relativeY(173.295),
        size.width * 0.9729106,
        relativeY(174.849));
    path_0.lineTo(size.width * 0.9729106, relativeY(175.151));
    path_0.cubicTo(
        size.width * 0.9729106,
        relativeY(176.705),
        size.width * 0.9739162,
        relativeY(178.176),
        size.width * 0.9757067,
        relativeY(179.483));
    path_0.cubicTo(size.width * 0.9831006, relativeY(184.879), size.width,
        relativeY(189.824), size.width, relativeY(195.835));
    // corner right end
    path_0.lineTo(size.width, size.height * 0.9680233);
    path_0.cubicTo(size.width, size.height * 0.9856831, size.width * 0.9862430,
        size.height, size.width * 0.9692737, size.height);
    path_0.lineTo(size.width * 0.03072626, size.height);
    path_0.cubicTo(size.width * 0.01375698, size.height, 0,
        size.height * 0.9856831, 0, size.height * 0.9680233);
    path_0.lineTo(0, relativeY(195.835));
    // corner left start
    path_0.cubicTo(0, relativeY(189.824), size.width * 0.01689665,
        relativeY(184.879), size.width * 0.02429050, relativeY(179.483));
    path_0.cubicTo(
        size.width * 0.02608380,
        relativeY(178.176),
        size.width * 0.02708939,
        relativeY(176.705),
        size.width * 0.02708939,
        relativeY(175.151));
    path_0.lineTo(size.width * 0.02708939, relativeY(174.849));
    path_0.cubicTo(
        size.width * 0.02708939,
        relativeY(173.295),
        size.width * 0.02608380,
        relativeY(171.824),
        size.width * 0.02429050,
        relativeY(170.517));
    path_0.cubicTo(size.width * 0.01689665, relativeY(165.121), 0,
        relativeY(160.176), 0, relativeY(154.165));
    // corner left end
    path_0.lineTo(0, size.height * 0.03197674);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_fill);

    Paint paint_1_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004189944;
    paint_1_stroke.color = Color(0xffE7E7E7).withOpacity(1.0);

    const int dashWidth = 8;
    const int dashSpace = 8;

    // Start to draw from left size.
    // Of course, you can change it to match your requirement.
    double startX = size.width * 0.04469274;
    double y = relativeY(175.121);

    // Repeat drawing until we reach the right edge.
    // In our example, size.with = 300 (from the SizedBox)
    while (startX < size.width * 0.9553073) {
      // Draw a small line.
      canvas.drawLine(
          Offset(startX, y), Offset(startX + dashWidth, y), paint_1_stroke);

      // Update the starting X
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class SeparateSectionDraw extends CustomPainter {
  SeparateSectionDraw();

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_1_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004189944;
    paint_1_stroke.color = Color(0xffE7E7E7).withOpacity(1.0);

    const int dashWidth = 8;
    const int dashSpace = 8;

    double startX = size.width * 0;
    double y = size.height * 0.5;

    while (startX < size.width * 1) {
      canvas.drawLine(
          Offset(startX, y), Offset(startX + dashWidth, y), paint_1_stroke);

      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
