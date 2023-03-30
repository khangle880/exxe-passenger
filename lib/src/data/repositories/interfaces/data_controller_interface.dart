import 'package:dartz/dartz.dart';

import '../../../core/core.dart';
import '../../../utils/constants/enum/enum.dart';
import '../../models/models.dart';

abstract class IDataControllerRepo {
  Future<Either<Failure, List<ProvinceModel>>> getAddress();

  Future<Either<Failure, List<DistrictModel>>> getListDistrict(
      List<num> provinceIds);

  Future<Either<Failure, List<WardModel>>> getListWard(List<num> districtIds);

  Future<Either<Failure, List<CarBrandModel>>> getCarBrands();

  Future<Either<Failure, List<CarModel>>> getCarTypes();

  Future<Either<Failure, ComputePriceModel>> informationToComputePriceUnit();

  Future<Either<Failure, List<StationModel>>> getPickupStation(
    int provinceId, {
    int? districtId,
    int? wardId,
  });

  Future<Either<Failure, List<CarPriceModel>>> getCarFareTable({
    required double distance,
    required double duration,
    required CompoundingType type,
    required DateTime expectedGoingOnDate,
    DateTime? expectedPickingUpDate,
  });
}
