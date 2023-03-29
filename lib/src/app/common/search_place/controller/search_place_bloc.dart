// ignore_for_file: depend_on_referenced_packages
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../../data/data.dart';
import '../../../../utils/helpers/location_helper.dart';

part 'search_place_event.dart';

part 'search_place_state.dart';

const _duration = Duration(milliseconds: 300);

EventTransformer<Event> debounce<Event>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

class SearchPlaceBloc extends Bloc<SearchPlaceEvent, SearchPlaceState> {
  final IPlacesRepository _placeRepository = GetIt.I<PlaceRepository>();

  SearchPlaceBloc() : super(const SearchPlaceState()) {
    on<LocationAutoComplete>(
      (event, emit) async {
        if (event.searchText.isEmpty) {
          emit(state.copyWith(suggestivePlaces: null));
          return;
        }
        final searchTerm = event.searchText;
        final results = await _placeRepository.getAutocomplete(searchTerm);
        results.fold((failure) {
          log('google auto search co loi');
        }, (data) {
          emit(state.copyWith(suggestivePlaces: data));
        });
      },
      transformer: debounce(_duration),
    );

    on<PickingNewPosition>((event, emit) async {
      LocationModel? locationModel;
      var result = await _placeRepository.getPlaceById(event.placeId);
      await result.fold(
        (l) => null,
        (data) async {
          ProvinceModel? provinceModel = await GetIt.I<LocationHelper>()
              .fromGoogleAddressToProvinceModel(data.formattedAddress!);
          locationModel = LocationModel(
            address: data.formattedAddress,
            coordinate: data.coordinate,
            provinceId: provinceModel?.provinceId?.ceil(),
            province: provinceModel,
            stations: provinceModel?.pickingUpStations!,
          );
        },
      );
      if (locationModel != null && locationModel?.province != null) {
        emit(
          state.copyWith(
            locationModel: locationModel,
          ),
        );
      } else {
        log('loi ko seach duoc dia diem');
      }
    });
  }
}
