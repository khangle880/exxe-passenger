import 'package:dartz/dartz.dart';

import '../../../core/core.dart';
import '../../data.dart';

abstract class IRatingRepo {
  Future<Either<Failure, List<RatingHashtagModel>>> getQuickRatingTag(
      int start);

  Future<Either<Failure, RatingBoardModel>> getRatingDriver(
      {required num carDriverId, String? ratingStar, num? limit, num? offset});

  Future<Either<Failure, RatingResModel>> createRatingRequest(
      int compoundingCarCustomerId, int rating, List<int> ratingTagIds,
      {String ratingContent = ''});
}
