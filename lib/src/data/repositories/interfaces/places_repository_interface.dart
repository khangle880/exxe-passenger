import 'package:dartz/dartz.dart';

import '../../../core/core.dart';
import '../../data.dart';

abstract class IPlacesRepository {
  Future<Either<Failure, List<SuggestivePlaceModel>>> getAutocomplete(
      String searchInput);

  Future<Either<Failure, GooglePlaceModel>> getPlaceById(String placeId);

  Future<Either<Failure, DirectionsModel>> getDirection({
    required num fromLat,
    required num fromLong,
    required num toLat,
    required num toLong,
  });
}
