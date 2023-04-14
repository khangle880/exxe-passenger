import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
    Future.delayed(const Duration(milliseconds: 1000), () {
      updateGoogleMap();
    });
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
        zIndex: 2,
        iconImage: AppIcons.currentLocation,
        iconSize: 2,
      ),
    );

    if (widget.pickupPoint != null) {
      mapController?.addSymbol(
        SymbolOptions(
          geometry: LatLng(
            widget.pickupPoint!.coordinate!.latitude!,
            widget.pickupPoint!.coordinate!.longitude!,
          ),
          iconImage: AppIcons.pickupLocationPng,
          iconSize: 1,
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
          iconSize: 1.5,
          iconOffset: const Offset(0, -10),
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

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    CoordinateModel? coordinateModel = widget.coordinateModel ??
        GetIt.I.get<AppState>().currentState.currentLocation!.coordinate!;

    final String accessToken =
        dotenv.maybeGet('MAPBOXTOKEN', fallback: null) ?? "";
    final String key = dotenv.maybeGet('GOONG_MAP_KEY', fallback: null) ?? "";
    return MapboxMap(
      accessToken: accessToken,
      styleString:
          'https://tiles.goong.io/assets/goong_map_web.json?api_key=$key',
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
    );
  }
}
