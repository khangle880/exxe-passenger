import '../../../../utils/export/ui_export.dart';
import '../controllers/booking_fill_form_cubit.dart';

class NumberPassenger extends StatelessWidget {
  const NumberPassenger({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<BookingFillFormCubit>();
    return BlocBuilder<BookingFillFormCubit, BookingFillFormState>(
      builder: (_, state) {
        if (state.selectedCarPriceModel != null) {
          return CustomFormField(
            validator: (value) {
              if (state.numberSeat == null) {
                return 'Vui lòng chọn số khách';
              }
              return null;
            },
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: const TextSpan(
                      text: "Số khách ",
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
                PassengerAmount(
                  stylesHintText: state.numberSeat == null
                      ? AppStyles.s14w4.withColor(AppColors.gray40)
                      : AppStyles.s14w4.withColor(AppColors.gray95),
                  hintTextPassenger: state.numberSeat == null
                      ? "Chọn số khách"
                      : "${state.numberSeat} khách ",
                  numberSeat:
                      state.selectedCarPriceModel!.carId!.numberSeat!.ceil(),
                  onSelected: (value) {
                    bloc.getNumberSeat(value);
                  },
                  numberAvailableSeat: state.numberAvailableSeat?.ceil(),
                ),
              ],
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
