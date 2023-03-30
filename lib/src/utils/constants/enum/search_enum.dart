import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../config/config.dart';

enum SearchType {
  pickUpMap,
  destinationMap,
  pickUpProvince,
  destinationProvince,
  pickUpStation,
  destinationStation,
}

extension SearchTypeExt on SearchType {
  String get name {
    switch (this) {
      case SearchType.pickUpMap:
        return 'Điểm bạn muốn đón ?';
      case SearchType.destinationMap:
        return 'Điểm bạn muốn đến ?';
      case SearchType.pickUpProvince:
        return 'Chọn điểm đón';
      case SearchType.destinationProvince:
        return 'Chọn điểm đến';
      case SearchType.pickUpStation:
        return 'Chọn trạm đón';
      case SearchType.destinationStation:
        return 'Chọn trạm đến';
    }
  }

  Widget get icon {
    switch (this) {
      case SearchType.pickUpMap:
        return SvgPicture.asset(
          AppIcons.circleBorder,
          width: 20.0,
          height: 20,
          fit: BoxFit.fill,
        );
      case SearchType.destinationMap:
        return SvgPicture.asset(
          AppIcons.locationFillPurple,
          width: 20.0,
          height: 20,
          fit: BoxFit.fill,
        );
      case SearchType.pickUpProvince:
        return SvgPicture.asset(
          AppIcons.circleBorder,
          width: 32.0,
          height: 32,
          fit: BoxFit.fill,
        );
      case SearchType.destinationProvince:
        return SvgPicture.asset(
          AppIcons.locationFillPurple,
          width: 32.0,
          height: 32,
          fit: BoxFit.fill,
        );
      case SearchType.pickUpStation:
        return SvgPicture.asset(
          AppIcons.circleBorder,
          width: 20.0,
          height: 20,
          fit: BoxFit.fill,
        );
      case SearchType.destinationStation:
        return SvgPicture.asset(
          AppIcons.locationFillPurple,
          width: 20.0,
          height: 20,
          fit: BoxFit.fill,
        );
    }
  }
}


enum TypePage { convenient, joinTrip }
