import 'dart:async';
import 'package:exxe/src/utils/export/ui_export.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  BitmapDescriptor destinationIcon =
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet);
  final Completer<GoogleMapController> goggleMapController = Completer();

  CompoundingCarCustomerState get state => widget.customer.state!;

  final Set<Polyline> polyLines = {};
  final Set<Marker> markers = {};
  Polyline? driverIncomingPolyline;
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
        polyLines.add(driverIncomingPolyline!);
      }
    }

    // update driver marker
    final icon = await createCurrentMarkerIcon();

    markers.add(
      Marker(
        icon: icon,
        markerId: const MarkerId('current_location'),
        position: LatLng(lat, long),
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

  Future<BitmapDescriptor> createCurrentMarkerIcon() async {
    return GetIt.I<LocationHelper>().getMarker(AppIcons.carMarker, 120);
  }

  void _onMapCreated(GoogleMapController controller) {
    goggleMapController.complete(controller);

    LatLng latLng_1 = LatLng(double.parse(widget.startLatitude),
        double.parse(widget.startLongitude));
    LatLng latLng_2 = LatLng(
        double.parse(widget.endLatitude), double.parse(widget.endLongitude));

    setState(() {
      markers.clear();
      if (widget.customer.state!.index >=
              CompoundingCarCustomerState.startReturn.index &&
          widget.customer.compoundingType == CompoundingType.twoWay) {
        markers.addAll(
          {
            Marker(
              icon: destinationIcon,
              markerId: const MarkerId('destination'),
              position: latLng_2,
              infoWindow: const InfoWindow(title: "Điểm đón của bạn"),
            ),
            Marker(
              markerId: const MarkerId('pickUpPoint'),
              position: latLng_1,
            ),
          },
        );
      } else {
        markers.addAll(
          {
            Marker(
              markerId: const MarkerId('pickUpPoint'),
              position: latLng_1,
            ),
            Marker(
              icon: destinationIcon,
              markerId: const MarkerId('destination'),
              position: latLng_2,
              infoWindow: const InfoWindow(title: "Điểm đón của bạn"),
            ),
          },
        );
      }
    });

    updateCamera(latLng_1, latLng_2);
  }

  updateCamera(LatLng start, LatLng end) async {
    final GoogleMapController controller = await goggleMapController.future;
    LatLngBounds bound = computeBounds([start, end]);
    CameraUpdate u2 = CameraUpdate.newLatLngBounds(bound, 100);
    controller.animateCamera(u2).then((void v) {
      check(u2, controller);
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

  void check(CameraUpdate u, GoogleMapController c) async {
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
    polyLines.add(result);
    setState(() {});
  }

  Future<Polyline> getPolyLine({
    required double startLat,
    required double startLong,
    required double endLat,
    required double endLong,
    required String key,
    Color? color,
  }) async {
    var result = await GetIt.I<IPlacesRepository>()
        .getDirection(LatLng(startLat, startLong), LatLng(endLat, endLong));
    return result.fold((failure) {
      log(failure.toString());
      return Future.error(failure);
    }, (data) {
      return Polyline(
        polylineId: PolylineId(key),
        color: color ?? AppColors.secondaryMain,
        width: 5,
        points: data.polylinePoints,
        geodesic: true,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          onMapCreated: _onMapCreated,
          zoomControlsEnabled: true,
          myLocationEnabled: false,
          myLocationButtonEnabled: false,
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: LatLng(centerLatLng.latitude, centerLatLng.longitude),
            zoom: 7,
          ),
          markers: markers,
          polylines: polyLines,
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
                final GoogleMapController controller =
                    await goggleMapController.future;
                Position? currentLocation;
                try {
                  currentLocation = await Geolocator.getCurrentPosition();
                } on Exception {
                  currentLocation = null;
                }
                if (currentLocation != null) {
                  controller.animateCamera(CameraUpdate.newCameraPosition(
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
