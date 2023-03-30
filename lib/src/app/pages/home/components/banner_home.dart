import 'dart:async';
import 'package:exxe/src/utils/export/ui_export.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

final List<String> imgList = [
  'assets/images/banner/ban1.jpg',
  'assets/images/banner/ban2.jpg',
  'assets/images/banner/ban3.jpg',
];

class BannerHome extends StatefulWidget {
  const BannerHome({Key? key}) : super(key: key);

  @override
  State<BannerHome> createState() => _BannerHomeState();
}

class _BannerHomeState extends State<BannerHome> {
  late Timer? timer;

  ValueNotifier<int> current = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    getTimer();
  }

  void clearTimer() {
    if (timer != null) {
      timer?.cancel();
      timer = null;
    }
  }

  getTimer() {
    timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      final lastIndex = (imgList.length - 1);
      current.value++;
      if (current.value > lastIndex) current.value = 0;
    });
  }

  void resumeTimer() {
    getTimer();
  }

  @override
  void dispose() {
    clearTimer();
    current.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      builder: (context, int index, child) {
        return GestureDetector(
          onTapDown: (_) {
            clearTimer();
          },
          onTapUp: (_) {
            resumeTimer();
          },
          onLongPressEnd: (_) {
            resumeTimer();
          },
          onHorizontalDragEnd: (details) {
            clearTimer();
            resumeTimer();
            // Swiping in right direction.
            final lastIndex = (imgList.length - 1);
            log(details.toString());
            double primaryVelocity = details.primaryVelocity ?? 0;
            if (primaryVelocity < 0) {
              setState(() {
                current.value++;
                if (current.value > lastIndex) current.value = 0;
              });
            } else if (primaryVelocity > 0) {
              // Swiping in left direction.
              setState(() {
                current.value--;
                if (current.value < 0) current.value = lastIndex;
              });
            }
          },
          child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeOut,
              child: _buildBannnerItem(context)),
        );
      },
      valueListenable: current,
    );
  }

  Widget _buildBannnerItem(BuildContext context) {
    return Container(
      key: ValueKey('${current.value}'),
      margin: const EdgeInsets.symmetric(horizontal: 24.0),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.topCenter,
      child: AspectRatio(
        aspectRatio: 342 / 193,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image(
              image: AssetImage(imgList[current.value]),
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fill,
            ),
            Align(
              alignment: const Alignment(0.0, 0.8),
              child: AnimatedSmoothIndicator(
                onDotClicked: (value) {
                  setState(() {
                    current.value = value;
                  });
                },
                activeIndex: current.value,
                count: imgList.length,
                effect: const SwapEffect(
                  activeDotColor: Colors.blue,
                  dotColor: Colors.white,
                  dotWidth: 8,
                  dotHeight: 8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomDotSlide extends CustomPainter {
  const CustomDotSlide({
    required this.nextIndex,
    required this.lengthDot,
    required this.currentIndex,
  });

  final int lengthDot;
  final int currentIndex;
  final int nextIndex;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paintActive = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;
    Paint paintNotActive = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;
    double startPoint = lengthDot == 3 ? size.width * 0.45 : size.width * 0.42;
    double heightPoint = size.height * 0.85;
    for (int i = 1; i <= lengthDot; i++) {
      if (i == 1) {
        canvas.drawCircle(Offset(startPoint, heightPoint), 5, paintActive);
      } else {
        canvas.drawCircle(Offset(startPoint, heightPoint), 5, paintNotActive);
      }
      startPoint += size.width * 0.05;
    }
  }

  @override
  bool shouldRepaint(CustomDotSlide oldDelegate) =>
      oldDelegate.currentIndex != currentIndex || lengthDot > 1;
}
