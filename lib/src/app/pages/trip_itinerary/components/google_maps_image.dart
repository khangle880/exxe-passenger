import 'dart:async';
import 'package:exxe/src/utils/export/ui_export.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import '../../../../data/data.dart';
import 'dart:math' as math;

class GoogleMapImageDetailTrip extends StatefulWidget {
  const GoogleMapImageDetailTrip({
    Key? key,
    required this.startLatitude,
    required this.endLatitude,
    required this.startLongitude,
    required this.endLongitude,
    required this.driver,
    required this.customer,
  }) : super(key: key);
  final String startLatitude;
  final String endLatitude;
  final String startLongitude;
  final String endLongitude;
  final CarDriverModel driver;
  final CompoundingCarCustomerModel customer;

  @override
  State<GoogleMapImageDetailTrip> createState() =>
      _GoogleMapImageDetailTripState();
}

class _GoogleMapImageDetailTripState extends State<GoogleMapImageDetailTrip> {
  MapboxMapController? mapController;

  CompoundingCarCustomerState get state => widget.customer.state!;

  LineOptions? driverIncomingPolyline;
  late final RemoveListener listener;

  late final LatLng centerLatLng;
  Uint8List? dataBytes;

  late StreamSubscription<DatabaseEvent> _locationSubscription;
  late DatabaseReference _locationRef;

  @override
  void initState() {
    super.initState();
    centerLatLng = getCenterPoint(
        startLat: widget.startLatitude,
        startLong: widget.startLongitude,
        endLat: widget.endLatitude,
        endLong: widget.endLongitude);

    initTripRoute();

    if ([
      CompoundingCarCustomerState.startRunning,
      CompoundingCarCustomerState.waitingCustomer,
      CompoundingCarCustomerState.inProcess,
      CompoundingCarCustomerState.startReturn,
      CompoundingCarCustomerState.inReturnProcess,
    ].contains(state)) {
      setListener();
    }
  }

  setListener() async {
    _locationRef = FirebaseDatabase.instance
        .ref("location/${widget.driver.partnerId ?? ""}");
    _locationSubscription = _locationRef.onValue.listen(
      (DatabaseEvent event) {
        final payload = event.snapshot.value as Map?;
        log("Location $payload");

        final driverLat = payload?['latitude'];
        final driverLong = payload?['longitude'];
        if (driverLat != null && driverLong != null) {
          updateLocation(driverLat, driverLong);
        }
      },
      onError: (Object error) {
        log("location $error");
      },
    );
  }

  updateLocation(double lat, double long) async {
    if (driverIncomingPolyline == null &&
        [
          CompoundingCarCustomerState.startRunning,
          CompoundingCarCustomerState.waitingCustomer,
          CompoundingCarCustomerState.startReturn,
        ].contains(state)) {
      driverIncomingPolyline = await getPolyLine(
        startLat: lat,
        startLong: long,
        endLat: double.parse(widget.startLatitude),
        endLong: double.parse(widget.startLongitude),
        key: "driver incoming",
        color: Colors.cyanAccent.withOpacity(0.8),
      );
      if (driverIncomingPolyline != null) {
        mapController?.addLine(driverIncomingPolyline!);
      }
    }

    // update driver marker
    mapController?.addSymbol(
      SymbolOptions(
        iconImage: AppIcons.carMarker,
        geometry: LatLng(lat, long),
        iconSize: 1.5,
      ),
    );
    if (mounted) {
      setState(() {});
    }

    updateCamera(
      LatLng(lat, long),
      LatLng(
        double.parse(widget.startLatitude),
        double.parse(widget.startLongitude),
      ),
    );
  }

  @override
  dispose() {
    if ([
      CompoundingCarCustomerState.startRunning,
      CompoundingCarCustomerState.waitingCustomer,
      CompoundingCarCustomerState.startReturn
    ].contains(state)) {
      _locationSubscription.cancel();
    }

    super.dispose();
  }

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;

    LatLng latLng_1 = LatLng(double.parse(widget.startLatitude),
        double.parse(widget.startLongitude));
    LatLng latLng_2 = LatLng(
        double.parse(widget.endLatitude), double.parse(widget.endLongitude));

    setState(() {
      mapController?.clearSymbols();
      mapController?.symbolManager?.clear();
      if (widget.customer.state!.index >=
              CompoundingCarCustomerState.startReturn.index &&
          widget.customer.compoundingType == CompoundingType.twoWay) {
        mapController?.addSymbols(
          [
            SymbolOptions(
              geometry: latLng_2,
              iconImage: AppIcons.pickupLocationPng,
              iconSize: 1,
            ),
            SymbolOptions(
              geometry: latLng_1,
              iconImage: AppIcons.locationPng,
              iconSize: 1.5,
              iconOffset: const Offset(0, -10),
            ),
          ],
        );
      } else {
        mapController?.addSymbols(
          [
            SymbolOptions(
              geometry: latLng_1,
              iconImage: AppIcons.pickupLocationPng,
              iconSize: 1,
            ),
            SymbolOptions(
              geometry: latLng_2,
              iconImage: AppIcons.locationPng,
              iconSize: 1.5,
              iconOffset: const Offset(0, -10),
            ),
          ],
        );
      }
    });

    updateCamera(latLng_1, latLng_2);
  }

  updateCamera(LatLng start, LatLng end) async {
    LatLngBounds bound = computeBounds([start, end]);
    CameraUpdate u2 = CameraUpdate.newLatLngBounds(
      bound,
      left: 20,
      bottom: 20,
      right: 20,
      top: 20,
    );
    mapController?.animateCamera(u2).then((void v) {
      if (mapController != null) {
        check(u2, mapController!);
      }
    });
  }

  LatLngBounds computeBounds(List<LatLng> list) {
    assert(list.isNotEmpty);
    var firstLatLng = list.first;
    var s = firstLatLng.latitude,
        n = firstLatLng.latitude,
        w = firstLatLng.longitude,
        e = firstLatLng.longitude;
    for (var i = 1; i < list.length; i++) {
      var latLng = list[i];
      s = math.min(s, latLng.latitude);
      n = math.max(n, latLng.latitude);
      w = math.min(w, latLng.longitude);
      e = math.max(e, latLng.longitude);
    }
    return LatLngBounds(southwest: LatLng(s, w), northeast: LatLng(n, e));
  }

  void check(CameraUpdate u, MapboxMapController c) async {
    c.animateCamera(u);
    LatLngBounds l1 = await c.getVisibleRegion();
    LatLngBounds l2 = await c.getVisibleRegion();
    if (l1.southwest.latitude == -90 || l2.southwest.latitude == -90) {
      check(u, c);
    }
  }

  LatLng getCenterPoint({
    required String startLat,
    required String startLong,
    required String endLat,
    required String endLong,
  }) {
    return LatLng(
      (double.parse(startLat) + double.parse(endLat)) / 2,
      (double.parse(startLong) + double.parse(endLong)) / 2,
    );
  }

  initTripRoute() async {
    final result = await getPolyLine(
      startLat: double.parse(widget.startLatitude),
      startLong: double.parse(widget.startLongitude),
      endLat: double.parse(widget.endLatitude),
      endLong: double.parse(widget.endLongitude),
      key: 'overview_polyline',
      color: AppColors.secondaryMain,
    );
    mapController?.addLine(result);
    setState(() {});
  }

  Future<LineOptions> getPolyLine({
    required double startLat,
    required double startLong,
    required double endLat,
    required double endLong,
    required String key,
    Color? color,
  }) async {
    var result = await GetIt.I<IPlacesRepository>().getDirection(
      fromLat: startLat,
      fromLong: startLong,
      toLat: endLat,
      toLong: endLong,
    );
    return result.fold((failure) {
      log(failure.toString());
      return Future.error(failure);
    }, (data) {
      return LineOptions(
        lineColor: (color ?? AppColors.secondaryMain).toHexStringRGB(),
        lineWidth: 5,
        geometry: data.overviewPolylinePoints,
        draggable: false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final String accessToken =
        dotenv.maybeGet('MAPBOXTOKEN', fallback: null) ?? "";
    final String key = dotenv.maybeGet('GOONG_MAP_KEY', fallback: null) ?? "";
    return Stack(
      children: [
        MapboxMap(
          accessToken: accessToken,
          styleString:
              'https://tiles.goong.io/assets/goong_map_web.json?api_key=$key',
          onMapCreated: _onMapCreated,
          zoomGesturesEnabled: false,
          myLocationEnabled: false,
          initialCameraPosition: CameraPosition(
            target: LatLng(centerLatLng.latitude, centerLatLng.longitude),
            zoom: 7,
          ),
        ),
        Positioned(
          bottom: 20.0,
          right: 20.0,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor: AppColors.gray20,
              borderRadius: BorderRadius.circular(100),
              onTap: () async {
                Position? currentLocation;
                try {
                  currentLocation = await Geolocator.getCurrentPosition();
                } on Exception {
                  currentLocation = null;
                }
                if (currentLocation != null) {
                  mapController?.animateCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(
                      bearing: 0,
                      target: LatLng(
                          currentLocation.latitude, currentLocation.longitude),
                      zoom: 17.0,
                    ),
                  ));
                }
              },
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryLight,
                ),
                padding: const EdgeInsets.all(12),
                child: SvgPicture.asset(
                  AppIcons.gps,
                  color: AppColors.black,
                  height: 24,
                  width: 24,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
