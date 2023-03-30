part of 'no_compounding_bloc.dart';

abstract class NoCompoundingEvent extends Equatable {
  const NoCompoundingEvent();

  @override
  List<Object> get props => [];
}

class LoadDefaultGoingOnDate extends NoCompoundingEvent {
  const LoadDefaultGoingOnDate();
}

class GetPickUpPointEvent extends NoCompoundingEvent {
  final LocationModel pickUpPoint;

  const GetPickUpPointEvent(this.pickUpPoint);
}

class GetDestinationPointEvent extends NoCompoundingEvent {
  final LocationModel destination;

  const GetDestinationPointEvent(this.destination);
}

class GetScheduleEvent extends NoCompoundingEvent {
  final DateTime time;

  const GetScheduleEvent(this.time);
}

class GetCarTypeEvent extends NoCompoundingEvent {
  final CarPriceModel carType;

  const GetCarTypeEvent(this.carType);
}

class GetOptionFareTableAndDistance extends NoCompoundingEvent {}

class GetCompoundingCarEvent extends NoCompoundingEvent {
  final CompoundingCarCustomerModel carCustomerModel;

  const GetCompoundingCarEvent(this.carCustomerModel);
}

class GetListAvailableTrips extends NoCompoundingEvent {}

class MapCarCustomerToState extends NoCompoundingEvent {
  final CompoundingCarCustomerModel carCustomer;

  const MapCarCustomerToState(this.carCustomer);
}
