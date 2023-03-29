import '../../../../utils/export/ui_export.dart';
import '../../../common/widgets/custom_checkbox.dart';
import '../controllers/cancel_reason_cubit.dart';

class CancelReasons extends StatelessWidget {
  const CancelReasons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CancelReasonCubit>();
    return BlocBuilder<CancelReasonCubit, CancelReasonState>(
        builder: (context, state) {
      if (state.listReason == null) {
        return const SizedBox();
      }
      if (state.listReason!.isEmpty) {
        return const Text('Không có lí do huỷ chuyến nhanh phù hợp');
      }
      return ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: state.listReason!
            .map((e) => Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: GestureDetector(
                  onTap: () {
                    bloc.selectItem(!(state.selectedItem == e), e);
                  },
                  behavior: HitTestBehavior.translucent,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomCheckBox(
                          value: state.selectedItem?.reason == e.reason,
                          onChanged: (value) => bloc.selectItem(value, e),
                          size: 24,
                          padding: const EdgeInsets.all(4),
                        ),
                      ),
                      Expanded(child: Text(e.reason!, style: AppStyles.s14w6)),
                    ],
                  ),
                )))
            .toList(),
      );
    });
  }
}
