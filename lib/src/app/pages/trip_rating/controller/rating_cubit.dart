import 'package:equatable/equatable.dart';

import '../../../../utils/export/logic_export.dart';

part 'rating_state.dart';

class RatingCubit extends BaseCubit<RatingState> {
  final IRatingRepo ratingRepo = GetIt.I();

  RatingCubit() : super(const RatingState());

  void getQuickRatingTag(int start) async {
    final result = await ratingRepo.getQuickRatingTag(start);
    result.fold(
      (failure) {
        emitError(failure);
      },
      (data) {
        emit(state.copyWith(hasTags: data));
      },
    );
  }

  void createRating(
    int compoundingCarCustomerId,
    int rating,
    List<int> ratingTagIds, {
    String ratingContent = '',
  }) async {
    emitWaiting(true);
    final result = await ratingRepo.createRatingRequest(
      compoundingCarCustomerId,
      rating,
      ratingTagIds,
      ratingContent: ratingContent,
    );
    emitWaiting(false);
    result.fold(
      (failure) {
        emitError(failure);
        log(failure.toString());
      },
      (data) {
        emit(state.copyWith(ratingRes: data));
      },
    );
  }
}
