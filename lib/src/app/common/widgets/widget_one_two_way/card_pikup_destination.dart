import 'package:exxe/src/utils/export/ui_export.dart';

import '../../../../data/data.dart';

class CardPickupDestination extends StatefulWidget {
  const CardPickupDestination({
    Key? key,
    this.pickupPoint,
    this.destinationPoint,
    required this.onSelectDate,
    required this.handleSearchPickup,
    required this.handleSearchDestination,
    this.selectedDate,
  }) : super(key: key);
  final DateTime? selectedDate;
  final LocationModel? pickupPoint;
  final LocationModel? destinationPoint;
  final VoidCallback? onSelectDate;

  /// handle result of search pickup point
  final Function(LocationModel location) handleSearchPickup;

  /// handle result of search destination point
  final Function(LocationModel location) handleSearchDestination;

  @override
  State<CardPickupDestination> createState() => _CardPickupDestinationState();
}

class _CardPickupDestinationState extends State<CardPickupDestination> {
  Dialog showCalendar(void Function(DateTime value) onSelectedChanged) =>
      Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0)), //this right here
        child: CustomCalendar(
          onSelectedChanged: onSelectedChanged,
          initDate: widget.selectedDate ?? DateTime.now(),
          minDate: DateTime.now(),
        ),
      );

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: 200,
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: AppStyles.border15,
        border: Border.all(
          width: 0.5,
          color: AppColors.gray70x76.withAlpha(50),
        ),
      ),
      alignment: Alignment.topCenter,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                border: Border.all(
                    color: AppColors.gray70x76.withAlpha(50), width: 0.5),
                borderRadius: AppStyles.border15,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: FractionallySizedBox(
                      widthFactor: 1.0,
                      heightFactor: 0.9,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(AppIcons.circleBorder),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                for (int i = 1; i <= 5; i++)
                                  Container(
                                    width: 2.5,
                                    height: i == 1 || i == 5 ? 5 : 9,
                                    color:
                                        AppColors.primaryButton.withAlpha(50),
                                  )
                              ],
                            ),
                          ),
                          SvgPicture.asset(AppIcons.locationFillPurple),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: FractionallySizedBox(
                      heightFactor: 0.9,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLocation(
                            'Điểm đón',
                            widget.pickupPoint == null
                                ? 'Chọn điểm đón'
                                : widget.pickupPoint?.address ?? '',
                            widget.pickupPoint == null
                                ? AppStyles.s14w4.withColor(AppColors.gray70x76)
                                : AppStyles.s14w4.withColor(AppColors.gray95),
                            () {
                              Navigator.pushNamed(
                                context,
                                Routes.searchPlace,
                                arguments: {
                                  'searchType': SearchType.pickUpMap,
                                  'onSelect': widget.handleSearchPickup,
                                  'selectedProvince':
                                      widget.destinationPoint?.provinceId
                                },
                              );
                            },
                          ),
                          Expanded(
                            child: FractionallySizedBox(
                              widthFactor: 1.0,
                              heightFactor: 0.3,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  for (int i = 1;
                                      i <= (size.width - 80) * 0.8 / (7 * 2);
                                      i++)
                                    Container(
                                      width: 7,
                                      height: 2,
                                      color: AppColors.gray70x76.withAlpha(50),
                                    )
                                ],
                              ),
                            ),
                          ),
                          _buildLocation(
                            'Điểm đến',
                            widget.destinationPoint == null
                                ? 'Chọn điểm đến'
                                : widget.destinationPoint!.address ?? "",
                            widget.destinationPoint == null
                                ? AppStyles.s14w4.withColor(AppColors.gray70x76)
                                : AppStyles.s14w4.withColor(AppColors.gray95),
                            () {
                              Navigator.pushNamed(
                                context,
                                Routes.searchPlace,
                                arguments: {
                                  'searchType': SearchType.destinationMap,
                                  'onSelect': widget.handleSearchDestination,
                                  'selectedProvince':
                                      widget.pickupPoint?.provinceId
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          _buildOptionCalendar(),
        ],
      ),
    );
  }

  // Create week date picker with passed parameter
  Expanded _buildOptionCalendar() {
    return Expanded(
      child: InkWell(
        onTap: widget.onSelectDate,
        child: Container(
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                AppIcons.calendar,
                color: AppColors.textError,
              ),
              const SizedBox(width: 10.0),
              Text(
                widget.selectedDate != null
                    ? widget.selectedDate!.getDateTimeString
                    : 'Chọn thời gian',
                style: widget.selectedDate != null
                    ? AppStyles.s14w6.withColor(AppColors.gray95)
                    : AppStyles.s14w4.withColor(AppColors.gray70x76),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildLocation(
      String title, String subTitle, TextStyle styles, VoidCallback callback) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: InkWell(
            onTap: callback,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  text: title,
                  fontSize: 16.0,
                  weight: FontWeight.w700,
                ),
                const SizedBox(height: 5),
                Text(
                  subTitle,
                  style: styles,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ),
        // SvgPicture.asset(AppIcons.edit),
      ],
    );
  }
}
