import 'package:flutter/material.dart';

import '../../../config/colors.dart';

class DashedLineVertical extends StatelessWidget {
  const DashedLineVertical({
    super.key,
    this.width = 1,
    this.color,
  });

  final double width;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxHeight = constraints.constrainHeight();
        final dashWidth = width;
        final dashCount = ((boxHeight - 16) / (1.2 * 9)).floor() + 2;
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.vertical,
          children: List.generate(dashCount, (index) {
            return SizedBox(
              width: dashWidth,
              height: index == 0 || index == dashCount - 1 ? 5 : 9,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color ?? AppColors.gray10),
              ),
            );
          }),
        );
      },
    );
  }
}
