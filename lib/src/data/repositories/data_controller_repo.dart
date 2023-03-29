import 'package:dartz/dartz.dart';
import 'package:exxe/src/utils/utils.dart';
import 'package:get_it/get_it.dart';

import '../../core/core.dart';
import '../../storage/models/user.dart';
import '../data.dart';

class DataControllerRepo extends IDataControllerRepo {
  late final INetworkUtility _networkUtility;

  DataControllerRepo() : _networkUtility = GetIt.I.get<INetworkUtility>();

  @override
  Future<Either<Failure, List<ProvinceModel>>> getAddress() async {
    final request =
        _networkUtility.request(Apis.getAddress, Method.POST, data: {});
    return ParserHelper.listParseDefault(request, ProvinceModel.fromJson);
  }

  @override
  Future<Either<Failure, List<DistrictModel>>> getListDistrict(
      List<num> provinceIds) async {
    final token = await BoxesUser.instance.getDataTokenUser();
    final request =
        _networkUtility.request(Apis.getListDistrict, Method.POST, data: {
      "params": {"token": token, "state_ids": provinceIds},
    });
    return ParserHelper.listParseDefault(request, DistrictModel.fromJson);
  }

  @override
  Future<Either<Failure, List<WardModel>>> getListWard(
      List<num> districtIds) async {
    final token = await BoxesUser.instance.getDataTokenUser();
    final request =
        _networkUtility.request(Apis.getListWard, Method.POST, data: {
      "params": {"token": token, "district_ids": districtIds},
    });
    return ParserHelper.listParseDefault(request, WardModel.fromJson);
  }

  @override
  Future<Either<Failure, List<CarBrandModel>>> getCarBrands() async {
    final request =
        _networkUtility.request(Apis.getCarBrands, Method.POST, data: {});

    return ParserHelper.listParseDefault(request, CarBrandModel.fromJson);
  }

  @override
  Future<Either<Failure, ComputePriceModel>> informationToComputePriceUnit() {
    final request = _networkUtility.request(
        Apis.informationToComputePriceUnit, Method.POST,
        data: {"params": {}});
    return ParserHelper.singleParseDefault(request, ComputePriceModel.fromJson);
  }

  @override
  Future<Either<Failure, List<CarModel>>> getCarTypes() async {
    final request =
        _networkUtility.request(Apis.getCarTypes, Method.POST, data: {});

    return ParserHelper.listParseDefault(request, CarModel.fromJson);
  }

  @override
  Future<Either<Failure, List<StationModel>>> getPickupStation(
    int provinceId, {
    int? districtId,
    int? wardId,
  }) async {
    final request = _networkUtility.request(
      Apis.getPickupStation,
      Method.POST,
      data: {
        "params": {
          "province_id": provinceId,
        }
      },
    );

    return ParserHelper.listParseDefault(request, StationModel.fromJson);
  }

  @override
  Future<Either<Failure, List<CarPriceModel>>> getCarFareTable({
    required double distance,
    required double duration,
    required CompoundingType type,
    required DateTime expectedGoingOnDate,
    DateTime? expectedPickingUpDate,
  }) async {
    final token = await BoxesUser.instance.getDataTokenUser();
    final request =
        _networkUtility.request(Apis.getCarFareTable, Method.POST, data: {
      "params": {
        "token": token,
        "distance": distance,
        "duration": duration,
        "expected_going_on_date": expectedGoingOnDate.serverFormat,
        "expected_picking_up_date": expectedPickingUpDate?.serverFormat,
        "compounding_type": type.serverString
      }.getCleanNull
    });

    return ParserHelper.listParseDefault(request, CarPriceModel.fromJson);
  }
}
