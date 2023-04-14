import 'dart:math';

import 'package:exxe/src/data/data.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DirectionModel {
  DirectionModel({
    this.geocodedWaypoints,
    this.routes,
  });

  DirectionModel.fromJson(dynamic json) {
    if (json['geocoded_waypoints'] != null) {
      geocodedWaypoints = [];
      json['geocoded_waypoints'].forEach((v) {
        geocodedWaypoints?.add(GeocodedWaypoints.fromJson(v));
      });
    }
    if (json['routes'] != null) {
      routes = [];
      json['routes'].forEach((v) {
        routes?.add(MapRouteModel.fromJson(v));
      });
    }
  }

  List<GeocodedWaypoints>? geocodedWaypoints;
  List<MapRouteModel>? routes;

  DirectionModel copyWith({
    List<GeocodedWaypoints>? geocodedWaypoints,
    List<MapRouteModel>? routes,
  }) =>
      DirectionModel(
        geocodedWaypoints: geocodedWaypoints ?? this.geocodedWaypoints,
        routes: routes ?? this.routes,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (geocodedWaypoints != null) {
      map['geocoded_waypoints'] =
          geocodedWaypoints?.map((v) => v.toJson()).toList();
    }
    if (routes != null) {
      map['routes'] = routes?.map((v) => v.toJson()).toList();
    }
    return map;
  }

  double get getDistanceKm {
    final distance = routes?.first.legs?.first.distance?.value;
    return distance == null
        ? 0
        : double.parse((distance / 1000).toStringAsFixed(2));
  }

  double get getDuration {
    final duration = routes?.first.legs?.first.duration?.value;
    return duration == null ? 0 : (duration / (60 * 60));
  }

  LatLngBounds boundLatLng(LatLng from, LatLng to) {
    double minLat = min(from.latitude, to.latitude);
    double maxLat = max(from.latitude, to.latitude);
    double minLng = min(from.longitude, to.longitude);
    double maxLng = max(from.longitude, to.longitude);
    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  BoundModel? bound(CoordinateModel from, CoordinateModel to) {
    double minLat = min(from.latitude ?? 0, to.latitude ?? 0);
    double maxLat = max(from.latitude ?? 0, to.latitude ?? 0);
    double minLng = min(from.longitude ?? 0, to.longitude ?? 0);
    double maxLng = max(from.longitude ?? 0, to.longitude ?? 0);
    return BoundModel(
      southwest: Coordinate(lat: minLat, lng: minLng),
      northeast: Coordinate(lat: maxLat, lng: maxLng),
    );
  }

  // List<LatLng> get overviewPolylinePoints {
  //   return PolylinePoints()
  //       .decodePolyline(routes?.first.overviewPolyline?.points ?? "")
  //       .map((PointLatLng point) => LatLng(point.latitude, point.longitude))
  //       .toList();
  // }

  List<LatLng> get overviewPolylinePoints {
    List<LatLng> coordinates = [];
    for (final leg in (routes?.first.legs ?? [])) {
      for (final step in (leg.steps ?? [])) {
        List<PointLatLng> result =
            PolylinePoints().decodePolyline(step.polyline.points);

        List<LatLng> stepCoordinates = result
            .map((PointLatLng point) => LatLng(point.latitude, point.longitude))
            .toList();

        if (coordinates.length > 1) {
          if (coordinates.last == stepCoordinates.first) {
            coordinates.removeLast();
          }
        }

        coordinates.addAll(stepCoordinates);
      }
    }

    return coordinates;
  }
}

class MapRouteModel {
  MapRouteModel({
    this.bounds,
    this.legs,
    this.overviewPolyline,
    this.summary,
    this.warnings,
    this.waypointOrder,
  });

  MapRouteModel.fromJson(dynamic json) {
    bounds = json['bounds'];
    if (json['legs'] != null) {
      legs = [];
      json['legs'].forEach((v) {
        legs?.add(Legs.fromJson(v));
      });
    }
    overviewPolyline = json['overview_polyline'] != null
        ? OverviewPolyline.fromJson(json['overview_polyline'])
        : null;
    summary = json['summary'];
    // if (json['warnings'] != null) {
    //   warnings = [];
    //   json['warnings'].forEach((v) {
    //     warnings?.add(Dynamic.fromJson(v));
    //   });
    // }
    // if (json['waypoint_order'] != null) {
    //   waypointOrder = [];
    //   json['waypoint_order'].forEach((v) {
    //     waypointOrder?.add(Dynamic.fromJson(v));
    //   });
    // }
  }

  dynamic bounds;
  List<Legs>? legs;
  OverviewPolyline? overviewPolyline;
  String? summary;
  List<dynamic>? warnings;
  List<dynamic>? waypointOrder;

  MapRouteModel copyWith({
    dynamic bounds,
    List<Legs>? legs,
    OverviewPolyline? overviewPolyline,
    String? summary,
    List<dynamic>? warnings,
    List<dynamic>? waypointOrder,
  }) =>
      MapRouteModel(
        bounds: bounds ?? this.bounds,
        legs: legs ?? this.legs,
        overviewPolyline: overviewPolyline ?? this.overviewPolyline,
        summary: summary ?? this.summary,
        warnings: warnings ?? this.warnings,
        waypointOrder: waypointOrder ?? this.waypointOrder,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['bounds'] = bounds;
    if (legs != null) {
      map['legs'] = legs?.map((v) => v.toJson()).toList();
    }
    if (overviewPolyline != null) {
      map['overview_polyline'] = overviewPolyline?.toJson();
    }
    map['summary'] = summary;
    if (warnings != null) {
      map['warnings'] = warnings?.map((v) => v.toJson()).toList();
    }
    if (waypointOrder != null) {
      map['waypoint_order'] = waypointOrder?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class OverviewPolyline {
  OverviewPolyline({
    this.points,
  });

  OverviewPolyline.fromJson(dynamic json) {
    points = json['points'];
  }

  String? points;

  OverviewPolyline copyWith({
    String? points,
  }) =>
      OverviewPolyline(
        points: points ?? this.points,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['points'] = points;
    return map;
  }
}

class Legs {
  Legs({
    this.distance,
    this.duration,
    this.endAddress,
    this.endLocation,
    this.startAddress,
    this.startLocation,
    this.steps,
  });

  Legs.fromJson(dynamic json) {
    distance =
        json['distance'] != null ? PairModel.fromJson(json['distance']) : null;
    duration =
        json['duration'] != null ? PairModel.fromJson(json['duration']) : null;
    endAddress = json['end_address'];
    endLocation = json['end_location'] != null
        ? Coordinate.fromJson(json['end_location'])
        : null;
    startAddress = json['start_address'];
    startLocation = json['start_location'] != null
        ? StartLocation.fromJson(json['start_location'])
        : null;
    if (json['steps'] != null) {
      steps = [];
      json['steps'].forEach((v) {
        steps?.add(Steps.fromJson(v));
      });
    }
  }

  PairModel? distance;
  PairModel? duration;
  String? endAddress;
  Coordinate? endLocation;
  String? startAddress;
  StartLocation? startLocation;
  List<Steps>? steps;

  Legs copyWith({
    PairModel? distance,
    PairModel? duration,
    String? endAddress,
    Coordinate? endLocation,
    String? startAddress,
    StartLocation? startLocation,
    List<Steps>? steps,
  }) =>
      Legs(
        distance: distance ?? this.distance,
        duration: duration ?? this.duration,
        endAddress: endAddress ?? this.endAddress,
        endLocation: endLocation ?? this.endLocation,
        startAddress: startAddress ?? this.startAddress,
        startLocation: startLocation ?? this.startLocation,
        steps: steps ?? this.steps,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (distance != null) {
      map['distance'] = distance?.toJson();
    }
    if (duration != null) {
      map['duration'] = duration?.toJson();
    }
    map['end_address'] = endAddress;
    if (endLocation != null) {
      map['end_location'] = endLocation?.toJson();
    }
    map['start_address'] = startAddress;
    if (startLocation != null) {
      map['start_location'] = startLocation?.toJson();
    }
    if (steps != null) {
      map['steps'] = steps?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Steps {
  Steps({
    this.distance,
    this.duration,
    this.endLocation,
    this.htmlInstructions,
    this.maneuver,
    this.polyline,
    this.startLocation,
    this.travelMode,
  });

  Steps.fromJson(dynamic json) {
    distance =
        json['distance'] != null ? PairModel.fromJson(json['distance']) : null;
    duration =
        json['duration'] != null ? PairModel.fromJson(json['duration']) : null;
    endLocation = json['end_location'] != null
        ? Coordinate.fromJson(json['end_location'])
        : null;
    htmlInstructions = json['html_instructions'];
    maneuver = json['maneuver'];
    polyline = json['polyline'] != null
        ? OverviewPolyline.fromJson(json['polyline'])
        : null;
    startLocation = json['start_location'] != null
        ? StartLocation.fromJson(json['start_location'])
        : null;
    travelMode = json['travel_mode'];
  }

  PairModel? distance;
  PairModel? duration;
  Coordinate? endLocation;
  String? htmlInstructions;
  String? maneuver;
  OverviewPolyline? polyline;
  StartLocation? startLocation;
  String? travelMode;

  Steps copyWith({
    PairModel? distance,
    PairModel? duration,
    Coordinate? endLocation,
    String? htmlInstructions,
    String? maneuver,
    OverviewPolyline? polyline,
    StartLocation? startLocation,
    String? travelMode,
  }) =>
      Steps(
        distance: distance ?? this.distance,
        duration: duration ?? this.duration,
        endLocation: endLocation ?? this.endLocation,
        htmlInstructions: htmlInstructions ?? this.htmlInstructions,
        maneuver: maneuver ?? this.maneuver,
        polyline: polyline ?? this.polyline,
        startLocation: startLocation ?? this.startLocation,
        travelMode: travelMode ?? this.travelMode,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (distance != null) {
      map['distance'] = distance?.toJson();
    }
    if (duration != null) {
      map['duration'] = duration?.toJson();
    }
    if (endLocation != null) {
      map['end_location'] = endLocation?.toJson();
    }
    map['html_instructions'] = htmlInstructions;
    map['maneuver'] = maneuver;
    if (polyline != null) {
      map['polyline'] = polyline?.toJson();
    }
    if (startLocation != null) {
      map['start_location'] = startLocation?.toJson();
    }
    map['travel_mode'] = travelMode;
    return map;
  }
}

class StartLocation {
  StartLocation({
    this.lat,
    this.lng,
  });

  StartLocation.fromJson(dynamic json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  num? lat;
  num? lng;

  StartLocation copyWith({
    num? lat,
    num? lng,
  }) =>
      StartLocation(
        lat: lat ?? this.lat,
        lng: lng ?? this.lng,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['lat'] = lat;
    map['lng'] = lng;
    return map;
  }
}

class Coordinate {
  Coordinate({
    this.lat,
    this.lng,
  });

  Coordinate.fromJson(dynamic json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  num? lat;
  num? lng;

  Coordinate copyWith({
    num? lat,
    num? lng,
  }) =>
      Coordinate(
        lat: lat ?? this.lat,
        lng: lng ?? this.lng,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['lat'] = lat;
    map['lng'] = lng;
    return map;
  }

  LatLng get toLatLng => LatLng(lat?.toDouble() ?? 0, lng?.toDouble() ?? 0);
}

class PairModel {
  PairModel({
    this.text,
    this.value,
  });

  PairModel.fromJson(dynamic json) {
    text = json['text'];
    value = json['value'];
  }

  String? text;
  num? value;

  PairModel copyWith({
    String? text,
    num? value,
  }) =>
      PairModel(
        text: text ?? this.text,
        value: value ?? this.value,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['text'] = text;
    map['value'] = value;
    return map;
  }
}

class GeocodedWaypoints {
  GeocodedWaypoints({
    this.geocoderStatus,
    this.placeId,
  });

  GeocodedWaypoints.fromJson(dynamic json) {
    geocoderStatus = json['geocoder_status'];
    placeId = json['place_id'];
  }

  String? geocoderStatus;
  String? placeId;

  GeocodedWaypoints copyWith({
    String? geocoderStatus,
    String? placeId,
  }) =>
      GeocodedWaypoints(
        geocoderStatus: geocoderStatus ?? this.geocoderStatus,
        placeId: placeId ?? this.placeId,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['geocoder_status'] = geocoderStatus;
    map['place_id'] = placeId;
    return map;
  }
}

class BoundModel {
  BoundModel({
    this.northeast,
    this.southwest,
  });

  BoundModel.fromJson(dynamic json) {
    northeast = json['northeast'] != null
        ? Coordinate.fromJson(json['northeast'])
        : null;
    southwest = json['southwest'] != null
        ? Coordinate.fromJson(json['southwest'])
        : null;
  }

  Coordinate? northeast;
  Coordinate? southwest;

  BoundModel copyWith({
    Coordinate? northeast,
    Coordinate? southwest,
  }) =>
      BoundModel(
        northeast: northeast ?? this.northeast,
        southwest: southwest ?? this.southwest,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (northeast != null) {
      map['northeast'] = northeast?.toJson();
    }
    if (southwest != null) {
      map['southwest'] = southwest?.toJson();
    }
    return map;
  }
}
