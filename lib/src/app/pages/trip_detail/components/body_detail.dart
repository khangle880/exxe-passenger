import 'package:exxe/src/app/common/widgets/booking/ride_payment_info.dart';
import 'package:exxe/src/data/models/car/compounding_car_customer_model.dart';
import 'package:exxe/src/utils/export/ui_export.dart';

class BodyTripDetail extends StatelessWidget {
  const BodyTripDetail({
    super.key,
    required this.customer,
  });

  final CompoundingCarCustomerModel customer;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Thông tin chuyến đi',
            style: AppStyles.s18w7.withColor(AppColors.primaryDark),
          ),
          const SizedBox(
            height: 8,
          ),
          RideInfoRow(
            "Mã chuyến đi",
            value: customer.compoundingCarCustomerCode,
          ),
          RideInfoRow('Ngày giờ xuất phát',
              value: customer.expectedGoingOnDate!.getDateTimeString),
          customer.expectedPickingUpDate != null
              ? RideInfoRow('Ngày giờ về',
                  value: customer.expectedPickingUpDate!.getDateTimeString)
              : const SizedBox(),
          RideInfoRow('Số khách',
              value: ("${customer.numberSeat ?? 0} khách").toString()),
          RideInfoRow('Loại xe', value: customer.car!.name),
          Text(
            'Chi phí',
            style: AppStyles.s18w7.withColor(AppColors.primaryDark),
          ),
          const SizedBox(
            height: 8,
          ),
          RidePaymentInfo(customer),
        ],
      ),
    );
  }
}
