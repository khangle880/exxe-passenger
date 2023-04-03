import 'package:equatable/equatable.dart';

import '../../../../../utils/export/logic_export.dart';

part 'verify_identity_card_event.dart';

part 'verify_identity_card_state.dart';

class VerifyIdentityCardBloc
    extends BaseBloc<VerifyIdentityCardEvent, VerifyIdentityCardState> {
  final IUserInfoRepo repo;
  IdentityCardModel? identityCard;
  final PartnerModel userInfo = GetIt.I<AppState>().currentState.user!;

  VerifyIdentityCardBloc(this.repo) : super(const VerifyIdentityCardState()) {
    on<LoadInitialCardEvent>((event, emit) async {
      emit(state.copyWith(
          type: CallDataApiType.get, name: userInfo.partnerName));
      final either = await repo.getIdentityCard();
      either.fold((failure) {
        log(failure.toString());
        emit(state.copyWith(type: CallDataApiType.create));
      }, (data) {
        identityCard = data;
        emit(state.copyWith(
          frontImage: data.frontIdentityCardImageUrl,
          backImage: data.backIdentityCardImageUrl,
          name: data.partner?.partnerName,
          cardNumber: data.identityNumber,
          issuedDate: data.dateOfIssue,
          expiredDate: data.dateOfExpiry,
          placeOfIssued: data.placeOfIssue,
          address: data.address,
          type: CallDataApiType.update,
        ));
      });
    });
    on<CreateVerifyEvent>((event, emit) async {
      if (state.type == CallDataApiType.update &&
          identityCard?.identityCardId != null) {
        if (isIdentityCardEqualWithStateData(state)) {
          log('no update');
          emit(state.copyWith(identityCard: identityCard));
        } else {
          emitWaiting(true);
          final result = await repo.updateIdentityCard(
            id: identityCard!.identityCardId!,
            frontImageId: state.frontImage?.id,
            backImageId: state.backImage?.id,
            name: state.name,
            identityNumber: state.cardNumber,
            issuedDate: state.issuedDate,
            expiredDate: state.expiredDate,
            placeOfIssue: state.placeOfIssued,
            address: state.address,
          );
          emitWaiting(false);
          result.fold((failure) {
            log(failure.toString());
          }, (data) {
            GetIt.I<AppState>()
                .updateUser(userInfo.copyWith(identityCardId: data));
            emit(state.copyWith(identityCard: data));
          });
        }
      } else {
        emitWaiting(true);
        final result = await repo.createIdentityCard(
          frontImageId: state.frontImage?.id,
          backImageId: state.backImage?.id,
          identityNumber: state.cardNumber!,
          issuedDate: state.issuedDate!,
          expiredDate: state.expiredDate,
          placeOfIssue: state.placeOfIssued!,
          address: state.address!,
          name: state.name!,
        );
        emitWaiting(false);
        result.fold((failure) {
          emitError(failure);
        }, (data) {
          GetIt.I<AppState>()
              .updateUser(userInfo.copyWith(identityCardId: data));
          emit(state.copyWith(identityCard: data));
        });
      }
    });
    on<ChangeFrontImageEvent>((event, emit) {
      emit(state.copyWith(frontImage: event.image));
    });
    on<ChangeBackImageEvent>((event, emit) {
      emit(state.copyWith(backImage: event.image));
    });
    on<ChangeCarNumberEvent>((event, emit) {
      emit(state.copyWith(cardNumber: event.cardNumber));
    });
    on<ChangeIssuedDateEvent>((event, emit) {
      emit(state.copyWith(issuedDate: event.issuedDate));
    });
    on<ChangeExpiredDateEvent>((event, emit) {
      emit(state.copyWith(expiredDate: event.expiredDate));
    });
    on<ChangeIdentityFullNameEvent>((event, emit) {
      emit(state.copyWith(name: event.fullName));
    });
    on<ChangePlaceOfIssuedEvent>((event, emit) {
      emit(state.copyWith(placeOfIssued: event.address));
    });
    on<ChangeMyAddressEvent>((event, emit) {
      emit(state.copyWith(address: event.address));
    });
  }

  bool isIdentityCardEqualWithStateData(VerifyIdentityCardState state) {
    if (identityCard?.frontIdentityCardImageUrl?.id == state.frontImage?.id &&
        identityCard?.backIdentityCardImageUrl?.id == state.backImage?.id &&
        identityCard?.partner?.partnerName == state.name &&
        identityCard?.identityNumber == state.cardNumber &&
        identityCard?.dateOfIssue == state.issuedDate &&
        identityCard?.dateOfExpiry == state.expiredDate &&
        identityCard?.placeOfIssue == state.placeOfIssued &&
        identityCard?.address == state.address) {
      return true;
    }
    return false;
  }
}
