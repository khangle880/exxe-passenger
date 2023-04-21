import 'package:equatable/equatable.dart';
import '../../../../utils/export/logic_export.dart';
import '../../chat_fb/chat_fb_core/chat_fb_repo.dart';

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
      emitWaiting(true);
      final token = event.token;
      if (token.carAccountType != null &&
          token.carAccountType != CarAccountType.customer) {
        emit(state.copyWith(formState: FormLoginStatus.notCompatible));
      } else {
        GetIt.I.get<AppState>().logIn(token);
      }
      final either = await GetIt.I<IUserInfoRepo>().getUserInfo();
      either.fold((failure) {
        emitWaiting(false);
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
      emitWaiting(true);
      final hasPass = await _checkHasPassword();
      if (hasPass == null) {
        emitWaiting(false);
        return;
      }
      if (hasPass) {
        add(LoginEvent());
      } else {
        emitWaiting(false);
        emit(state.copyWith(formState: FormLoginStatus.needPassword));
      }
    });
    on<LoginEvent>((event, emit) async {
      final playerId = await OneSignalNotificationHelper.I.id;

      if (playerId != null) {
        GetIt.I<IPushNotificationRepo>().loginDeviceForPartner(playerId);
      }

      final generalInfoEither = await userRepo.getGeneralUserInfo();
      emitWaiting(false);
      generalInfoEither.fold((failure) {
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

  Future<bool?> _checkHasPassword() async {
    final result = await UserRepo().checkHasPassword();
    return result.fold((failure) {
      emitError(failure);
      return null;
    }, (hasPass) {
      return hasPass;
    });
  }

  _handleAuthOtpSubmit(
      SubmitFormOTPEvent event, Emitter<AuthLoginState> emit) async {
    emitWaiting(true);
    final result =
        await userRepo.authWithPhoneOtp(stringeeAccessToken: event.accessToken);

    result.fold((failure) {
      emitWaiting(false);
      emitError(failure);
    }, (user) async {
      final token = TokenModel(
        token: user.token,
        refreshToken: user.refreshToken,
        carAccountType: user.carAccountType,
      );
      if (token.carAccountType != null &&
          token.carAccountType != CarAccountType.customer) {
        emitWaiting(false);
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
    emitWaiting(true);
    final result =
        await userRepo.login(phone: state.phone, password: state.password);

    TokenModel? token;
    result.fold((failure) {
      emitWaiting(false);
      emitError(failure);
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
        emitWaiting(false);
        emitError(failure);
      }, (user) async {
        await _handleLoginRegisterChat(user);
        await GetIt.I.get<AppState>().updateUser(user);
        add(LoginEvent());
      });
    }
  }

  _registerChat(PartnerModel user) {
    return GetIt.I<ChatFbRepo>().register(
      partnerId: user.partnerId!,
      phone: user.phone!,
      avatar: user.avatarUrl?.imageUrl == null
          ? ""
          : (Apis.baseUrl + user.avatarUrl!.imageUrl!),
      userName: user.partnerName ?? "",
    );
  }

  /// login/register chat
  Future _handleLoginRegisterChat(PartnerModel user) async {
    final result = await GetIt.I<ChatFbRepo>()
        .login(user.partnerId.toString(), user.phone!);
    if (!result) {
      _registerChat(user);
    }
  }
}
