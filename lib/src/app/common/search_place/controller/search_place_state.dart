part of 'search_place_bloc.dart';

class SearchPlaceState extends Equatable {
  final List<SuggestivePlaceModel>? suggestivePlaces;
  final LocationModel? locationModel;

  const SearchPlaceState({
    this.suggestivePlaces,
    this.locationModel,
  });

  @override
  List<Object?> get props => [
        suggestivePlaces,
        locationModel,
      ];

  SearchPlaceState copyWith({
    List<SuggestivePlaceModel>? suggestivePlaces,
    LocationModel? locationModel,
  }) {
    return SearchPlaceState(
      suggestivePlaces: suggestivePlaces,
      locationModel: locationModel ?? this.locationModel,
    );
  }
}
