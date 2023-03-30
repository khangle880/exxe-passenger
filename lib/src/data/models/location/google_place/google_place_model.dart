import '../../../../utils/export/logic_export.dart';

class GooglePlaceModel {
  GooglePlaceModel({
    this.formattedAddress,
    this.coordinate,
    this.name,
  });

  GooglePlaceModel.fromJson(dynamic json) {
    formattedAddress = json['formatted_address'];
    coordinate = json['geometry']['location'] != null
        ? CoordinateModel.fromJson(json['geometry']['location'])
        : null;
    name = json['name'];
  }

  String? formattedAddress;
  CoordinateModel? coordinate;
  String? name;

  GooglePlaceModel copyWith({
    String? formattedAddress,
    CoordinateModel? coordinate,
    String? name,
  }) {
    return GooglePlaceModel(
      formattedAddress: formattedAddress ?? this.formattedAddress,
      coordinate: coordinate ?? this.coordinate,
      name: name ?? this.name,
    );
  }

  @override
  String toString() {
    return 'GooglePlaceModel{formattedAddress: $formattedAddress, coordinate: $coordinate, name: $name}';
  }
}
