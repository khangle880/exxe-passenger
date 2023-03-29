import 'package:dartz/dartz.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/core.dart';
import '../../data.dart';

abstract class IPlacesRepository {
  Future<Either<Failure, List<SuggestivePlaceModel>>> getAutocomplete(
      String searchInput);

  Future<Either<Failure, GooglePlaceModel>> getPlaceById(String placeId);

  Future<Either<Failure, DirectionsModel>> getDirection(
      LatLng origin, LatLng destination);
}
