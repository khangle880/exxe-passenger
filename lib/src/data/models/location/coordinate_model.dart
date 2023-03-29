// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class CoordinateModel extends Equatable {
  final double? latitude;
  final double? longitude;

  const CoordinateModel({
    this.latitude,
    this.longitude,
  });

  @override
  List<Object?> get props => [latitude, longitude];

  factory CoordinateModel.fromJson(Map<String, dynamic> json) {
    return CoordinateModel(
      latitude: json['lat'],
      longitude: json['lng'],
    );
  }
}
