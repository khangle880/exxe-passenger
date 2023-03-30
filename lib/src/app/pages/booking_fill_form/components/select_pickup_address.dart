import '../../../../utils/export/ui_export.dart';
import '../controllers/booking_fill_form_cubit.dart';

class SelectPickupAddress extends StatelessWidget {
  const SelectPickupAddress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<BookingFillFormCubit>();
    return BlocBuilder<BookingFillFormCubit, BookingFillFormState>(
      builder: (context, state) {
        return Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(bottom: 20),
              height: 20,
              child: Row(
                children: [
                  Switch(
                    activeColor: AppColors.primaryLight,
                    activeTrackColor: AppColors.accBlueMain,
                    value: state.isPickingUpFromStart ?? false,
                    onChanged: (value) {
                      bloc.getIsPickUpFromStart(value);
                      if (!value) {
                        final currentLocation =
                            GetIt.I<AppState>().currentState.currentLocation;
                        bloc.getPickUpAddress(currentLocation?.address);
                      }
                    },
                  ),
                  Text(
                    'Đón tận nơi',
                    style: AppStyles.s16w7.withColor(AppColors.primaryDark),
                  ),
                ],
              ),
            ),
            state.isPickingUpFromStart ?? false
                ? Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            Routes.selectAddressConvenient,
                            arguments: {
                              'selectAddress': (address) {
                                bloc.getPickUpAddress(address);
                              },
                            },
                          );
                        },
                        child: CustomFormField(
                          validator: (value) {
                            if ((state.isPickingUpFromStart ?? false) &&
                                state.pickupPoint?.address == null) {
                              return 'Vui lòng chọn địa chỉ đón';
                            }
                            return null;
                          },
                          child: Container(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 16, top: 12, bottom: 12),
                              height: 48,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SvgPicture.asset(
                                    AppIcons.circleBorder,
                                    width: 26,
                                    height: 26,
                                  ),
                                  Expanded(
                                    child: TextWidget(
                                      text: state.pickupPoint?.address ??
                                          'Tìm điếm đón',
                                      fontSize: 14,
                                      weight: AppStyles.fontWeightW400,
                                      colorText: AppColors.gray70x3b,
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextWidget(
                        fontSize: 14,
                        weight: AppStyles.fontWeightW400,
                        colorText: AppColors.gray70x3b,
                        maxLine: 2,
                        text:
                            '(*) Chi phí phát sinh khách hàng vui lòng tự thanh toán với tài xế',
                      ),
                      const SizedBox(
                        height: 12,
                      )
                    ],
                  )
                : const SizedBox(),
          ],
        );
      },
    );
  }
}
