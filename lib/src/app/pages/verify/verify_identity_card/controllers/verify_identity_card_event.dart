part of 'verify_identity_card_bloc.dart';

abstract class VerifyIdentityCardEvent extends Equatable {
  const VerifyIdentityCardEvent();

  @override
  List<Object> get props => [];
}

class LoadInitialCardEvent extends VerifyIdentityCardEvent {}

class CreateVerifyEvent extends VerifyIdentityCardEvent {}

class ChangeFrontImageEvent extends VerifyIdentityCardEvent {
  final ImageModel image;

  const ChangeFrontImageEvent(this.image);

  @override
  List<Object> get props => [image];
}

class ChangeBackImageEvent extends VerifyIdentityCardEvent {
  final ImageModel image;

  const ChangeBackImageEvent(this.image);

  @override
  List<Object> get props => [image];
}

class ChangeCarNumberEvent extends VerifyIdentityCardEvent {
  final String cardNumber;

  const ChangeCarNumberEvent(this.cardNumber);

  @override
  List<Object> get props => [cardNumber];
}

class ChangeIssuedDateEvent extends VerifyIdentityCardEvent {
  final DateTime issuedDate;

  const ChangeIssuedDateEvent(this.issuedDate);

  @override
  List<Object> get props => [issuedDate];
}

class ChangeExpiredDateEvent extends VerifyIdentityCardEvent {
  final DateTime expiredDate;

  const ChangeExpiredDateEvent(this.expiredDate);

  @override
  List<Object> get props => [expiredDate];
}

class ChangeIdentityFullNameEvent extends VerifyIdentityCardEvent {
  final String fullName;

  const ChangeIdentityFullNameEvent(this.fullName);

  @override
  List<Object> get props => [fullName];
}

class ChangePlaceOfIssuedEvent extends VerifyIdentityCardEvent {
  final String address;

  const ChangePlaceOfIssuedEvent(this.address);

  @override
  List<Object> get props => [address];
}

class ChangeMyAddressEvent extends VerifyIdentityCardEvent {
  final String address;

  const ChangeMyAddressEvent(this.address);

  @override
  List<Object> get props => [address];
}
