import 'dart:async';

import 'package:pinput/pinput.dart';

import '../../../data/data.dart';
import '../../../utils/export/ui_export.dart';

class OTPPage extends StatefulWidget {
  const OTPPage(this.phoneNumber, {Key? key, this.sendPurpose})
      : super(key: key);
  final String phoneNumber;
  final String? sendPurpose;

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  final controller = TextEditingController();
  final IUserRepo repo = GetIt.I();
  late final StreamController<bool> waitingStreamController;
  bool isValidateFailed = false;

  @override
  void initState() {
    super.initState();
    waitingStreamController = StreamController();
    sendOtp();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  sendOtp() async {
    await repo
        .sendOtp(widget.phoneNumber.clearWhiteSpace,
            sendPurpose: widget.sendPurpose)
        .then((either) {
      either.fold((failure) {
        log(failure.toString());
        failure.showDefaultDialog();
      }, (data) {
        waitingStreamController.add(true);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryLight,
      appBar: CustomAppBarWidget(
        backgroundColor: AppColors.primaryLight,
        title: 'Nhập mã OTP',
        context: context,
        fontSizeTitle: 18,
        comeBack: () {
          Navigator.pop(context);
        },
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            isValidateFailed
                ? Text('Vui lòng nhập lại mã OTP',
                    style: AppStyles.s14w6.withColor(AppColors.utilRed))
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Chúng tôi đã gửi OTP đến',
                          style:
                              AppStyles.s14w4.withColor(AppColors.gray70x76)),
                      Text(
                          widget.phoneNumber.replaceAll(
                              RegExp(r'(?!^)(?=(?:\d{3})+(?:\.|$))'), ' '),
                          style:
                              AppStyles.s14w6.withColor(AppColors.primaryMain)),
                    ],
                  ),
            const SizedBox(height: 36),
            _buildPinPut(),
            const SizedBox(height: 36),
            Text(
              'Bạn đã nhận được OTP chưa?',
              style: AppStyles.s14w4.withColor(AppColors.gray70x76),
            ),
            const SizedBox(height: 4.0),
            _buildSendAgain(),
          ],
        ),
      ),
    );
  }

  verifyOtp() {
    repo
        .verifyOtp(widget.phoneNumber.clearWhiteSpace, controller.text)
        .then((either) {
      controller.clear();
      either.fold((failure) {
        log(failure.toString());
        failure.showDefaultDialog();
        isValidateFailed = true;
      }, (data) {
        log(data);
        Navigator.pop(context, data);
      });
    });
  }

  _buildPinPut() {
    final defaultPinTheme = PinTheme(
      width: 24,
      height: 48,
      textStyle: AppStyles.s24w6.withColor(AppColors.primaryMain),
      decoration: AppStyles.pinputUnderline,
    );
    return Pinput(
      length: 6,
      controller: controller,
      separator: Container(width: 16),
      defaultPinTheme: defaultPinTheme,
      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
      androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsUserConsentApi,
      showCursor: true,
      errorTextStyle: AppStyles.s12w4.withColor(AppColors.utilRed),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp("[0-9]")),
        FilteringTextInputFormatter.digitsOnly
      ],
      validator: (pin) {
        verifyOtp();
        return null;
      },
      focusedPinTheme: defaultPinTheme.copyWith(
        decoration: AppStyles.pinputUnderline,
      ),
    );
  }

  _buildSendAgain() {
    return StreamBuilder<bool>(
      stream: waitingStreamController.stream,
      builder: (context, snapshot) {
        if (snapshot.data ?? false) {
          return CountDownButton(
            type: CountDownButtonType.inkwell,
            onClick: () async {
              AppDialog.I.showLoading();
              await sendOtp();
              AppDialog.I.closeDialog();
            },
            content: "Gửi lại mã OTP",
            backgroundColor: (isWaiting) {
              return AppColors.primaryMain +
                  AppColors.primaryLight.withOpacity(0.95);
            },
            textStyle: (isWaiting) {
              if (isWaiting) {
                return AppStyles.s14w6.withColor(AppColors.primaryMain +
                    AppColors.primaryLight.withOpacity(0.6));
              }
              return AppStyles.s14w6.withColor(AppColors.primaryMain);
            },
            endTime: DateTime.now()
                .add(const Duration(minutes: 3))
                .millisecondsSinceEpoch,
            onEnd: () {
              waitingStreamController.add(false);
            },
          );
        }
        return InkWell(
          onTap: sendOtp,
          child: Text("Gửi lại mã OTP",
              style: AppStyles.s14w6.withColor(AppColors.primaryMain)),
        );
      },
    );
  }
}
