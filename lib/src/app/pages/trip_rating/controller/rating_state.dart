part of 'rating_cubit.dart';

class RatingState extends Equatable {
  final List<RatingHashtagModel>? hasTags;
  final RatingResModel? ratingRes;

  const RatingState({
    this.hasTags,
    this.ratingRes,
  });

  @override
  List<Object?> get props => [
        hasTags,
        ratingRes,
      ];

  RatingState copyWith({
    List<RatingHashtagModel>? hasTags,
    RatingResModel? ratingRes,
  }) {
    return RatingState(
      hasTags: hasTags ?? this.hasTags,
      ratingRes: ratingRes ?? this.ratingRes,
    );
  }
}
