part of 'promotion_cubit.dart';

class PromotionState extends Equatable {
  final List<PromotionModel>? promotions;
  final CompoundingCarCustomerModel? carCustomer;

  const PromotionState({
    this.promotions,
    this.carCustomer,
  });

  @override
  List<Object?> get props => [
        promotions,
        carCustomer,
      ];

  PromotionState copyWith({
    List<PromotionModel>? promotions,
    CompoundingCarCustomerModel? carCustomer,
  }) {
    return PromotionState(
      promotions: promotions ?? this.promotions,
      carCustomer: carCustomer ?? this.carCustomer,
    );
  }
}
