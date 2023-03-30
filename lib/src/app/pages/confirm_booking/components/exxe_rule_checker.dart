import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../utils/export/ui_export.dart';
import '../../../common/widgets/custom_checkbox.dart';
import '../controllers/confirm_booking_cubit.dart';

class ExxeRuleChecker extends StatelessWidget {
  const ExxeRuleChecker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ConfirmBookingCubit>();
    return BlocBuilder<ConfirmBookingCubit, ConfirmBookingState>(
      builder: (context, state) {
        return Row(
          children: [
            CustomCheckBox(
              value: state.isExxeRuleChecked,
              onChanged: (newValue) {
                bloc.updateField(isExxeRuleChecked: !state.isExxeRuleChecked);
              },
              size: 28,
              padding: const EdgeInsets.all(8),
            ),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: AppStyles.s14w4.withColor(AppColors.gray70x3b),
                  children: <TextSpan>[
                    const TextSpan(text: 'Tôi đã đồng ý với Exxe về '),
                    TextSpan(
                      text: 'Điều khoản dịch vụ',
                      style: AppStyles.s14w4.withColor(AppColors.primaryMain),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          launchUrl(
                              Uri.parse("https://exxe.vn/terms-&-conditions"));
                        },
                    ),
                    const TextSpan(text: ' & '),
                    TextSpan(
                      text: 'Chính sách bảo mật.',
                      style: AppStyles.s14w4.withColor(AppColors.primaryMain),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          launchUrl(
                              Uri.parse("https://exxe.vn/private-policy"));
                        },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ).inkWell(
          onTap: () {
            bloc.updateField(isExxeRuleChecked: !state.isExxeRuleChecked);
          },
        );
      },
    );
  }
}
