import '../../../../data/models/models.dart';
import '../../../../utils/export/ui_export.dart';
import '../controllers/booking_fill_form_cubit.dart';

class CarFareTable extends StatelessWidget {
  const CarFareTable(this.carModel, {Key? key}) : super(key: key);
  final CompoundingCarModel? carModel;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<BookingFillFormCubit>();
    return BlocBuilder<BookingFillFormCubit, BookingFillFormState>(
      builder: (_, state) {
        if (carModel != null) {
          return Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: const TextSpan(
                    text: "Chọn loại xe ",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: AppDimens.text14),
                    children: [
                      TextSpan(
                        text: "*",
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TypeCarTrip(
                onTapTypeCar: () {},
                carType: state.selectedCarPriceModel!.carId!.name,
                price: state.selectedCarPriceModel!.priceUnit!
                    .ceil()
                    .currencyFormat,
                isDisable: true,
              ),
            ],
          );
        }
        if (state.carPriceModels != null) {
          return Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: const TextSpan(
                    text: "Chọn loại xe ",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: AppDimens.text14),
                    children: [
                      TextSpan(
                        text: "*",
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TypeCarTrip(
                isDisable: false,
                onTapTypeCar: () {
                  ModalBottomSheet.instance.show(
                    context,
                    PickupCarType(
                      currentSelect: state.selectedCarPriceModel,
                      carTypes: state.carPriceModels,
                      onSelected: (carType) {
                        bloc.getSelectedCarPrice(carType);
                      },
                    ),
                    backgroundColor: AppColors.greyLight,
                  );
                },
                carType: state.selectedCarPriceModel!.carId!.name!,
                price: state.selectedCarPriceModel!.priceUnit!
                    .ceil()
                    .currencyFormat,
              ),
            ],
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
