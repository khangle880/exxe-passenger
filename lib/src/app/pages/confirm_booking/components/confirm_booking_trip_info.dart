import '../../../../data/data.dart';
import '../../../../utils/export/ui_export.dart';

class ConfirmBookingTripInfo extends StatelessWidget {
  const ConfirmBookingTripInfo(this.data, {Key? key}) : super(key: key);
  final CompoundingCarCustomerModel data;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Ngày giờ xuất phát',
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: AppDimens.text14,
                  color: AppColors.gray70x76),
            ),
            Text(
              (data.expectedGoingOnDate!).toFormat('HH:mm - dd.MM.yyyy'),
              maxLines: 1,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: AppDimens.text14,
              ),
            ),
          ],
        ),
        if (data.compoundingType == CompoundingType.twoWay) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Ngày giờ về",
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: AppDimens.text14,
                    color: AppColors.gray70x76),
              ),
              Text(
                data.expectedPickingUpDate?.toFormat('HH:mm - dd.MM.yyyy') ??
                    'unknown',
                maxLines: 1,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: AppDimens.text14,
                ),
              ),
            ],
          )
        ],
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Số khách ",
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: AppDimens.text14,
                  color: AppColors.gray70x76),
            ),
            Text(
              data.numberSeat != null ? '${data.numberSeat} Khách' : '',
              maxLines: 1,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: AppDimens.text14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Loại xe",
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: AppDimens.text14,
                  color: AppColors.gray70x76),
            ),
            Text(
              data.car!.name!,
              maxLines: 1,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: AppDimens.text14,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
