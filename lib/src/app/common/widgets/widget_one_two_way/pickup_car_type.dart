import '../../../../data/data.dart';
import '../../../../utils/export/ui_export.dart';

class PickupCarType extends StatelessWidget {
  const PickupCarType({
    Key? key,
    this.carTypes,
    this.currentSelect,
    required this.onSelected,
  }) : super(key: key);
  final List<CarPriceModel>? carTypes;
  final CarPriceModel? currentSelect;
  final Function(CarPriceModel) onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .4,
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            text: 'Chọn loại xe',
            fontSize: 20.0,
            weight: FontWeight.w700,
          ),
          const SizedBox(height: 20),
          (carTypes ?? []).isEmpty
              ? TextWidget(
                  text: 'Dữ liệu rỗng',
                  fontSize: AppDimens.text14,
                  colorText: AppColors.textError,
                )
              : ListOptionCar(
                  carTypes: carTypes,
                  currentSelect: currentSelect,
                  onSelected: (carType) {
                    Navigator.pop(context);
                    onSelected(carType);
                  },
                )
        ],
      ),
    );
  }
}
