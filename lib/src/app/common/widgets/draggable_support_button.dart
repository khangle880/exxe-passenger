import '../../../utils/export/ui_export.dart';

class DraggableSupportButton extends StatefulWidget {
  const DraggableSupportButton({Key? key}) : super(key: key);

  @override
  State<DraggableSupportButton> createState() => _DraggableButtonState();
}

class _DraggableButtonState extends State<DraggableSupportButton> {
  double _xPosition = -100.0;
  double _yPosition = -100.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final size = MediaQuery.of(context).size;
      setState(() {
        _xPosition = size.width - 60;
        _yPosition = size.height / 2 - 30;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 10),
      left: _xPosition,
      top: _yPosition,
      child: GestureDetector(
        onPanUpdate: (DragUpdateDetails details) {
          setState(() {
            _xPosition += details.delta.dx;
            _yPosition += details.delta.dy;
          });
        },
        child: GetIt.I<SupportButton>(),
      ),
    );
  }
}
