import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:state_notifier/state_notifier.dart';

import '../data/data.dart';
import '../storage/models/user.dart';
export 'package:state_notifier/state_notifier.dart' show RemoveListener;

enum UserStateEnum { signIn, notSignIn }

enum ActionStateEnum {
  none,
  updateUserInfo,
  updateChatUserInfo,
  recharge,
  withdraw,
  updateWallet,
  authStateChanged,
  invalidToken,
  createRide,
  updateRide,
  confirmRide,
  pickupRide,
  confirmDepositRide,
  cancelRide,
  deleteDraft,
  loadedCurrentLocation,
  updateNotificationCount,
  updateMessageCount,
  readNoti,
  deleteNoti,
  readAllNoti,
  deleteAllNoti,
  forceRefreshNoti,
  syncTrip,
  missingCall,
}

class AppState extends StateNotifier<UserState> {
  AppState() : super(UserState(state: UserStateEnum.notSignIn));

  String? callingCompoundingCustomerCode;
  String? currentChatRoomId;

  UserState get currentState => state;

  List<CarModel> cars = [];
  List<CarBrandModel> carBrands = [];
  ComputePriceModel computePriceModel = ComputePriceModel(
    maxDistanceTravelingInDay: 350,
    numberKmPerDay: 550,
    serviceFeePercent: 0.05,
    personIncomeTax: 0.1,
  );

  void createAction(ActionStateEnum action, {Object? object}) {
    if (action == ActionStateEnum.recharge ||
        action == ActionStateEnum.withdraw) {
      WalletRepo().getWalletJournal().then((either) {
        either.fold((failure) {
          log(failure.toString());
        }, (data) {
          log(data.toString());
          updateWallet(data);
        });
      });
    }
    state = state.copyWith(action: action, payload: object);
  }

  void logOut() {
    state = state.copyWith(
      state: UserStateEnum.notSignIn,
      action: ActionStateEnum.authStateChanged,
      isLogout: true,
      user: null,
    );
    _onLoggedOut();
  }

  void logIn(TokenModel token, {PartnerModel? user}) {
    state = state.copyWith(
      state: UserStateEnum.signIn,
      action: ActionStateEnum.authStateChanged,
      user: user,
    );
    _onLoggedIn(token, user);
  }

  void _onLoggedIn(TokenModel token, PartnerModel? user) {
    BoxesUser.instance.setUser(UserHive(
      token: token.token!,
      refreshToken: token.refreshToken!,
    ));

    log(token.token!);
  }

  updateUser(PartnerModel user) {
    if (state.state == UserStateEnum.signIn) {
      state =
          state.copyWith(user: user, action: ActionStateEnum.updateUserInfo);
    }
  }

  void updateCurrentLocation(LocationModel newLocation) {
    state = state.copyWith(
      currentLocation: newLocation,
      action: ActionStateEnum.loadedCurrentLocation,
      payload: newLocation.coordinate,
    );
  }

  void updateWallet(WalletModel wallet) {
    state = state.copyWith(wallet: wallet);
    createAction(
      ActionStateEnum.updateWallet,
      object: wallet,
    );
  }

  void updateNotificationCount(int count) {
    state = state.copyWith(notificationCount: count);
    createAction(ActionStateEnum.updateNotificationCount, object: count);
  }

  void updateMessageCount(int count) {
    state = state.copyWith(messageCount: count);
    createAction(ActionStateEnum.updateMessageCount, object: count);
  }

  void _onLoggedOut() {}

  void resetPasswordDone() {}
}

// GetIt.I.get<AppState>().userStateStream.listen((state) {
//   if (state.action == ActionStateEnum.authStateChanged) {
//     checkUserData(state);
//   }
// });
// GetIt.I.get<AppState>()
//     .createAction(ActionStateEnum, object: value);

class UserState extends Equatable {
  // final Location? location;
  // final int? unReadCount;
  // final num? noPaymentUsedPoint;
  final PartnerModel? user;
  final UserStateEnum state;
  late final int timeStamp;
  final ActionStateEnum action;
  final Object? payload;
  final LocationModel? currentLocation;
  final WalletModel? wallet;
  final int notificationCount;
  final int messageCount;
  final User? chatUser;

  bool get isNewAction =>
      DateTime.now().millisecondsSinceEpoch - timeStamp < 1000;

  bool isLoggedUser(int? id) {
    return id != null && user != null && user!.partnerId == id;
  }

  UserState(
      {required this.state,
      this.user,
      this.chatUser,
      this.wallet,
      this.payload,
      this.action = ActionStateEnum.none,
      this.notificationCount = 0,
      this.messageCount = 0,
      this.currentLocation}) {
    timeStamp = DateTime.now().millisecondsSinceEpoch;
  }

  @override
  List<Object?> get props => [state];

  UserState copyWith({
    PartnerModel? user,
    UserStateEnum? state,
    ActionStateEnum? action,
    Object? payload,
    bool isLogout = false,
    LocationModel? currentLocation,
    WalletModel? wallet,
    int? notificationCount,
    int? messageCount,
    User? chatUser,
  }) {
    return UserState(
      user: isLogout ? user : user ?? this.user,
      chatUser: isLogout ? chatUser : chatUser ?? this.chatUser,
      state: state ?? this.state,
      action: action ?? this.action,
      payload: payload,
      currentLocation: currentLocation ?? this.currentLocation,
      wallet: wallet ?? this.wallet,
      notificationCount: notificationCount ?? this.notificationCount,
      messageCount: messageCount ?? this.messageCount,
    );
  }
}
