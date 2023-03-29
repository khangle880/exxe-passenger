import 'package:exxe/src/data/data.dart';

class RatingBoardModel {
  RatingBoardModel({
    CarDriverModel? carDriverId,
    List<RatingModel>? listRating,
  }) {
    _carDriverId = carDriverId;
    _listRating = listRating;
  }
  CarDriverModel? _carDriverId;
  List<RatingModel>? _listRating;

  RatingBoardModel.fromJson(dynamic json) {
    _carDriverId = json['car_driver'] != null
        ? CarDriverModel.fromJson(json['car_driver'])
        : null;
    if (json['list_rating'] != null) {
      _listRating = [];
      json['list_rating'].forEach((v) {
        _listRating?.add(RatingModel.fromJson(v));
      });
    } else {
      _listRating = null;
    }
  }
  CarDriverModel? get carDriverId => _carDriverId;
  List<RatingModel>? get listRating => _listRating;
}
