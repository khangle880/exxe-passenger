part of 'verify_identity_card_bloc.dart';

class VerifyIdentityCardState extends Equatable {
  final ImageModel? frontImage;
  final ImageModel? backImage;
  final String? name;
  final String? cardNumber;
  final DateTime? issuedDate;
  final DateTime? expiredDate;
  final String? placeOfIssued;
  final String? address;
  final IdentityCardModel? identityCard;
  final CallDataApiType type;

  const VerifyIdentityCardState({
    this.frontImage,
    this.backImage,
    this.name,
    this.cardNumber,
    this.issuedDate,
    this.expiredDate,
    this.placeOfIssued,
    this.address,
    this.identityCard,
    this.type = CallDataApiType.create,
  });

  @override
  List<Object?> get props => [
        frontImage,
        backImage,
        name,
        cardNumber,
        issuedDate,
        expiredDate,
        placeOfIssued,
        address,
        identityCard,
        type,
      ];

  VerifyIdentityCardState copyWith({
    ImageModel? frontImage,
    ImageModel? backImage,
    String? name,
    String? cardNumber,
    DateTime? issuedDate,
    DateTime? expiredDate,
    String? placeOfIssued,
    String? address,
    IdentityCardModel? identityCard,
    CallDataApiType? type,
  }) {
    return VerifyIdentityCardState(
      frontImage: frontImage ?? this.frontImage,
      backImage: backImage ?? this.backImage,
      name: name ?? this.name,
      cardNumber: cardNumber ?? this.cardNumber,
      issuedDate: issuedDate ?? this.issuedDate,
      expiredDate: expiredDate ?? this.expiredDate,
      placeOfIssued: placeOfIssued ?? this.placeOfIssued,
      address: address ?? this.address,
      identityCard: identityCard ?? this.identityCard,
      type: type ?? this.type,
    );
  }
}
