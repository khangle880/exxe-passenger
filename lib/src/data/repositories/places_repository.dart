import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:exxe/src/utils/export/ui_export.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../core/core.dart';
import '../data.dart';

class PlaceRepository extends IPlacesRepository {
  final String key = dotenv.maybeGet('GOOGLE_API_KEY', fallback: null) ?? "";
  final String types = 'geocode';

  @override
  Future<Either<Failure, List<SuggestivePlaceModel>>> getAutocomplete(
      String searchInput) async {
    try {
      const String url =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json';
      var response = await Dio().get(url, queryParameters: <String, String>{
        'input': searchInput,
        'types': 'establishment|geocode',
        'components': 'country:vn',
        'language': 'vi',
        'locationrestriction': 'rectangle:south,west|north,east',
        'key': key,
      });
      if (response.statusCode == HttpStatus.ok) {
        var predictionJson = response.data['predictions'] as List;

        List<SuggestivePlaceModel> result = predictionJson
            .map((place) => SuggestivePlaceModel.fromJson(place))
            .toList();
        log('suggestion places ${result.length}');
        return Right(result);
      } else {
        return Left(UnknownFailure('Google khong tim dc vi dia điểm'));
      }
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, GooglePlaceModel>> getPlaceById(String placeId) async {
    try {
      const String url =
          'https://maps.googleapis.com/maps/api/place/details/json';
      var response = await Dio().get(url, queryParameters: <String, String>{
        'place_id': placeId,
        'types': 'geocode',
        'language': 'vi',
        'fields': 'formatted_address,name,geometry',
        'key': key
      });
      if (response.statusCode == HttpStatus.ok) {
        var predictionJson = response.data['result'];

        GooglePlaceModel result = GooglePlaceModel.fromJson(predictionJson);
        log('google place detail $result');
        return Right(result);
      } else {
        return Left(UnknownFailure('Google API bi loi'));
      }
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, DirectionsModel>> getDirection({
    required num fromLat,
    required num fromLong,
    required num toLat,
    required num toLong,
  }) async {
    try {
      const String baseUrl =
          'https://maps.googleapis.com/maps/api/directions/json?';
      final response = await Dio().get(
        baseUrl,
        queryParameters: {
          'origin': '$fromLat,$fromLong',
          'destination': '$toLat,$toLong',
          'mode': 'driving',
          'language': 'vi',
          'region': 'vi',
          'key': key,
        },
      );
      DirectionsModel? dataResult = DirectionsModel.fromJson(response.data);
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
