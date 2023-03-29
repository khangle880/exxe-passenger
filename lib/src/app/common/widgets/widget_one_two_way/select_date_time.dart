import 'package:exxe/src/utils/export/ui_export.dart';

class InfoTimeTripDetail extends StatelessWidget {
  final void Function()? onTapCalendar;
  final void Function()? onTapTime;
  final String? selectedDate;
  final String? selectedTime;
  final String textDate;
  final int flex;
  final bool isDisableDate;
  final bool isDisableTime;
  final TextStyle? style;
  final String? Function()? validator;

  const InfoTimeTripDetail({
    Key? key,
    required this.onTapTime,
    required this.flex,
    required this.onTapCalendar,
    this.selectedDate,
    this.selectedTime,
    required this.textDate,
    this.isDisableDate = false,
    this.isDisableTime = false,
    this.style,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomFormField(
      validator: (value) {
        return validator?.call();
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: flex,
            child: GestureDetector(
              onTap: isDisableDate ? null : onTapCalendar,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  RichText(
                    text: TextSpan(
                      text: textDate,
                      style: AppStyles.s14w7.withColor(AppColors.gray95),
                      children: const [
                        TextSpan(
                          text: " *",
                          style: TextStyle(color: AppColors.textError),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.only(left: 12),
                    alignment: Alignment.centerLeft,
                    height: 48,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: isDisableDate
                            ? AppColors.gray10
                            : AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        SvgPicture.asset(AppIcons.calendar,
                            width: 16, height: 16),
                        const SizedBox(width: 10),
                        Text(
                          "$selectedDate",
                          style: style,
                        )
                      ],
                    ),
                  ),
                  //
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                RichText(
                  text: TextSpan(
                    text: "Thời gian",
                    style: AppStyles.s14w7.withColor(AppColors.gray95),
                    children: const [
                      TextSpan(
                        text: " *",
                        style: TextStyle(color: AppColors.textError),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      AppIcons.clockCircle,
                      width: 16,
                      height: 16,
                      color: AppColors.black,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "$selectedTime",
                        style: style,
                      ),
                    )
                  ],
                ).inkWell(
                  padding: const EdgeInsets.only(left: 12),
                  height: 48,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: isDisableTime
                          ? AppColors.gray10
                          : AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(12)),
                  onTap: isDisableTime ? null : onTapTime,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
