import 'dart:async';

import 'package:exxe/src/utils/export/ui_export.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/base_state.dart';
import '../../../data/data.dart';
import 'components/components.dart';
import 'controllers/no_compounding_bloc.dart';

class NoCompoundingPage extends StatefulWidget {
  final CompoundingCarCustomerModel? carCustomer;

  const NoCompoundingPage({super.key, this.carCustomer});

  @override
  State<NoCompoundingPage> createState() => _NoCompoundingPageState();
}

class _NoCompoundingPageState
    extends BaseState<NoCompoundingPage, NoCompoundingBloc> {
  @override
  late final NoCompoundingBloc bloc;

  final CoordinateModel coordinateModel =
      GetIt.I.get<AppState>().currentState.currentLocation!.coordinate!;

  final Set<Marker> markers = {};

  final Set<Polyline> polyLines = {};

  final Completer<GoogleMapController> goggleMapController = Completer();

  @override
  void initState() {
    bloc = context.read<NoCompoundingBloc>();
    if (widget.carCustomer != null) {
      bloc.add(MapCarCustomerToState(widget.carCustomer!));
    }
    super.initState();
    updateGoogleMap(context.read<NoCompoundingBloc>().state);
  }

  bool canLoadAvailableTrip(
      NoCompoundingState previous, NoCompoundingState current) {
    return (previous.pickupPoint != current.pickupPoint ||
            previous.destinationPoint != current.destinationPoint ||
            previous.expectedGoingOnDate != current.expectedGoingOnDate) &&
        current.pickupPoint != null &&
        current.destinationPoint != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            BlocListener<NoCompoundingBloc, NoCompoundingState>(
              listenWhen: (previous, current) =>
                  previous.pickupPoint != current.pickupPoint ||
                  previous.destinationPoint != current.destinationPoint ||
                  previous.directionsModel != current.directionsModel,
              listener: (context, state) {
                updateGoogleMap(state);
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 300),
                child: GoogleMapBackground(
                  controller: goggleMapController,
                  markers: markers,
                  polyLines: polyLines,
                ),
              ),
            ),
            const Positioned(
              left: 8,
              top: 8,
              child: SafeArea(
                child: IconArrowBackCircle(),
              ),
            ),
            Positioned(
              bottom: 0.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  BlocConsumer<NoCompoundingBloc, NoCompoundingState>(
                    listenWhen: canLoadAvailableTrip,
                    listener: (context, state) {
                      bloc.add(GetListAvailableTrips());
                    },
                    builder: (context, state) {
                      if (state.carModels != null &&
                          state.carModels!.isNotEmpty) {
                        return ListAvailableTrip(
                          from: state.pickupPoint,
                          to: state.destinationPoint,
                          date: state.expectedGoingOnDate,
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                  BodyNoCompounding(
                    carCustomer: widget.carCustomer,
                  ),
                ],
              ),
            )
          ],
        ));
  }

  Future<void> updateGoogleMap(
    NoCompoundingState state,
  ) async {
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

    if (state.pickupPoint != null) {
      markers.add(Marker(
        markerId: const MarkerId("pickup"),
        position: LatLng(
          state.pickupPoint!.coordinate!.latitude!,
          state.pickupPoint!.coordinate!.longitude!,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
      ));
      if (state.destinationPoint == null) {
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(
                state.pickupPoint!.coordinate!.latitude!,
                state.pickupPoint!.coordinate!.longitude!,
              ),
              zoom: 15,
            ),
          ),
        );
      }
    }

    if (state.destinationPoint != null) {
      markers.add(Marker(
        markerId: const MarkerId("destination"),
        position: LatLng(
          state.destinationPoint!.coordinate!.latitude!,
          state.destinationPoint!.coordinate!.longitude!,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      ));
      if (state.pickupPoint == null) {
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(
                state.destinationPoint!.coordinate!.latitude!,
                state.destinationPoint!.coordinate!.longitude!,
              ),
              zoom: 15,
            ),
          ),
        );
      }
    }

    if (state.directionsModel != null) {
      polyLines.clear();
      polyLines.add(
        Polyline(
          polylineId: const PolylineId('overview_polyline'),
          color: AppColors.secondaryMain,
          width: 5,
          points: state.directionsModel!.polylinePoints,
        ),
      );
      if (state.directionsModel?.bound != null) {
        final bound = state.directionsModel!.bound!;
        controller.animateCamera(
          CameraUpdate.newLatLngBounds(
              LatLngBounds(
                southwest: bound.southwest!.toLatLng,
                northeast: bound.northeast!.toLatLng,
              ),
              50),
        );
      }
    }
    if (mounted) {
      setState(() {});
    }
  }
}
