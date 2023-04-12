import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

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
  MapboxMapController? mapController;

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

    mapController?.clearSymbols();
    mapController?.animateCamera(
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

    mapController?.addSymbol(
      SymbolOptions(
        geometry: LatLng(
          coordinateModel.latitude!,
          coordinateModel.longitude!,
        ),
        draggable: false,
        zIndex: 2,
        iconImage: AppIcons.currentLocation,
        iconSize: 60,
      ),
    );

    if (widget.pickupPoint != null) {
      mapController?.addSymbol(
        SymbolOptions(
          geometry: LatLng(
            widget.pickupPoint!.coordinate!.latitude!,
            widget.pickupPoint!.coordinate!.longitude!,
          ),
          iconImage: AppIcons.locationPng,
          iconSize: 60,
        ),
      );
      if (widget.destinationPoint == null) {
        mapController?.animateCamera(
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
      mapController?.addSymbol(
        SymbolOptions(
          geometry: LatLng(
            widget.destinationPoint!.coordinate!.latitude!,
            widget.destinationPoint!.coordinate!.longitude!,
          ),
          iconImage: AppIcons.locationPng,
          iconColor: AppColors.utilRed.toHexStringRGB(),
        ),
      );
      if (widget.pickupPoint == null) {
        mapController?.animateCamera(
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
      mapController?.clearLines();
      mapController?.addLine(
        LineOptions(
          lineColor: AppColors.secondaryMain.toHexStringRGB(),
          lineWidth: 5,
          geometry: widget.directionModel!.overviewPolylinePoints,
        ),
      );

      final bound = widget.directionModel!.bound(
          widget.pickupPoint!.coordinate!,
          widget.destinationPoint!.coordinate!);
      if (bound != null) {
        mapController?.animateCamera(
          CameraUpdate.newLatLngBounds(
            LatLngBounds(
              southwest: bound.southwest!.toLatLng,
              northeast: bound.northeast!.toLatLng,
            ),
            left: 20,
            right: 20,
            top: 20,
            bottom: 20,
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

    return MapboxMap(
      zoomGesturesEnabled: false,
      myLocationEnabled: false,
      onMapCreated: (MapboxMapController controller) {
        mapController = controller;
      },
      initialCameraPosition: CameraPosition(
        target: LatLng(
          coordinateModel.latitude!,
          coordinateModel.longitude!,
        ),
        zoom: 15.0,
      ),
      tiltGesturesEnabled: false,
    );
  }
}
