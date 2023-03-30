import 'package:exxe/src/utils/export/ui_export.dart';

class ItemPickUpDestinationPointTripWidget extends StatelessWidget {
  const ItemPickUpDestinationPointTripWidget({
    Key? key,
    required this.dateTime,
    required this.type,
    required this.locationStartName,
    required this.locationStartStation,
    required this.locationEndName,
    required this.locationEndStation,
    required this.distance,
    this.isReverse = false,
  }) : super(key: key);
  final DateTime dateTime;
  final CompoundingType type;
  final String locationStartName;
  final String locationStartStation;
  final String locationEndName;
  final String locationEndStation;
  final int distance;
  final bool isReverse;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: isReverse
              ? [
                  Expanded(
                    child: _buildInfoTrip(
                      locationEndName,
                      locationEndStation,
                      'Điểm trả',
                      CrossAxisAlignment.start,
                      TextDirection.ltr,
                    ),
                  ),
                  _buildDistance(),
                  Expanded(
                    child: _buildInfoTrip(
                      locationStartName,
                      locationStartStation,
                      'Điểm đón',
                      CrossAxisAlignment.end,
                      TextDirection.rtl,
                    ),
                  ),
                ]
              : [
                  Expanded(
                    child: _buildInfoTrip(
                        locationStartName,
                        locationStartStation,
                        'Điểm đón',
                        CrossAxisAlignment.start,
                        TextDirection.ltr),
                  ),
                  _buildDistance(),
                  Expanded(
                    child: _buildInfoTrip(
                      locationEndName,
                      locationEndStation,
                      'Điểm trả',
                      CrossAxisAlignment.end,
                      TextDirection.rtl,
                    ),
                  ),
                ],
        ),
      ],
    );
  }

  Column _buildInfoTrip(
    String province,
    String nameBusStation,
    String point,
    CrossAxisAlignment crossAxisAlignment,
    TextDirection textDirection,
  ) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            province,
            style: AppStyles.s20w6,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(point, style: AppStyles.s12w4.withColor(AppColors.gray70x3b)),
        Text(
          nameBusStation,
          style: AppStyles.s14w6.withColor(AppColors.gray80),
          overflow: TextOverflow.ellipsis,
          textDirection: textDirection,
          maxLines: 2,
        ).gestureDetector(
          onLongPress: () {
            Clipboard.setData(ClipboardData(text: nameBusStation)).then(
              (value) {
                AppDialog.I.showToast('Đã sao chép vào bộ nhớ');
              },
            );
          },
        ),
      ],
    );
  }

  Row _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppIcons.calendar,
              color: AppColors.primaryButton,
              width: 15.0,
              height: 15.0,
            ),
            const SizedBox(
              width: 11,
            ),
            FittedBox(
              child: Text(
                dateTime.toFormat('HH:mm - dd.MM.yyyy'),
                style: AppStyles.s14w4.withColor(AppColors.primaryButton),
              ),
            ),
          ],
        ),
        TypeStatusWidget.compoundingType(type),
      ],
    );
  }

  _buildDistance() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '$distance km',
          style: AppStyles.s12w4,
        ),
        SvgPicture.asset(
          AppIcons.arrowTrip,
          color: AppColors.gray70x76.withAlpha(90),
        )
      ],
    );
  }
}
