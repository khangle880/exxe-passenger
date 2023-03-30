part of 'cancel_reason_cubit.dart';

class CancelReasonState extends Equatable {
  final CancelReasonModel? selectedItem;
  final String? otherReason;
  final List<CancelReasonModel>? listReason;

  const CancelReasonState({
    this.selectedItem,
    this.otherReason,
    this.listReason,
  });

  CancelReasonState copyWith({
    Nullable<CancelReasonModel>? selectedItem,
    String? otherReason,
    List<CancelReasonModel>? listReason,
  }) {
    return CancelReasonState(
      selectedItem:
          selectedItem == null ? this.selectedItem : selectedItem.value,
      listReason: listReason ?? this.listReason,
      otherReason: otherReason ?? this.otherReason,
    );
  }

  @override
  List<Object?> get props => [selectedItem, listReason, otherReason];
}
