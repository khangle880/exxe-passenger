// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
//
// class DirectionsModel {
//   DirectionsModel({
//     this.geocodedWaypoints,
//     this.routes,
//     this.status,
//   });
//
//   DirectionsModel.fromJson(dynamic json) {
//     if (json['geocoded_waypoints'] != null) {
//       geocodedWaypoints = [];
//       json['geocoded_waypoints'].forEach((v) {
//         geocodedWaypoints?.add(GeocodedWaypoints.fromJson(v));
//       });
//     }
//     if (json['routes'] != null) {
//       routes = [];
//       json['routes'].forEach((v) {
//         routes?.add(RouteModel.fromJson(v));
//       });
//     }
//     status = json['status'];
//   }
//
//   List<GeocodedWaypoints>? geocodedWaypoints;
//   List<RouteModel>? routes;
//   String? status;
//
//   double get getDistanceKm {
//     final distance = routes?.first.legs?.first.distance?.value;
//     return distance == null
//         ? 0
//         : double.parse((distance / 1000).toStringAsFixed(2));
//   }
//
//   double get getDuration {
//     final duration = routes?.first.legs?.first.duration?.value;
//     return duration == null ? 0 : (duration / (60 * 60));
//   }
//
//   BoundModel? get bound => routes!.first.bounds;
//
//   List<LatLng> get polylinePoints {
//     List<LatLng> coordinates = [];
//     for (final leg in (routes?.first.legs ?? [])) {
//       for (final step in (leg.steps ?? [])) {
//         List<PointLatLng> result =
//             PolylinePoints().decodePolyline(step.polyline.points);
//
//         List<LatLng> stepCoordinates = result
//             .map((PointLatLng point) => LatLng(point.latitude, point.longitude))
//             .toList();
//
//         if (coordinates.length > 1) {
//           if (coordinates.last == stepCoordinates.first) {
//             coordinates.removeLast();
//           }
//         }
//
//         coordinates.addAll(stepCoordinates);
//       }
//     }
//
//     return coordinates;
//   }
//
//   DirectionsModel copyWith({
//     List<GeocodedWaypoints>? geocodedWaypoints,
//     List<RouteModel>? routes,
//     String? status,
//   }) =>
//       DirectionsModel(
//         geocodedWaypoints: geocodedWaypoints ?? this.geocodedWaypoints,
//         routes: routes ?? this.routes,
//         status: status ?? this.status,
//       );
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     if (geocodedWaypoints != null) {
//       map['geocoded_waypoints'] =
//           geocodedWaypoints?.map((v) => v.toJson()).toList();
//     }
//     if (routes != null) {
//       map['routes'] = routes?.map((v) => v.toJson()).toList();
//     }
//     map['status'] = status;
//     return map;
//   }
// }
//
// class RouteModel {
//   RouteModel({
//     this.bounds,
//     this.copyrights,
//     this.legs,
//     this.overviewPolyline,
//     this.summary,
//     this.warnings,
//     this.waypointOrder,
//   });
//
//   RouteModel.fromJson(dynamic json) {
//     bounds =
//         json['bounds'] != null ? BoundModel.fromJson(json['bounds']) : null;
//     copyrights = json['copyrights'];
//     if (json['legs'] != null) {
//       legs = [];
//       json['legs'].forEach((v) {
//         legs?.add(LegModel.fromJson(v));
//       });
//     }
//     overviewPolyline = json['overview_polyline'] != null
//         ? OverviewPolyline.fromJson(json['overview_polyline'])
//         : null;
//     summary = json['summary'];
//   }
//
//   BoundModel? bounds;
//   String? copyrights;
//   List<LegModel>? legs;
//   OverviewPolyline? overviewPolyline;
//   String? summary;
//   List<dynamic>? warnings;
//   List<dynamic>? waypointOrder;
//
//   RouteModel copyWith({
//     BoundModel? bounds,
//     String? copyrights,
//     List<LegModel>? legs,
//     OverviewPolyline? overviewPolyline,
//     String? summary,
//     List<dynamic>? warnings,
//     List<dynamic>? waypointOrder,
//   }) =>
//       RouteModel(
//         bounds: bounds ?? this.bounds,
//         copyrights: copyrights ?? this.copyrights,
//         legs: legs ?? this.legs,
//         overviewPolyline: overviewPolyline ?? this.overviewPolyline,
//         summary: summary ?? this.summary,
//         warnings: warnings ?? this.warnings,
//         waypointOrder: waypointOrder ?? this.waypointOrder,
//       );
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     if (bounds != null) {
//       map['bounds'] = bounds?.toJson();
//     }
//     map['copyrights'] = copyrights;
//     if (legs != null) {
//       map['legs'] = legs?.map((v) => v.toJson()).toList();
//     }
//     if (overviewPolyline != null) {
//       map['overview_polyline'] = overviewPolyline?.toJson();
//     }
//     map['summary'] = summary;
//     if (warnings != null) {
//       map['warnings'] = warnings?.map((v) => v.toJson()).toList();
//     }
//     if (waypointOrder != null) {
//       map['waypoint_order'] = waypointOrder?.map((v) => v.toJson()).toList();
//     }
//     return map;
//   }
// }
//
// class OverviewPolyline {
//   OverviewPolyline({
//     this.points,
//   });
//
//   OverviewPolyline.fromJson(dynamic json) {
//     points = json['points'];
//   }
//
//   String? points;
//
//   OverviewPolyline copyWith({
//     String? points,
//   }) =>
//       OverviewPolyline(
//         points: points ?? this.points,
//       );
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['points'] = points;
//     return map;
//   }
// }
//
// class LegModel {
//   LegModel({
//     this.distance,
//     this.duration,
//     this.endAddress,
//     this.endLocation,
//     this.startAddress,
//     this.startLocation,
//     this.steps,
//   });
//
//   LegModel.fromJson(dynamic json) {
//     distance =
//         json['distance'] != null ? PairModel.fromJson(json['distance']) : null;
//     duration =
//         json['duration'] != null ? PairModel.fromJson(json['duration']) : null;
//     endAddress = json['end_address'];
//     endLocation = json['end_location'] != null
//         ? Coordinate.fromJson(json['end_location'])
//         : null;
//     startAddress = json['start_address'];
//     startLocation = json['start_location'] != null
//         ? Coordinate.fromJson(json['start_location'])
//         : null;
//     if (json['steps'] != null) {
//       steps = [];
//       json['steps'].forEach((v) {
//         steps?.add(StepModel.fromJson(v));
//       });
//     }
//   }
//
//   PairModel? distance;
//   PairModel? duration;
//   String? endAddress;
//   Coordinate? endLocation;
//   String? startAddress;
//   Coordinate? startLocation;
//   List<StepModel>? steps;
//
//   LegModel copyWith({
//     PairModel? distance,
//     PairModel? duration,
//     String? endAddress,
//     Coordinate? endLocation,
//     String? startAddress,
//     Coordinate? startLocation,
//     List<StepModel>? steps,
//   }) =>
//       LegModel(
//         distance: distance ?? this.distance,
//         duration: duration ?? this.duration,
//         endAddress: endAddress ?? this.endAddress,
//         endLocation: endLocation ?? this.endLocation,
//         startAddress: startAddress ?? this.startAddress,
//         startLocation: startLocation ?? this.startLocation,
//         steps: steps ?? this.steps,
//       );
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     if (distance != null) {
//       map['distance'] = distance?.toJson();
//     }
//     if (duration != null) {
//       map['duration'] = duration?.toJson();
//     }
//     map['end_address'] = endAddress;
//     if (endLocation != null) {
//       map['end_location'] = endLocation?.toJson();
//     }
//     map['start_address'] = startAddress;
//     if (startLocation != null) {
//       map['start_location'] = startLocation?.toJson();
//     }
//     if (steps != null) {
//       map['steps'] = steps?.map((v) => v.toJson()).toList();
//     }
//     return map;
//   }
// }
//
// class StepModel {
//   StepModel({
//     this.distance,
//     this.duration,
//     this.endLocation,
//     this.htmlInstructions,
//     this.polyline,
//     this.startLocation,
//     this.travelMode,
//   });
//
//   StepModel.fromJson(dynamic json) {
//     distance =
//         json['distance'] != null ? PairModel.fromJson(json['distance']) : null;
//     duration =
//         json['duration'] != null ? PairModel.fromJson(json['duration']) : null;
//     endLocation = json['end_location'] != null
//         ? Coordinate.fromJson(json['end_location'])
//         : null;
//     htmlInstructions = json['html_instructions'];
//     polyline = json['polyline'] != null
//         ? PolylineModel.fromJson(json['polyline'])
//         : null;
//     startLocation = json['start_location'] != null
//         ? Coordinate.fromJson(json['start_location'])
//         : null;
//     travelMode = json['travel_mode'];
//   }
//
//   PairModel? distance;
//   PairModel? duration;
//   Coordinate? endLocation;
//   String? htmlInstructions;
//   PolylineModel? polyline;
//   Coordinate? startLocation;
//   String? travelMode;
//
//   StepModel copyWith({
//     PairModel? distance,
//     PairModel? duration,
//     Coordinate? endLocation,
//     String? htmlInstructions,
//     PolylineModel? polyline,
//     Coordinate? startLocation,
//     String? travelMode,
//   }) =>
//       StepModel(
//         distance: distance ?? this.distance,
//         duration: duration ?? this.duration,
//         endLocation: endLocation ?? this.endLocation,
//         htmlInstructions: htmlInstructions ?? this.htmlInstructions,
//         polyline: polyline ?? this.polyline,
//         startLocation: startLocation ?? this.startLocation,
//         travelMode: travelMode ?? this.travelMode,
//       );
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     if (distance != null) {
//       map['distance'] = distance?.toJson();
//     }
//     if (duration != null) {
//       map['duration'] = duration?.toJson();
//     }
//     if (endLocation != null) {
//       map['end_location'] = endLocation?.toJson();
//     }
//     map['html_instructions'] = htmlInstructions;
//     if (polyline != null) {
//       map['polyline'] = polyline?.toJson();
//     }
//     if (startLocation != null) {
//       map['start_location'] = startLocation?.toJson();
//     }
//     map['travel_mode'] = travelMode;
//     return map;
//   }
// }
//
// class PolylineModel {
//   PolylineModel({
//     this.points,
//   });
//
//   PolylineModel.fromJson(dynamic json) {
//     points = json['points'];
//   }
//
//   String? points;
//
//   PolylineModel copyWith({
//     String? points,
//   }) =>
//       PolylineModel(
//         points: points ?? this.points,
//       );
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['points'] = points;
//     return map;
//   }
// }
//
// class PairModel {
//   PairModel({
//     this.text,
//     this.value,
//   });
//
//   PairModel.fromJson(dynamic json) {
//     text = json['text'];
//     value = json['value'];
//   }
//
//   String? text;
//   num? value;
//
//   PairModel copyWith({
//     String? text,
//     num? value,
//   }) =>
//       PairModel(
//         text: text ?? this.text,
//         value: value ?? this.value,
//       );
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['text'] = text;
//     map['value'] = value;
//     return map;
//   }
// }
//
// class BoundModel {
//   BoundModel({
//     this.northeast,
//     this.southwest,
//   });
//
//   BoundModel.fromJson(dynamic json) {
//     northeast = json['northeast'] != null
//         ? Coordinate.fromJson(json['northeast'])
//         : null;
//     southwest = json['southwest'] != null
//         ? Coordinate.fromJson(json['southwest'])
//         : null;
//   }
//
//   Coordinate? northeast;
//   Coordinate? southwest;
//
//   BoundModel copyWith({
//     Coordinate? northeast,
//     Coordinate? southwest,
//   }) =>
//       BoundModel(
//         northeast: northeast ?? this.northeast,
//         southwest: southwest ?? this.southwest,
//       );
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     if (northeast != null) {
//       map['northeast'] = northeast?.toJson();
//     }
//     if (southwest != null) {
//       map['southwest'] = southwest?.toJson();
//     }
//     return map;
//   }
// }
//
// class Coordinate {
//   Coordinate({
//     this.lat,
//     this.lng,
//   });
//
//   Coordinate.fromJson(dynamic json) {
//     lat = json['lat'];
//     lng = json['lng'];
//   }
//
//   num? lat;
//   num? lng;
//
//   Coordinate copyWith({
//     num? lat,
//     num? lng,
//   }) =>
//       Coordinate(
//         lat: lat ?? this.lat,
//         lng: lng ?? this.lng,
//       );
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['lat'] = lat;
//     map['lng'] = lng;
//     return map;
//   }
//
//   LatLng get toLatLng => LatLng(lat?.toDouble() ?? 0, lng?.toDouble() ?? 0);
// }
//
// class GeocodedWaypoints {
//   GeocodedWaypoints({
//     this.geocoderStatus,
//     this.placeId,
//     this.types,
//   });
//
//   GeocodedWaypoints.fromJson(dynamic json) {
//     geocoderStatus = json['geocoder_status'];
//     placeId = json['place_id'];
//     types = json['types'] != null ? json['types'].cast<String>() : [];
//   }
//
//   String? geocoderStatus;
//   String? placeId;
//   List<String>? types;
//
//   GeocodedWaypoints copyWith({
//     String? geocoderStatus,
//     String? placeId,
//     List<String>? types,
//   }) =>
//       GeocodedWaypoints(
//         geocoderStatus: geocoderStatus ?? this.geocoderStatus,
//         placeId: placeId ?? this.placeId,
//         types: types ?? this.types,
//       );
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['geocoder_status'] = geocoderStatus;
//     map['place_id'] = placeId;
//     map['types'] = types;
//     return map;
//   }
// }
