import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../core/core.dart';
import '../../utils/export/logic_export.dart';
import '../../utils/json_utils.dart';

class PlaceRepository extends IPlacesRepository {
  final String key = dotenv.maybeGet('GOONG_API_KEY', fallback: null) ?? "";
  late final INetworkUtility _networkUtility;

  PlaceRepository()
      : _networkUtility = GetIt.I
            .get<INetworkUtility>(instanceName: NetworkConstant.mapDomain);

  @override
  Future<Either<Failure, List<SuggestivePlaceModel>>> getAutocomplete(
      String searchInput) async {
    try {
      var response = await _networkUtility.request(
        "/Place/AutoComplete",
        Method.GET,
        queryParameters: {'input': searchInput, 'api_key': key},
      );
      final data = JsonUtils.getMap(response.data);

      if (response.statusCode == HttpStatus.ok) {
        final predictions = data['predictions'] ?? [];
        final items = List<SuggestivePlaceModel>.from(
            predictions.map((x) => SuggestivePlaceModel.fromJson(x)));

        return Right(items);
      } else {
        return Left(UnknownFailure(data['error'] ?? 'Goong API bi loi'));
      }
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, GoongPlaceModel>> getPlaceById(String placeId) async {
    try {
      var response = await _networkUtility.request(
        "/Place/Detail",
        Method.GET,
        queryParameters: {'place_id': placeId, 'api_key': key},
      );
      final data = JsonUtils.getMap(response.data);

      if (response.statusCode == HttpStatus.ok) {
        var predictionJson = data['result'];

        final result = GoongPlaceModel.fromJson(predictionJson);
        return Right(result);
      } else {
        return Left(UnknownFailure(data['error'] ?? 'Goong API bi loi'));
      }
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, DirectionModel>> getDirection({
    required num fromLat,
    required num fromLong,
    required num toLat,
    required num toLong,
  }) async {
    try {
      var response = await _networkUtility.request(
        "/Direction",
        Method.GET,
        queryParameters: {
          'origin': '$fromLat,$fromLong',
          'destination': '$toLat,$toLong',
          'api_key': key,
          'vehicle': 'car',
        },
      );

      final data = JsonUtils.getMap(response.data);
      DirectionModel? dataResult = DirectionModel.fromJson(data);
      if (dataResult.routes!.isEmpty) {
        return Left(WarningFailure(
            'Không thể tìm thấy tuyến đường phù hợp.\nVui lòng chọn lại địa điểm khác.'));
      } else {
        return Right(dataResult);
      }
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
