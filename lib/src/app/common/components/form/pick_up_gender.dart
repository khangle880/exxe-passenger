import '../../../../utils/export/ui_export.dart';

class PickUpGender extends StatelessWidget {
  const PickUpGender({
    super.key,
    required this.onClick,
    required this.currentGender,
    this.validator,
  });

  final Function(Gender) onClick;
  final Gender currentGender;
  final String? Function(Gender? value)? validator;

  @override
  Widget build(BuildContext context) {
    return FormField<Gender>(
      builder: (_) => SizedBox(
        height: 48,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: Gender.values.map(
            (e) {
              final isSelected = e == currentGender;
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color:
                          isSelected ? AppColors.primaryMain : AppColors.gray50,
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                blurRadius: 3,
                                spreadRadius: 1,
                                color: const Color(0xFF2B15B1).withOpacity(.1),
                              )
                            ]
                          : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    e.name,
                    style: AppStyles.s14w4.withColor(isSelected
                        ? AppColors.primaryMain
                        : AppColors.gray70x76),
                  ),
                ],
              ).inkWell(
                width: 108,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryMain +
                          AppColors.primaryLight.withOpacity(.95)
                      : AppColors.greyLight,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: isSelected
                          ? AppColors.primaryMain
                          : Colors.transparent),
                ),
                onTap: () {
                  onClick(e);
                },
              );
            },
          ).toList(),
        ),
      ),
      validator: validator,
    );
  }
}
