import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../utils/export/logic_export.dart';

part 'mywallet_event.dart';

part 'mywallet_state.dart';

class MyWalletBloc extends BaseBloc<MyWalletEvent, MyWalletState> {
  final IWalletRepo walletRepo;

  MyWalletBloc(this.walletRepo) : super(const MyWalletState()) {
    on<UpdateWalletEvent>((event, emit) async {
      emit(state.copyWith(wallet: event.wallet));
    });

    on<LoadWalletEvent>((event, emit) async {
      final myWalletResponse = await walletRepo.getWalletJournal();
      myWalletResponse.fold((failure) {
        emitError(failure);
        log(failure.toString());
      }, (data) {
        log(data.toString());
        GetIt.I.get<AppState>().updateWallet(data);
        emit(state.copyWith(wallet: data));
      });
    });
    on<UpdateFilter>((event, emit) async {
      emit(
        state.copyWith(
          filterRange: Nullable(event.range),
          filterPaymentGroup: Nullable(event.paymentPurposeGroup),
        ),
      );
    });
  }
}
