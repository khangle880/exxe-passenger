import 'package:exxe/src/utils/extensions/color_extension.dart';
import 'package:flutter/material.dart';

import '../../../config/colors.dart';

class CircleChecker extends StatelessWidget {
  const CircleChecker({
    Key? key,
    required this.isSelected,
    required this.onChange,
    this.margin = const EdgeInsets.all(4),
  }) : super(key: key);
  final bool isSelected;
  final Function(bool value) onChange;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          onChange(!isSelected);
        },
        child: AnimatedContainer(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected
                  ? AppColors.primaryMain
                  : AppColors.primaryMain +
                      AppColors.primaryLight.withOpacity(0.4),
            ),
            color: isSelected ? AppColors.primaryMain : null,
          ),
          margin: margin,
          duration: const Duration(milliseconds: 300),
        ),
      ),
    );
  }
}
