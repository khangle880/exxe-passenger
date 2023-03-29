import '../../../../utils/export/ui_export.dart';

class TipPicker extends StatefulWidget {
  const TipPicker(
      {Key? key, required this.totalAmount, required this.onChanged})
      : super(key: key);
  final num totalAmount;
  final Function(int tip) onChanged;

  @override
  State<TipPicker> createState() => _TipPickerState();
}

class _TipPickerState extends State<TipPicker> {
  late final int nearTip;
  int currentTip = 0;
  final multiple = 50000;

  @override
  void initState() {
    super.initState();
    nearTip =
        widget.totalAmount.roundUp(multiple).ceil() - widget.totalAmount.ceil();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          if (nearTip < multiple) _buildTipItem(nearTip),
          ...List.generate((1000000 ~/ multiple),
              (index) => _buildTipItem(multiple * (index + 1)))
        ],
      ),
    );
  }

  _buildTipItem(int price) {
    final isSelected = price == currentTip;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            if (isSelected) {
              price = 0;
            }
            widget.onChanged(price);
            setState(() {
              currentTip = price;
            });
          },
          hoverColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryMain : AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? Colors.transparent : AppColors.gray50,
              ),
            ),
            height: 40.0,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            alignment: Alignment.center,
            child: Text(
              price.currencyFormat,
              style: AppStyles.s15w6.withColor(
                isSelected ? AppColors.primaryLight : AppColors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
