import 'package:exxe/src/app/pages/cancel_reason/controllers/cancel_reason_cubit.dart';

import '../../../../data/models/models.dart';
import '../../../../utils/export/ui_export.dart';

class CancelReasonBottomButton extends StatelessWidget {
  const CancelReasonBottomButton(this.compoundingCarCustomerModel, {Key? key})
      : super(key: key);
  final CompoundingCarCustomerModel compoundingCarCustomerModel;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CancelReasonCubit>();
    return BlocBuilder<CancelReasonCubit, CancelReasonState>(
      builder: (context, state) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: ButtonWidget(
            onClick: (state.selectedItem != null &&
                        state.selectedItem?.reason != "Khác") ||
                    (state.selectedItem?.reason == "Khác" &&
                        (state.otherReason ?? "").isNotEmpty)
                ? () async {
                    _showConfirmCancel(bloc, state, context);
                  }
                : null,
            child: Text(
              "Hủy chuyến",
              style: AppStyles.s16w6.withColor(AppColors.primaryLight),
            ),
          ),
        );
      },
    );
  }

  void _showConfirmCancel(CancelReasonCubit bloc, CancelReasonState state,
      BuildContext context) async {
    final returnStatus = await bloc.getReturnedDepositState(
        compoundingCarCustomerModel.compoundingCarCustomerId!);
    if (returnStatus != null) {
      AppDialog.I.showCancelDeposit(
        countdownNumber: ((returnStatus.remainsSecond ?? 0) * 1000).ceil(),

        /// 5s space for countdown button
        // canReturned: ((returnStatus.remainsSecond ?? 0) < 5
        //     ? false
        //     : (returnStatus.returnedDeposit ?? false)),
        canReturned: returnStatus.returnedDeposit ?? false,
        onDepositReturnedEnd: () {
          AppDialog.I.closeDialog();
          _showConfirmCancel(bloc, state, context);
        },
        onConfirm: () async {
          AppDialog.I.closeDialog();

          // cancel
          AppDialog.I.showLoading();
          final result = await bloc.repo.cancelCompoundingCar(
            compoundingCarCustomerModel,
            reasonId: state.selectedItem?.cancelReasonId,
            reasonOther: state.otherReason,
          );
          AppDialog.I.closeDialog();
          result.fold((failure) {
            failure.showDefaultDialog();
          }, (data) {
            AppDialog.I.showCancelReasonSuccess(
              onConfirm: () {
                AppDialog.I.closeDialog();
                Navigator.pop(context, true);
              },
              barrierDismissible: false,
            );
          });
        },
      );
    }
  }
}
