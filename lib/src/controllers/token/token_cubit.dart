// ignore_for_file: prefer_is_empty, depend_on_referenced_packages

import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:exxe/src/data_chat/data_chat.dart';
import 'package:get_it/get_it.dart';

import '../../app/app_state.dart';
import '../../data/data.dart';
import '../../storage/models/transaction.dart';
import '../../storage/models/user.dart';
import '../../utils/helpers/onesignal_notification_helper.dart';

part 'token_state.dart';

class TokenCubit extends Cubit<TokenState> {
  final UserInfoRepo userRepo = GetIt.I();
  TokenCubit() : super(TokenInitial());

  Future<bool> _checkHasPassword() async {
    final result = await UserRepo().checkHasPassword();
    return result.fold((failure) {
      log(failure.toString());
      emit(TokenInvalid());
      return Future.error(failure);
    }, (hasPass) {
      return hasPass;
    });
  }

  checkToken() async {
    if (!await _checkHasPassword()) {
      emit(TokenNeedPassword());
      return;
    }
    final token = await BoxesUser.instance.getUserData();
    if (token == null) {
      emit(TokenInvalid());
    } else {
      log(token.token.toString());

      // get general info
      final generalInfoEither = await userRepo.getGeneralUserInfo();
      GeneralUserInfoModel? generalUserInfo;
      generalInfoEither.fold((failure) {
        log(failure.toString());
        emit(TokenInvalid());
      }, (data) {
        generalUserInfo = data;
      });

      // get userInfo
      final result = await userRepo.getUserInfo();
      result.fold((failure) {
        log(failure.toString());
        emit(TokenInvalid());
      }, (data) async {
        GetIt.I.get<AppState>().logIn(token, user: data);
        await GetIt.I.get<AppState>().updateUser(data);
        log(data.partnerName.toString());

        // check password
        if (generalUserInfo?.userInformation ?? false) {
          // handle hive transaction
          var transactions =
              await TransactionHiveBox.instance.readTransaction();
          if (transactions.isNotEmpty) {
            for (var element in transactions) {
              confirmPayment(element);
            }
          }
          emit(TokenHas());
        } else {
          emit(TokenNeedRegister());
        }
      });
    }
  }

  void confirmPayment(TransactionHiveModel model) async {
    if (model.compoundingCarCustomerId!.isNotEmpty) {
      await GetIt.I<CompoundingCarControllerRepo>()
          .getTransactionState(
        int.parse(model.compoundingCarCustomerId!),
        model.vnPayCode,
      )
          .then(
        (value) {
          value.fold(
            (failure) => log(failure.toString()),
            (data) async {
              if (data.bankTransactionCode != null) {
                log('failed transaction ${model.paymentId} car ${model.compoundingCarCustomerId}');
                TransactionHiveBox.instance.deleteTransaction(data.vnpayCode!);
                if (data.bankTransactionCode == "00") {
                  await GetIt.I<CompoundingCarControllerRepo>()
                      .confirmCompoundingPayment(
                          int.parse(model.compoundingCarCustomerId!));
                }
              }
            },
          );
        },
      );
    } else {
      await GetIt.I<IWalletRepo>()
          .getTransactionState(
        model.vnPayCode,
      )
          .then(
        (value) {
          value.fold(
            (failure) => log(failure.toString()),
            (data) async {
              if (data.bankTransactionCode != null) {
                TransactionHiveBox.instance.deleteTransaction(data.vnpayCode!);
                log('failed transaction ${model.paymentId} car ${model.compoundingCarCustomerId}');
                if (data.bankTransactionCode == "00") {
                  await GetIt.I<IWalletRepo>().confirmWalletRechargeRequest(
                      int.parse(model.paymentId!));
                }
              }
            },
          );
        },
      );
    }
  }

  void logOut() async {
    final playerId = await OneSignalNotificationHelper.I.id;
    if (playerId != null) {
      GetIt.I<IPushNotificationRepo>().logoutDeviceForPartner(playerId);
    }
    GetIt.I<IChatUserRepo>().logout();
    await BoxesUser.instance.deleteDataUser();
    await TransactionHiveBox.instance.clearAllTransaction();
    GetIt.I.get<AppState>().logOut();
  }
}
