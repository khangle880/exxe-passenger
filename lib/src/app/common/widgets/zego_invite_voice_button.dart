import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../../../data/data.dart';
import '../../../utils/export/ui_export.dart';

class InviteVoiceButton extends StatefulWidget {
  const InviteVoiceButton(
      {Key? key,
      required this.phone,
      required this.name,
      required this.compoundingCarCustomerCode})
      : super(key: key);
  final String phone;
  final String name;
  final String compoundingCarCustomerCode;

  @override
  State<InviteVoiceButton> createState() => _InviteVoiceButtonState();
}

class _InviteVoiceButtonState extends State<InviteVoiceButton> {
  SharedPreferences? preferences;
  late RemoveListener removeListener;

  @override
  void dispose() {
    removeListener();
    super.dispose();
  }

  @override
  void initState() {
    initPref();
    removeListener = GetIt.I.get<AppState>().addListener((state) {
      if (state.action == ActionStateEnum.missingCall && state.isNewAction) {
        setState(() {});
      }
    });
    super.initState();
  }

  initPref() async {
    preferences = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if (preferences == null) return const SizedBox();
        if (getNumberMissingCall(
                widget.phone, widget.compoundingCarCustomerCode) <
            3) {
          return ZegoCallInviteButton(
            phone: widget.phone,
            name: widget.name,
            compoundingCarCustomerCode: widget.compoundingCarCustomerCode,
          );
        } else {
          return SvgPicture.asset(AppIcons.calling,
                  width: 28, height: 28, color: AppColors.primaryMain)
              .inkWell(
            padding: const EdgeInsets.all(8),
            onTap: () {
              AppDialog.I.showCustomDialog(
                content: CallDialog(
                  phone: widget.phone,
                  name: widget.name,
                  compoundingCarCustomerCode: widget.compoundingCarCustomerCode,
                ),
              );
            },
          );
        }
      },
    );
  }

  getNumberMissingCall(String phone, String code) {
    final key = "$phone:$code";
    if (preferences == null) return 0;
    final value = preferences!.getString(key);

    if (value != null) {
      final count = int.parse(value.split('/')[1]);
      return count;
    } else {
      return 0;
    }
  }
}

class ZegoCallInviteButton extends StatelessWidget {
  const ZegoCallInviteButton(
      {Key? key,
      required this.phone,
      required this.name,
      required this.compoundingCarCustomerCode,
      this.icon,
      this.bgColor,
      this.height,
      this.width})
      : super(key: key);
  final String phone;
  final String name;
  final String compoundingCarCustomerCode;
  final Widget? icon;
  final Color? bgColor;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return ZegoSendCallInvitationButton(
      isVideoCall: false,
      invitees: [
        ZegoUIKitUser(
          id: phone,
          name: name,
        )
      ],
      notificationMessage: "Có cuộc gọi đến",
      resourceID: "zegouikit_call",
      iconSize: Size(width ?? 30, height ?? 30),
      buttonSize: Size(width ?? 44, height ?? 44),
      icon: ButtonIcon(
        icon: icon ??
            SvgPicture.asset(AppIcons.calling,
                width: 26, height: 26, color: AppColors.primaryMain),
        backgroundColor: bgColor ?? Colors.transparent,
      ),
      onPressed: onSendCallInvitationFinished,
    );
  }

  void onSendCallInvitationFinished(
      String code, String message, List<String> errorInvitees) {
    GetIt.I<INotificationRepo>().call(phone);
    GetIt.I<AppState>().callingCompoundingCustomerCode =
        compoundingCarCustomerCode;

    if (errorInvitees.isNotEmpty) {
      var message = 'Người dùng đang không hoạt động';
      if (code.isNotEmpty) {
        log(', code: $code, message:$message');
      }
      SmartDialog.showToast(
        message,
      );
    } else if (code.isNotEmpty) {
      log(', code: $code, message:$message');
    }
  }
}

class CallDialog extends StatelessWidget {
  const CallDialog({
    Key? key,
    required this.phone,
    required this.name,
    required this.compoundingCarCustomerCode,
  }) : super(key: key);
  final String phone;
  final String name;
  final String compoundingCarCustomerCode;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Liên hệ với khách hàng", style: AppStyles.s16w7),
              const SizedBox(height: 4),
              Text("Hãy thử liên hệ với số điện thoại", style: AppStyles.s15w5),
              Row(
                children: [
                  Text(phone, style: AppStyles.s15w6),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: SvgPicture.asset(AppIcons.calling,
                        width: 26, height: 26, color: AppColors.green60),
                  ),
                ],
              ).inkWell(
                radius: 4,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                onTap: () {
                  launchUrl(
                    Uri.parse('tel:$phone'),
                  );
                },
              ),
              const Divider(
                height: 3,
                thickness: 1,
              ),
              ZegoCallInviteButton(
                phone: phone,
                name: name,
                compoundingCarCustomerCode: compoundingCarCustomerCode,
                height: 44,
                width: double.maxFinite,
                icon: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  child: Row(
                    children: [
                      Text(name, style: AppStyles.s15w6),
                      const Spacer(),
                      SvgPicture.asset(AppIcons.calling,
                          width: 28, height: 28, color: AppColors.primaryMain),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
