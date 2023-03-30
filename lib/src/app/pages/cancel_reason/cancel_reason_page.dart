import 'package:exxe/src/utils/export/ui_export.dart';

import '../../../core/base_state.dart';
import '../../../data/data.dart';
import 'components/cancel_reason_bottom_button.dart';
import 'components/cancel_reasons.dart';
import 'controllers/cancel_reason_cubit.dart';

class CancelReasonPage extends StatefulWidget {
  const CancelReasonPage({
    Key? key,
    required this.compoundingCarCustomerModel,
  }) : super(key: key);

  final CompoundingCarCustomerModel compoundingCarCustomerModel;

  @override
  State<CancelReasonPage> createState() => _CancelReasonPageState();
}

class _CancelReasonPageState
    extends BaseState<CancelReasonPage, CancelReasonCubit> {
  late final CancelReasonCubit cubit;

  @override
  CancelReasonCubit get bloc => cubit;

  @override
  initData() {
    cubit = context.read<CancelReasonCubit>();
    return super.initData();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.gray05,
        appBar: CustomAppBarWidget(
          backgroundColor: AppColors.greyLight,
          title: "Lý do huỷ chuyến",
          context: context,
        ),
        bottomNavigationBar: Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.fromLTRB(24, 12, 24, 20),
          child: CancelReasonBottomButton(widget.compoundingCarCustomerModel),
        ),
        body: BlocSelector<CancelReasonCubit, CancelReasonState,
            List<CancelReasonModel>?>(
          selector: (state) => state.listReason,
          builder: (context, reasons) {
            if (reasons == null) {
              return Center(
                child: const SizedBox().appCenterProgressLoading,
              );
            }
            if (reasons.isEmpty) {
              return Container(
                width: double.maxFinite,
                alignment: Alignment.center,
                child: Text("Không có lý do hủy chuyến nhanh phù hợp",
                    style: AppStyles.s16w6),
              );
            }
            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        "Vui lòng cho EXXE biết lý do huỷ chuyến của bạn",
                        style: AppStyles.s14w6.withColor(AppColors.gray70x3b),
                      ),
                    ),
                    const AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: CancelReasons(),
                    ),
                    const SizedBox(height: 8),
                    BlocBuilder<CancelReasonCubit, CancelReasonState>(
                      builder: (context, state) {
                        return TextField(
                          readOnly: state.selectedItem?.reason != "Khác",
                          maxLines: 3,
                          onChanged: (value) {
                            bloc.onOtherReasonChange(value);
                          },
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: AppColors.gray60x9d +
                                AppColors.primaryLight.withOpacity(.9),
                            contentPadding: const EdgeInsets.all(12.0),
                            hintText: "Mô tả",
                            hintStyle:
                                AppStyles.s14w4.withColor(AppColors.gray50),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
