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

  @override
  void initState() {
    bloc = context.read<NoCompoundingBloc>();
    if (widget.carCustomer != null) {
      bloc.add(MapCarCustomerToState(widget.carCustomer!));
    }
    super.initState();
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
            Padding(
              padding: const EdgeInsets.only(bottom: 300),
              child: BlocBuilder<NoCompoundingBloc, NoCompoundingState>(
                buildWhen: (previous, current) =>
                    previous.pickupPoint != current.pickupPoint ||
                    previous.destinationPoint != current.destinationPoint ||
                    previous.directionsModel != current.directionsModel,
                builder: (context, state) {
                  return GoogleMapBackground(
                    pickupPoint: state.pickupPoint,
                    destinationPoint: state.destinationPoint,
                    directionModel: state.directionsModel,
                  );
                },
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
}
