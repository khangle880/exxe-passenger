import 'dart:async';

import 'package:exxe/src/utils/export/ui_export.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../data/data.dart';

class GoogleMapSearchPlace extends StatelessWidget {
  final Set<Marker> markers;
  final Completer<GoogleMapController> controller;
  final CoordinateModel coordinateModel;
  final Function(LatLng)? onTap;

  const GoogleMapSearchPlace({
    Key? key,
    required this.markers,
    required this.controller,
    required this.coordinateModel,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onTap: onTap,
      onMapCreated: (GoogleMapController controller) {
        this.controller.complete(controller);
      },
      zoomControlsEnabled: false,
      initialCameraPosition: CameraPosition(
        target: LatLng(
          coordinateModel.latitude!,
          coordinateModel.longitude!,
        ),
        zoom: 15.0,
      ),
      markers: markers,
    );
  }
}
