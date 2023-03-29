import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../data/data.dart';
import '../../../app_state.dart';

class GoogleMapBackground extends StatelessWidget {
  final Set<Marker> markers;
  final Completer<GoogleMapController> controller;
  final Set<Polyline> polyLines;
  final CoordinateModel? coordinateModel;

  const GoogleMapBackground({
    Key? key,
    required this.markers,
    required this.controller,
    required this.polyLines,
    this.coordinateModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CoordinateModel? coordinateModel = this.coordinateModel ??
        GetIt.I.get<AppState>().currentState.currentLocation!.coordinate!;
    return GoogleMap(
      zoomControlsEnabled: false,
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      onMapCreated: (GoogleMapController controller) {
        this.controller.complete(controller);
      },
      initialCameraPosition: CameraPosition(
          target: LatLng(
            coordinateModel.latitude!,
            coordinateModel.longitude!,
          ),
          zoom: 15.0),
      markers: markers,
      tiltGesturesEnabled: false,
      mapType: MapType.normal,
      polylines: polyLines,
    );
  }
}
