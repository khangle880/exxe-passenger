import '../../../../data/models/models.dart';
import '../../../../utils/export/ui_export.dart';

class CarDetail extends StatelessWidget {
  const CarDetail(this.customer, {Key? key}) : super(key: key);
  final CompoundingCarCustomerModel customer;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            alignment: Alignment.centerLeft,
            child: Text("Thông tin chuyến đi", style: AppStyles.s18w7)),
        const SizedBox(height: 8),
        RideInfoRow('Mã chuyến đi', value: customer.compoundingCarCustomerCode),
        RideInfoRow('Ngày giờ xuất phát',
            value: customer.expectedGoingOnDate!.getDateTimeString),
        customer.expectedPickingUpDate != null
            ? RideInfoRow('Ngày giờ về',
                value: customer.expectedPickingUpDate!.getDateTimeString)
            : const SizedBox(),
        RideInfoRow(
          "Số khách",
          value: "${customer.numberSeat!.ceil()} khách",
        ),
        RideInfoRow('Loại xe', value: customer.car!.name),
        RideInfoRow("Mẫu xe",
            value: customer
                .carDriverId?.carInformation?.firstOrNull?.carBrand?.brandName),
      ],
    );
  }
}
