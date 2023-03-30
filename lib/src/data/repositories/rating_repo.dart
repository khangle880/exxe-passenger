import 'package:dartz/dartz.dart';
import 'package:exxe/src/utils/export/ui_export.dart';

import '../../core/core.dart';
import '../../storage/models/user.dart';
import '../data.dart';

class RatingRepo extends IRatingRepo {
  late final INetworkUtility _networkUtility;

  RatingRepo() : _networkUtility = GetIt.I.get<INetworkUtility>();

  @override
  Future<Either<Failure, List<RatingHashtagModel>>> getQuickRatingTag(
      int start) async {
    final token = await BoxesUser.instance.getDataTokenUser();
    final request = _networkUtility.request(
      Apis.getQuickRatingTagRequest,
      Method.POST,
      data: {
        "params": {"token": token, "rating_number": start}
      },
    );
    return ParserHelper.listParseDefault(request, RatingHashtagModel.fromJson);
  }

  @override
  Future<Either<Failure, RatingResModel>> createRatingRequest(
    int compoundingCarCustomerId,
    int rating,
    List<int> ratingTagIds, {
    String ratingContent = '',
  }) async {
    final token = await BoxesUser.instance.getDataTokenUser();
    final params = {
      "token": token,
      "compounding_car_customer_id": compoundingCarCustomerId,
      "rating_number": rating,
      "rating_tag_ids": ratingTagIds,
      "rating_content": ratingContent
    };
    log(params.toString());
    final request = _networkUtility.request(
        Apis.createRatingRequest, Method.POST,
        data: {"params": params});

    return ParserHelper.singleParseDefault(
        request, (data) => RatingResModel.fromJson(data));
  }

  @override
  Future<Either<Failure, RatingBoardModel>> getRatingDriver(
      {required num carDriverId, String? ratingStar, num? limit, num? offset}) async {
    List<String>? listRatingStar;
    if (ratingStar != null) {
      listRatingStar = [ratingStar];
    }
    final token = await BoxesUser.instance.getDataTokenUser();
    final params = {
      "token": token,
      "car_driver_id": carDriverId,
      "rating_star": listRatingStar,
      "limit": limit,
      "offset": offset,
    }.getCleanNull;
    log(params.toString());
    final request = _networkUtility.request(
        Apis.getListRatedCarDriver, Method.POST,
        data: {"params": params});
    return ParserHelper.singleParseDefault(request, RatingBoardModel.fromJson);
  }
}
