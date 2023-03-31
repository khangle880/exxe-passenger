import 'dart:ui' as ui;

import 'package:app_settings/app_settings.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tiengviet/tiengviet.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/models/location/location_model.dart';
import '../export/repo_export.dart'
    show ProvinceModel, GetIt, IDataControllerRepo, CoordinateModel;
import '../export/ui_export.dart';

class LocationHelper {
  BehaviorSubject<List<ProvinceModel>> provinceStream =
      BehaviorSubject.seeded([]);

  List<ProvinceModel> get provinces => provinceStream.value;

  getListProvince() async {
    var result = await GetIt.I<IDataControllerRepo>().getAddress();
    return result.fold(
      (failure) => log('ko the lấy tỉnh thành $failure'),
      (data) {
        provinceStream.add(data);
      },
    );
  }

  List<ProvinceModel> sortWithHcmHnInFirst(List<ProvinceModel> provinces) {
    ProvinceModel hcm = ProvinceModel();
    ProvinceModel haNoi = ProvinceModel();
    for (int i = 0; i < provinces.length; i++) {
      if (provinces[i].provinceName == 'TP Hồ Chí Minh') {
        hcm = provinces[i];
      }
      if (provinces[i].provinceName == 'Hà Nội') {
        haNoi = provinces[i];
      }
    }

    List<ProvinceModel> list = provinces;
    list.removeWhere((element) =>
        element.provinceName == 'TP Hồ Chí Minh' ||
        element.provinceName == 'Hà Nội');
    list.insert(0, haNoi);
    list.insert(0, hcm);
    return list;
  }

  fromGoogleAddressToProvinceModel(String address) async {
    if (provinces.isEmpty) {
      await getListProvince();
    }
    log('provinces: ${provinces.length}');
    var addressVi = TiengViet.parse(address);
    var arr = addressVi.toLowerCase().split(',');
    List<String> listAddress = arr.reversed
        .map((item) => item
            .replaceAll(' ', '')
            .replaceAll('city', '')
            .replaceAll(RegExp(r'[0-9]'), '')
            .replaceAll('thanhpho', '')
            .replaceAll('tp', '')
            .replaceAll(RegExp('[^A-Za-z]'), '')
            .replaceAll('province', ''))
        .toList();

    for (var address in listAddress) {
      log('provincevnname $address');
      for (var province in provinces) {
        if (address == province.provinceVietnameseName) {
          return province;
        }
      }
    }
    return null;
  }

  Future<CoordinateModel> getCoordinateFromAddress(String address) async {
    List<geocoding.Location> locations =
        await geocoding.locationFromAddress(address);
    log('Home lat ${locations.first.latitude} - lng ${locations.first.longitude}');
    return CoordinateModel(
        longitude: locations.first.longitude,
        latitude: locations.first.latitude);
  }

  Future<Uint8List> _getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<BitmapDescriptor> getMarker(String path, int width) async {
    final Uint8List imageData = await _getBytesFromAsset(path, width);
    return BitmapDescriptor.fromBytes(imageData);
  }

  handleLocation(
    BuildContext context, {
    String? routeName,
    Function()? callBack,
    bool isShowLoading = true,
    Object? args,
  }) async {
    await loadLocation(context).then((value) {
      final permission = value;
      if (permission == LocationPermissionEnum.permissionDeniedForever) {
        AppDialog.I.showWarning(
          confirmTitle: "Cài đặt",
          message: 'Bạn phải vào cài đặt cấp quyền vị trí cho app',
          onConfirm: () {
            AppSettings.openLocationSettings();
            AppDialog.I.closeDialog();
          },
        );
      }
      if (permission == LocationPermissionEnum.locationValid) {
        if (routeName != null) {
          Navigator.pushNamed(context, routeName, arguments: args);
        } else {
          callBack?.call();
        }
      }
      if (permission == LocationPermissionEnum.locationInvalid) {
        AppDialog.I.showWarning(
          message: 'Hiện tại không thể tải dữ liệu cho vị trí này',
        );
      }

      if (permission == LocationPermissionEnum.couldNotGetLocation) {
        AppDialog.I.showWarning(
          message: 'Không lấy được Vị trí hiện tại. Vui lòng thử lại',
        );
      }
    });
  }

  Future<LocationPermissionEnum> loadLocation(BuildContext context,
      {isShowLoading = true}) async {
    if (isShowLoading) {
      AppDialog.I.showLoadingLocation(msg: 'Đang lấy vị trí...');
    }
    return await GoogleMapService.instance.enableLocation().then((value) async {
      log('Position: $value');
      LocationModel? locationModel = await _createLocationModel(value);
      SmartDialog.dismiss();

      if (locationModel == null) {
        return LocationPermissionEnum.locationInvalid;
      } else {
        GetIt.I.get<AppState>().updateCurrentLocation(locationModel);
        return LocationPermissionEnum.locationValid;
      }
    }).catchError((e) {
      log(e.toString());
      SmartDialog.dismiss();
      return LocationPermissionEnum.couldNotGetLocation;
    });
  }

  Future<LocationModel?> _createLocationModel(Position position) async {
    var addresses = await geocoding.placemarkFromCoordinates(
      position.latitude,
      position.longitude,
      localeIdentifier: 'vi_VN',
    );
    var first = addresses.first;
    String currentAddress =
        '${first.subThoroughfare}, ${first.thoroughfare}, ${first.subAdministrativeArea}, ${first.administrativeArea}, ${first.country}';
    log('currentAddress $currentAddress');

    ProvinceModel? provinceModel = await GetIt.I<LocationHelper>()
        .fromGoogleAddressToProvinceModel(currentAddress);

    if (provinceModel == null) {
      return null;
    } else {
      return LocationModel(
        coordinate: CoordinateModel(
          latitude: position.latitude,
          longitude: position.longitude,
        ),
        address: currentAddress,
        province: provinceModel,
        provinceId: provinceModel.provinceId!.ceil(),
      );
    }
  }

  Future<void> openMapNavigation(String lat, String long) async {
    var uri = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=$lat,$long&travelmode=driving&dir_action=navigate');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Future.error('Không thể mở Google Map');
    }
  }
}
