import 'package:equatable/equatable.dart';
import 'package:exxe/src/utils/export/logic_export.dart';

part 'form_register_event.dart';

part 'form_register_state.dart';

class FormRegisterBloc extends BaseBloc<FormRegisterEvent, FormRegisterState> {
  final IUserInfoRepo repo;
  final PartnerModel userInfo = GetIt.I<AppState>().currentState.user!;

  FormRegisterBloc(this.repo) : super(const FormRegisterState()) {
    on<LoadGeneralInfoEvent>((event, emit) async {
      emit(state.copyWith(type: CallDataApiType.get));
      final either = await repo.getGeneralUserInfo();
      either.fold((failure) {
        log(failure.toString());
        emit(state.copyWith(type: CallDataApiType.create));
      }, (data) {
        emit(state.copyWith(
          name: userInfo.partnerName,
          gender: userInfo.gender,
          birthDate: userInfo.dateOfBirth,
          phoneConfirmed: data.verifiedNumberPhone,
          identityNumber: userInfo.identityCardId?.identityNumber,
          email: userInfo.email,
        ));
        if (userInfo.street != null &&
            userInfo.provinceId != null &&
            userInfo.districtId != null &&
            userInfo.wardId != null) {
          emit(state.copyWith(
            location: LocationModel(
              address: userInfo.street,
              province: userInfo.provinceId,
              district: userInfo.districtId,
              ward: userInfo.wardId,
              coordinate: const CoordinateModel(),
            ),
          ));
        }
        emit(state.copyWith(
            type: data.userInformation ?? false
                ? CallDataApiType.update
                : CallDataApiType.create));
      });
    });
    on<ChangeFullNameEvent>((event, emit) {
      emit(state.copyWith(name: event.name));
    });
    on<ChangeGenderEvent>((event, emit) {
      emit(state.copyWith(gender: event.gender));
    });
    on<ChangeBirthDateEvent>((event, emit) {
      emit(state.copyWith(birthDate: event.birthDate));
    });
    on<ChangeEmailEvent>((event, emit) {
      emit(state.copyWith(email: event.email));
    });
    on<ChangeAddress>((event, emit) {
      emit(state.copyWith(location: event.location));
    });
    on<VerifyPhoneNumberEvent>((event, emit) async {
      emit(state.copyWith(phoneConfirmed: event.success));
    });
    on<ChangeIdentityEvent>((event, emit) async {
      emit(state.copyWith(identityNumber: event.identityNumber));
    });
    on<CreateUserInformationEvent>((event, emit) async {
      if (state.type == CallDataApiType.update) {
        if (isUserInfoEqualWithFormRegisterData(state)) {
          log('no update');
          emit(state.copyWith(userInfo: userInfo));
        } else {
          emitWaiting(true);
          final result = await repo.updateUserInformation(
            name: state.name,
            birthDate: state.birthDate,
            gender: state.gender,
            email: state.email,
            provinceId: state.location?.province?.provinceId,
            districtId: state.location?.district?.districtId,
            wardId: state.location?.ward?.wardId,
            street: state.location?.address,
          );
          emitWaiting(false);
          result.fold((failure) {
            log(failure.toString());
          }, (data) {
            GetIt.I.get<AppState>().updateUser(data);
            emit(state.copyWith(userInfo: data));
          });
        }
      } else {
        emitWaiting(true);
        final result = await repo.createUserInformation(
          name: state.name!,
          birthDate: state.birthDate!,
          gender: state.gender!,
          email: state.email!,
          provinceId: state.location?.province?.provinceId,
          districtId: state.location?.district?.districtId,
          wardId: state.location?.ward?.wardId,
          street: state.location?.address,
        );
        emitWaiting(false);
        result.fold((failure) {
          log(failure.toString());
        }, (data) {
          GetIt.I.get<AppState>().updateUser(data);
          emit(state.copyWith(userInfo: data));
        });
      }
    });
  }

  bool isUserInfoEqualWithFormRegisterData(FormRegisterState state) {
    if (userInfo.partnerName == state.name! &&
        userInfo.dateOfBirth == state.birthDate! &&
        userInfo.gender == state.gender &&
        userInfo.email == state.email &&
        userInfo.provinceId!.provinceId! ==
            state.location!.province!.provinceId! &&
        userInfo.districtId!.districtId! ==
            state.location!.district!.districtId! &&
        userInfo.wardId!.wardId! == state.location!.ward!.wardId! &&
        userInfo.street == state.location!.address) {
      return true;
    }
    return false;
  }
}
