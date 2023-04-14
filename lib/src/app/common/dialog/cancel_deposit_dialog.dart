import 'dart:async';

import 'package:exxe/src/utils/export/ui_export.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

class CancelDepositDialog extends StatefulWidget {
  const CancelDepositDialog({
    Key? key,
    required this.onCancel,
    required this.onConfirm,
    this.onDepositReturnedEnd,
    this.countdownNumber,
    required this.canReturned,
  }) : super(key: key);
  final Function() onCancel;
  final Function() onConfirm;
  final Function()? onDepositReturnedEnd;

  /// milliseconds
  final int? countdownNumber;
  final bool canReturned;

  @override
  State<CancelDepositDialog> createState() => _CancelDepositDialogState();
}

class _CancelDepositDialogState extends State<CancelDepositDialog> {
  Timer? timer;
  late bool canReturned;

  @override
  void initState() {
    canReturned = widget.canReturned;
    // 5s space for countdown button
    // if ((widget.countdownNumber ?? 0) > 5) {
    //   timer = Timer(Duration(milliseconds: widget.countdownNumber!), () {
    //     widget.onDepositReturnedEnd?.call();
    //   });
    // }
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
        width: 344,
        child: Material(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(AppIcons.alert),
              const SizedBox(height: 16),
              Text("Bạn muốn huỷ chuyến đi?", style: AppStyles.s18w7),
              const SizedBox(height: 4),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: AppStyles.s14w4.withColor(AppColors.gray90),
                  children: <TextSpan>[
                    TextSpan(
                        text: canReturned
                            ? "Số tiền bạn đã đặt cọc sẽ được chuyển vào tài khoản Exxe của bạn theo "
                            : 'Số tiền bạn đã đặt cọc sẽ mất theo '),
                    TextSpan(
                      text: 'Chính sách hoàn cọc',
                      style: AppStyles.s14w4.withColor(AppColors.primaryMain),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          launchUrl(
                              Uri.parse("https://exxe.vn/terms-&-conditions"));
                        },
                    ),
                    const TextSpan(text: ' của chúng tôi')
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ButtonWidgetOld(
                      onClick: widget.onCancel,
                      radius: 12,
                      backgroundColor: AppColors.primaryMain +
                          AppColors.primaryLight.withOpacity(0.95),
                      child: Text(
                        "Giữ lại",
                        style: AppStyles.s14w6.withColor(AppColors.primaryMain),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CountDownButton(
                      onClick: widget.onConfirm,
                      content: "Hủy chuyến",
                      backgroundColor: (isWaiting) {
                        return isWaiting
                            ? AppColors.primaryMain +
                                AppColors.primaryLight.withOpacity(0.6)
                            : AppColors.primaryMain;
                      },
                      textStyle: (isWaiting) {
                        return AppStyles.s14w6
                            .withColor(AppColors.primaryLight);
                      },
                      endTime: DateTime.now().millisecondsSinceEpoch + 5 * 1000,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
