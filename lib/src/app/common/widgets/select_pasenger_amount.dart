import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:exxe/src/utils/export/ui_export.dart';

import '../../../data/data.dart';

class PassengerAmount extends StatefulWidget {
  const PassengerAmount({
    Key? key,
    this.compoundingCar,
    required this.numberSeat,
    required this.onSelected,
    this.numberAvailableSeat,
    required this.hintTextPassenger,
    required this.stylesHintText,
  }) : super(key: key);
  final String hintTextPassenger;
  final CompoundingCarModel? compoundingCar;
  final int numberSeat;
  final Function(int numberSeat) onSelected;
  final int? numberAvailableSeat;
  final TextStyle stylesHintText;

  @override
  State<PassengerAmount> createState() => _PassengerAmountState();
}

class _PassengerAmountState extends State<PassengerAmount> {
  int? selectedValue;

  int get numberAvailableSeat =>
      widget.numberAvailableSeat ?? widget.numberSeat;

  @override
  void didUpdateWidget(covariant PassengerAmount oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      selectedValue = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    int seat = 1;

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 48,
      decoration: BoxDecoration(
          color: AppColors.textLight, borderRadius: BorderRadius.circular(12)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          buttonPadding: const EdgeInsets.only(left: 6,right: 12),
          offset: const Offset(0, 0),
          dropdownDecoration: const BoxDecoration(
            color: AppColors.gray10,
          ),
          itemPadding: const EdgeInsets.only(left: 12),
          icon: SvgPicture.asset(AppIcons.directionDown),
          isExpanded: true,
          value: selectedValue,
          hint: Text(widget.hintTextPassenger,
              style: widget.stylesHintText),
          items: List<int>.generate(widget.numberSeat, (index) => ++index)
              .map((e) {
            if (seat <= numberAvailableSeat) {
              ++seat;
              return DropdownMenuItem<int>(
                value: e,
                child: Text(
                  "$e khách",
                  style: const TextStyle(fontSize: 14),
                ),
              );
            } else {
              ++seat;
              return DropdownMenuItem<int>(
                value: e,
                child: Text(
                  "$e khách",
                  style: AppStyles.s14w4.withColor(AppColors.gray40),
                ),
              );
            }
          }).toList(),
          onChanged: (int? value) {
            if (value! > numberAvailableSeat) {
              return;
            }
            widget.onSelected(value);
            setState(() {
              selectedValue = value;
            });
          },
        ),
      ),
    );
  }
}
