import '../../../data/models/models.dart';
import '../../../utils/export/ui_export.dart';
import '../trip_itinerary/components/driver_info.dart';

class DetailJoinConvenientTripPage extends StatelessWidget {
  const DetailJoinConvenientTripPage({
    Key? key,
    required this.compoundingCar,
  }) : super(key: key);
  final CompoundingCarModel compoundingCar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        backgroundColor: AppColors.greyLight,
        title: "Chi tiết chuyến đi",
        context: context,
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Giá tiền (1 khách)",
                  style: AppStyles.s16w6.withColor(AppColors.gray95),
                ),
                compoundingCar.priceUnit?.priceUnit != null
                    ? Text(
                        compoundingCar.priceUnit!.priceUnit!
                            .ceil()
                            .currencyFormat,
                        style: AppStyles.s21w6.withColor(AppColors.utilRed),
                      )
                    : const Text('0 đ'),
              ],
            ),
            const SizedBox(height: 12),
            ButtonWidgetOld(
              onClick: () {
                Navigator.pushNamed(
                  context,
                  Routes.bookingJoinFillForm,
                  arguments: {
                    'carCustomModel': CompoundingCarCustomerModel(
                      compoundingType: compoundingCar.compoundingType,
                      fromProvince: compoundingCar.fromProvince,
                      fromPickUpStation: compoundingCar.fromPickUpStation,
                      fromLongitude: compoundingCar.fromLongitude.toString(),
                      fromLatitude: compoundingCar.fromLatitude.toString(),
                      toProvince: compoundingCar.toProvince,
                      toPickUpStation: compoundingCar.toPickUpStation,
                      toLongitude: compoundingCar.toLongitude.toString(),
                      toLatitude: compoundingCar.toLatitude.toString(),
                      distance: compoundingCar.distance,
                      duration: compoundingCar.duration,
                      priceUnit: compoundingCar.priceUnit,
                      expectedGoingOnDate: compoundingCar.expectedGoingOnDate,
                      numberAvailableSeat: compoundingCar.numberAvailableSeat,
                      compoundingCarId: compoundingCar.compoundingCarId,
                    ),
                    'carModel': compoundingCar,
                  },
                );
              },
              radius: 12,
              child: Text(
                compoundingCar.compoundingType == CompoundingType.compounding
                    ? "Tiến hành đặt chuyến"
                    : "Chọn chuyến",
                style: AppStyles.s16w6.withColor(AppColors.primaryLight),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: AppColors.greyLight,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              if (compoundingCar.carDriverId != null &&
                  compoundingCar.carDriverId?.partnerId != null)
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
                  child: DriverInfo(
                    carDriver: compoundingCar.carDriverId,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child:
                    BookingInfoWidget.topCollapsed(CompoundingCarCustomerModel(
                  compoundingType: compoundingCar.compoundingType,
                  fromPickUpStation: compoundingCar.fromPickUpStation,
                  toPickUpStation: compoundingCar.toPickUpStation,
                  fromProvince: compoundingCar.fromProvince,
                  toProvince: compoundingCar.toProvince,
                  distance: compoundingCar.distance,
                  duration: compoundingCar.duration,
                )),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                color: AppColors.gray05,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.centerLeft,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Thông tin chuyến đi",
                        style: AppStyles.s18w7.withColor(AppColors.gray95),
                      ),
                    ),
                    const SizedBox(height: 8),
                    compoundingCar.compoundingType ==
                            CompoundingType.compounding
                        ? _buildTripInfoJoinTrip(compoundingCar)
                        : _buildTripInfoConvenientTrip(),
                    compoundingCar.compoundingType ==
                                CompoundingType.convenient &&
                            compoundingCar.note != null
                        ? _buildNote()
                        : const SizedBox(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTripInfoJoinTrip(CompoundingCarModel compoundingCarModel) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Ngày giờ xuất phát',
              style: AppStyles.s14w4.withColor(AppColors.gray70x76),
            ),
            Text(
              compoundingCarModel.expectedGoingOnDate!.getDateTimeString,
              style: AppStyles.s14w4.withColor(AppColors.gray95),
            )
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Khoảng cách",
              style: AppStyles.s14w4.withColor(AppColors.gray70x76),
            ),
            Text('${compoundingCarModel.distance!.toDouble().round()} km',
                style: AppStyles.s14w4.withColor(AppColors.gray95)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Thời gian dự kiến",
              style: AppStyles.s14w4.withColor(AppColors.gray70x76),
            ),
            Text(
              compoundingCarModel.duration!.toDouble().round().getTimeFromHours,
              style: AppStyles.s14w4.withColor(AppColors.gray95),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Loại xe",
              style: AppStyles.s14w4.withColor(AppColors.gray70x76),
            ),
            Text(
              compoundingCarModel.car?.name?.toLowerCase() ?? '',
              style: AppStyles.s14w4.withColor(AppColors.gray95),
            )
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Số chỗ còn trống",
              style: AppStyles.s14w4.withColor(AppColors.gray70x76),
            ),
            Text('${compoundingCarModel.numberAvailableSeat} chỗ',
                maxLines: 1, style: AppStyles.s14w4.withColor(AppColors.gray95))
          ],
        ),
      ],
    );
  }

  Widget _buildTripInfoConvenientTrip() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Ngày giờ xuất phát',
              style: AppStyles.s14w4.withColor(AppColors.gray70x76),
            ),
            Text(
              compoundingCar.expectedGoingOnDate!.getDateTimeString,
              style: AppStyles.s14w4.withColor(AppColors.gray95),
            )
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Loại xe",
              style: AppStyles.s14w4.withColor(AppColors.gray70x76),
            ),
            Text(
              compoundingCar.car?.name?.toLowerCase() ?? '',
              style: AppStyles.s14w4.withColor(AppColors.gray95),
            )
          ],
        ),
        compoundingCar.carDriverId?.carInformation?.firstOrNull?.carBrand
                    ?.brandName ==
                null
            ? const SizedBox()
            : Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Mẫu xe",
                      style: AppStyles.s14w4.withColor(AppColors.gray70x76),
                    ),
                    Text(
                        "${compoundingCar.carDriverId!.carInformation!.firstOrNull!.carBrand!.brandName}",
                        maxLines: 1,
                        style: AppStyles.s14w4.withColor(AppColors.gray95)),
                  ],
                ),
              ),
      ],
    );
  }

  Widget _buildNote() {
    return Column(
      children: [
        const SizedBox(height: 16),
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            "Lưu ý",
            style: AppStyles.s18w7.withColor(AppColors.gray95),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "${compoundingCar.note}",
          style: AppStyles.s14w4.withColor(AppColors.gray95),
        ),
      ],
    );
  }
}
