import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../config/colors.dart';
import '../../../../config/icons.dart';
import '../../../../utils/export/logic_export.dart';

class GoogleMapBackground extends StatefulWidget {
  final LocationModel? pickupPoint;
  final LocationModel? destinationPoint;
  final DirectionModel? directionModel;

  final CoordinateModel? coordinateModel;

  const GoogleMapBackground({
    Key? key,
    this.coordinateModel,
    this.pickupPoint,
    this.destinationPoint,
    this.directionModel,
  }) : super(key: key);

  @override
  State<GoogleMapBackground> createState() => _GoogleMapBackgroundState();
}

class _GoogleMapBackgroundState extends State<GoogleMapBackground> {
  final Set<Marker> markers = {};

  final Set<Polyline> polyLines = {};

  final Completer<GoogleMapController> goggleMapController = Completer();

  @override
  void initState() {
    updateGoogleMap();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant GoogleMapBackground oldWidget) {
    updateGoogleMap();
    super.didUpdateWidget(oldWidget);
  }

  Future<void> updateGoogleMap() async {
    final CoordinateModel coordinateModel =
        GetIt.I.get<AppState>().currentState.currentLocation!.coordinate!;

    markers.clear();
    final BitmapDescriptor currentLocationIcon =
        await GetIt.I<LocationHelper>().getMarker(AppIcons.currentLocation, 60);
    final GoogleMapController controller = await goggleMapController.future;

    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            coordinateModel.latitude!,
            coordinateModel.longitude!,
          ),
          zoom: 15,
        ),
      ),
    );

    markers.add(
      Marker(
        markerId: const MarkerId("home"),
        position: LatLng(
          coordinateModel.latitude!,
          coordinateModel.longitude!,
        ),
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: const Offset(0.5, 0.5),
        icon: currentLocationIcon,
      ),
    );

    if (widget.pickupPoint != null) {
      markers.add(Marker(
        markerId: const MarkerId("pickup"),
        position: LatLng(
          widget.pickupPoint!.coordinate!.latitude!,
          widget.pickupPoint!.coordinate!.longitude!,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
      ));
      if (widget.destinationPoint == null) {
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(
                widget.pickupPoint!.coordinate!.latitude!,
                widget.pickupPoint!.coordinate!.longitude!,
              ),
              zoom: 15,
            ),
          ),
        );
      }
    }

    if (widget.destinationPoint != null) {
      markers.add(Marker(
        markerId: const MarkerId("destination"),
        position: LatLng(
          widget.destinationPoint!.coordinate!.latitude!,
          widget.destinationPoint!.coordinate!.longitude!,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      ));
      if (widget.pickupPoint == null) {
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(
                widget.destinationPoint!.coordinate!.latitude!,
                widget.destinationPoint!.coordinate!.longitude!,
              ),
              zoom: 15,
            ),
          ),
        );
      }
    }

    if (widget.directionModel != null) {
      polyLines.clear();
      polyLines.add(
        Polyline(
          polylineId: const PolylineId('overview_polyline'),
          color: AppColors.secondaryMain,
          width: 5,
          points: widget.directionModel!.overviewPolylinePoints,
        ),
      );
      final bound = widget.directionModel!.bound(
          widget.pickupPoint!.coordinate!,
          widget.destinationPoint!.coordinate!);
      if (bound != null) {
        controller.animateCamera(
          CameraUpdate.newLatLngBounds(
            LatLngBounds(
              southwest: bound.southwest!.toLatLng,
              northeast: bound.northeast!.toLatLng,
            ),
            50,
          ),
        );
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    CoordinateModel? coordinateModel = widget.coordinateModel ??
        GetIt.I.get<AppState>().currentState.currentLocation!.coordinate!;
    return GoogleMap(
      zoomControlsEnabled: false,
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      onMapCreated: (GoogleMapController controller) {
        goggleMapController.complete(controller);
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
