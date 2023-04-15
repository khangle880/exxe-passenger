import 'package:equatable/equatable.dart';
import '../../../../core/core.dart';
import '../../../../data_chat/data_chat.dart';
import '../../../../storage/models/user_chat.dart';
import '../../../../utils/export/logic_export.dart';

part 'auth_login_event.dart';

part 'auth_login_state.dart';

class AuthLoginBloc extends BaseBloc<AuthLoginEvent, AuthLoginState> {
  final UserRepo userRepo;
  final UserInfoRepo userInfoRepo;

  AuthLoginBloc(this.userRepo, this.userInfoRepo)
      : super(const AuthLoginState()) {
    on<UpdateStatusEvent>(
      (event, emit) => emit(state.copyWith(formState: event.status)),
    );

    on<ChangedPhoneLoginEvent>(
      (event, emit) => emit(
        state.copyWith(phone: event.phone, methodLogin: event.method),
      ),
    );

    on<ChangedPasswordLoginEvent>(
        (event, emit) => emit(state.copyWith(password: event.password)));

    on<ResetPhoneEvent>((event, emit) => emit(state.copyWith(phone: '')));

    on<ResetPasswordEvent>((event, emit) async {
      emit(state.copyWith(formState: FormLoginStatus.submitting));
      final token = event.token;
      if (token.carAccountType != null &&
          token.carAccountType != CarAccountType.customer) {
        emit(state.copyWith(formState: FormLoginStatus.notCompatible));
      } else {
        GetIt.I.get<AppState>().logIn(token);
      }
      final either = await GetIt.I<IUserInfoRepo>().getUserInfo();
      either.fold((failure) {
        log(failure.toString());
        emit(state.copyWith(formState: FormLoginStatus.failed));
        emitError(failure);
      }, (data) async {
        GetIt.I.get<AppState>().updateUser(data);
        add(LoginEvent());
      });
    });

    on<ResetAllEvent>((event, emit) => emit(state.copyWith(
        password: '', phone: '', formState: FormLoginStatus.none)));

    on<SubmitFormPhonePasswordEvent>(
        (event, emit) => _handleAuthPasswordSubmit(event, emit));

    on<SubmitFormOTPEvent>((event, emit) => _handleAuthOtpSubmit(event, emit));

    on<CheckHasPassEvent>((event, emit) async {
      emit(state.copyWith(formState: FormLoginStatus.submitting));
      if (await _checkHasPassword()) {
        add(LoginEvent());
      } else {
        emit(state.copyWith(formState: FormLoginStatus.needPassword));
      }
    });
    on<LoginEvent>((event, emit) async {
      emit(state.copyWith(formState: FormLoginStatus.submitting));
      final playerId = await OneSignalNotificationHelper.I.id;

      if (playerId != null) {
        GetIt.I<IPushNotificationRepo>().loginDeviceForPartner(playerId);
      }

      final generalInfoEither = await userRepo.getGeneralUserInfo();
      generalInfoEither.fold((failure) {
        log(failure.toString());
        emitError(failure);
      }, (data) {
        if (data.userInformation ?? false) {
          if (data.identityCard!) {
            emit(state.copyWith(formState: FormLoginStatus.success));
          } else {
            emit(state.copyWith(formState: FormLoginStatus.needVerify));
          }
        } else {
          emit(state.copyWith(formState: FormLoginStatus.needRegister));
        }
      });
    });
  }

  Future<bool> _checkHasPassword() async {
    final result = await UserRepo().checkHasPassword();
    return result.fold((failure) {
      log(failure.toString());
      return Future.error(failure);
    }, (hasPass) {
      return hasPass;
    });
  }

  _handleAuthOtpSubmit(
      SubmitFormOTPEvent event, Emitter<AuthLoginState> emit) async {
    emit(state.copyWith(formState: FormLoginStatus.submitting));
    final result =
        await userRepo.authWithPhoneOtp(stringeeAccessToken: event.accessToken);
    result.fold((failure) {
      emit(state.copyWith(
        formState: FormLoginStatus.failed,
        message: (failure is ServerFailure)
            ? failure.serverMessage
            : "Đã có lỗi, vui lòng thử lại sau",
      ));
    }, (user) async {
      final token = TokenModel(
        token: user.token,
        refreshToken: user.refreshToken,
        carAccountType: user.carAccountType,
      );
      if (token.carAccountType != null &&
          token.carAccountType != CarAccountType.customer) {
        emit(state.copyWith(formState: FormLoginStatus.notCompatible));
      } else {
        await _handleLoginRegisterChat(user);
        await GetIt.I.get<AppState>().updateUser(user);
        GetIt.I.get<AppState>().logIn(token, user: user);
        // To load device_id, tracCarId
        userInfoRepo.getUserInfo();
        add(CheckHasPassEvent());
      }
    });
  }

  //handle auth login passs
  _handleAuthPasswordSubmit(
      SubmitFormPhonePasswordEvent event, Emitter<AuthLoginState> emit) async {
    emit(state.copyWith(formState: FormLoginStatus.submitting));
    final result =
        await userRepo.login(phone: state.phone, password: state.password);

    TokenModel? token;
    result.fold((failure) {
      emit(state.copyWith(
        formState: FormLoginStatus.failed,
        message: (failure is ServerFailure)
            ? failure.serverMessage
            : "Đã có lỗi, vui lòng thử lại sau",
      ));
    }, (tokenModel) {
      if (tokenModel.carAccountType != null &&
          tokenModel.carAccountType != CarAccountType.customer) {
        emit(state.copyWith(formState: FormLoginStatus.notCompatible));
      } else {
        token = tokenModel;
        GetIt.I.get<AppState>().logIn(tokenModel);
      }
    });
    if (token != null) {
      final either = await userInfoRepo.getUserInfo();
      either.fold((failure) {
        emitError(failure);
        log(failure.toString());
      }, (user) async {
        await _handleLoginRegisterChat(user);
        await GetIt.I.get<AppState>().updateUser(user);
        add(LoginEvent());
      });
    }
  }

  _registerChat(PartnerModel user) {
    return ChatUserRepo()
        .register(
      userId: user.partnerId!,
      phone: user.phone!,
      avatar: user.avatarUrl?.imageUrl ?? "",
      userName: user.partnerName ?? "",
    )
        .then((either) {
      either.fold((l) {
        log(l.toString());
      }, (chatUser) {
        // update chatSecretKey to Exxe
        final chatSecretKey = EncryptDataHelper.encryptAES(chatUser.userId);
        userInfoRepo.updateUserInformation(chatSecretKey: chatSecretKey);
        ChatUserRepo().generateToken(chatSecretKey, user.phone!);
        BoxesChatUser.instance.setUser(
          ChatUserHive(
            token: chatUser.accessToken!,
            refreshToken: chatUser.refreshToken!,
          ),
        );
        GetIt.I<AppState>().updateChatUser();
      });
    });
  }

  /// login/register chat
  Future _handleLoginRegisterChat(PartnerModel user) async {
    if (user.chatSecretKey != null) {
      final result =
          await ChatUserRepo().generateToken(user.chatSecretKey!, user.phone!);
      await result.fold((l) {
        if (l.toString() == "User not found, please register first") {
          return _registerChat(user);
        }
      }, (data) {});
    } else {
      _registerChat(user);
    }
  }
}
