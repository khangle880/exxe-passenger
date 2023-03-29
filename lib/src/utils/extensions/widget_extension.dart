import 'package:flutter/material.dart';

import '../../config/colors.dart';

extension WidgetExt on Widget {
  Widget get appCenterProgressLoading {
    return const Center(
      child: SizedBox(
        width: 32,
        height: 32,
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryMain)),
      ),
    );
  }

  Widget inkWell({
    Function()? onTap,
    EdgeInsets? padding,
    Color? color,
    Decoration? decoration,
    double? width,
    double? height,
    double? radius,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius ?? 16),
        ),
        splashColor: AppColors.gray50.withOpacity(0.5),
        highlightColor: AppColors.gray50.withOpacity(0.3),
        child: Ink(
          height: height,
          width: width,
          decoration: decoration,
          color: color,
          padding: padding,
          child: this,
        ),
      ),
    );
  }

  Widget gestureDetector({
    dynamic Function()? onTap,
    dynamic Function()? onLongPress,
  }) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: this,
    );
  }

  Widget padding({
    required EdgeInsetsGeometry padding,
  }) {
    return Padding(
      padding: padding,
      child: this,
    );
  }

  Widget margin({
    required EdgeInsetsGeometry margin,
  }) {
    return Container(
      margin: margin,
      child: this,
    );
  }
}
