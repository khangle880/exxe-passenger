// ignore: depend_on_referenced_packages

import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../utils/export/logic_export.dart';

part 'no_compounding_event.dart';

part 'no_compounding_state.dart';

class NoCompoundingBloc
    extends BaseBloc<NoCompoundingEvent, NoCompoundingState> {
  final IPlacesRepository placesRepository;
  final IDataControllerRepo dataControllerRepo;
  final CompoundingType compoundingType;

  NoCompoundingBloc(
    this.placesRepository,
    this.dataControllerRepo,
    this.compoundingType,
  ) : super(
          NoCompoundingState(expectedGoingOnDate: DateTime.now()),
        ) {
    on<LoadDefaultGoingOnDate>((event, emit) {
      final minutes = (DateTime.now().time.inMinutes + 3 * 60).roundUp(15).ceil();
      final time = minutes < 18 * 60
          ? DateTime.now().date.add(Duration(minutes: minutes))
          : DateTime.now().date.add(const Duration(days: 1, hours: 8));
      emit(state.copyWith(expectedGoingOnDate: time));
    });
    on<GetCarTypeEvent>(
      (event, emit) =>
          emit(state.copyWith(currentCarPrice: Nullable(event.carType))),
    );

    on<GetPickUpPointEvent>((event, emit) async {
      emit(state.copyWith(pickupPoint: event.pickUpPoint));
      if (state.destinationPoint != null) {
        add(GetOptionFareTableAndDistance());
      }
    });

    on<GetDestinationPointEvent>((event, emit) async {
      emit(state.copyWith(destinationPoint: event.destination));
      if (state.pickupPoint != null) {
        add(GetOptionFareTableAndDistance());
      }
    });

    on<GetScheduleEvent>(
      (event, emit) => emit(state.copyWith(expectedGoingOnDate: event.time)),
    );

    on<GetOptionFareTableAndDistance>((event, emit) async {
      List<CarPriceModel>? listCardPrices;
      DirectionsModel? directionsModel;
      emit(state.copyWith(currentCarPrice: Nullable(null)));
      var directionsModelResult = await placesRepository.getDirection(
        LatLng(
          state.pickupPoint!.coordinate!.latitude!,
          state.pickupPoint!.coordinate!.longitude!,
        ),
        LatLng(
          state.destinationPoint!.coordinate!.latitude!,
          state.destinationPoint!.coordinate!.longitude!,
        ),
      );
      directionsModelResult.fold(
        (failure) {
          emitError(failure);
        },
        (data) {
          directionsModel = data;
        },
      );
      if (directionsModel != null) {
        var cardPrincesResult = await dataControllerRepo.getCarFareTable(
          distance: directionsModel!.getDistanceKm,
          duration: directionsModel!.getDuration,
          type: compoundingType,
          expectedGoingOnDate: state.expectedGoingOnDate,
        );
        cardPrincesResult.fold(
          (failure) {
            emitError(failure);
          },
          (data) {
            listCardPrices = data;
          },
        );
      }

      if (directionsModel != null && listCardPrices != null) {
        emit(
          state.copyWith(
            directionsModel: directionsModel,
            carPriceModels: listCardPrices,
            currentCarPrice: Nullable(listCardPrices!
                    .where((element) =>
                        element.carId?.carId ==
                        state.currentCarPrice?.carId?.carId)
                    .firstOrNull ??
                listCardPrices!.first),
          ),
        );
      }
    });

    on<GetListAvailableTrips>((event, emit) async {
      var result = await GetIt.I<CompoundingCarControllerRepo>()
          .getCompoundingCarAvailable(
        type: CompoundingType.convenient,
        fromProvinceId: state.pickupPoint?.provinceId,
        toProvinceId: state.destinationPoint?.provinceId,
      );
      return result.fold(
        (failure) {
          log(failure.toString());
        },
        (data) {
          emit(state.copyWith(carModels: data));
        },
      );
    });

    on<MapCarCustomerToState>((event, emit) async {
      LocationModel pickUpPoint = LocationModel(
        address: event.carCustomer.fromAddress,
        coordinate: CoordinateModel(
          latitude: double.parse(event.carCustomer.fromLatitude!),
          longitude: double.parse(event.carCustomer.fromLongitude!),
        ),
        province: event.carCustomer.fromProvince,
        provinceId: event.carCustomer.fromProvince?.provinceId?.ceil(),
      );
      LocationModel destinationPoint = LocationModel(
        address: event.carCustomer.toAddress,
        coordinate: CoordinateModel(
          latitude: double.parse(event.carCustomer.toLatitude!),
          longitude: double.parse(event.carCustomer.toLongitude!),
        ),
        province: event.carCustomer.toProvince,
        provinceId: event.carCustomer.toProvince?.provinceId?.ceil(),
      );
      emit(state.copyWith(
        pickupPoint: pickUpPoint,
        destinationPoint: destinationPoint,
        expectedGoingOnDate: event.carCustomer.expectedGoingOnDate,
        currentCarPrice: Nullable(event.carCustomer.priceUnit),
      ));
      add(GetOptionFareTableAndDistance());
    });
  }
}
