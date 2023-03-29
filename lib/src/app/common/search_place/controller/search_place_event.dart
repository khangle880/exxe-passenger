part of 'search_place_bloc.dart';

abstract class SearchPlaceEvent {
  const SearchPlaceEvent();
}

class LocationAutoComplete extends SearchPlaceEvent {
  final String searchText;

  const LocationAutoComplete({this.searchText = ''});
}

class PickingNewPosition extends SearchPlaceEvent {
  final String placeId;

  PickingNewPosition(this.placeId);
}

