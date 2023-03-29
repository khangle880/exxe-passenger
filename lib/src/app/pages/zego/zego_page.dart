import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import '../../../data/data.dart';
import '../../../utils/export/ui_export.dart';

class CallInvitationPage extends StatelessWidget {
  const CallInvitationPage({Key? key, required this.child}) : super(key: key);
  final Widget child;

  cacheNumberMissingCall(String phone, String code) async {
    final key = "$phone:$code";
    final now = DateTime.now();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final value = preferences.getString(key);
    String newValue;

    if (value != null) {
      final time = DateTime.parse(value.split('/')[0]);
      final count = int.parse(value.split('/')[1]);
      if (now.difference(time) < const Duration(hours: 3)) {
        newValue = "$now/${count + 1}";
      } else {
        newValue = "$now/1";
      }
    } else {
      newValue = "$now/1";
    }

    preferences.setString(key, newValue);
    GetIt.I<AppState>().createAction(ActionStateEnum.missingCall);
  }

  @override
  Widget build(BuildContext context) {
    final appId =
        int.tryParse(dotenv.maybeGet('ZEGOAPPID', fallback: null) ?? "") ?? 0;
    final appSign = dotenv.maybeGet('ZEGOAPPSIGN', fallback: null) ?? "";
    final user = GetIt.I<AppState>().currentState.user;

    return ZegoUIKitPrebuiltCallWithInvitation(
      appID: appId,
      appSign: appSign,
      userID: user!.phone.toString(),
      userName: user.partnerName!,
      notifyWhenAppRunningInBackgroundOrQuit: true,
      plugins: [ZegoUIKitSignalingPlugin()],
      events: ZegoUIKitPrebuiltCallInvitationEvents(
        onOutgoingCallTimeout: (callId, callee) {
          log("onOutgoingCallTimeout");
          final code = GetIt.I<AppState>().callingCompoundingCustomerCode;
          if (callee.isNotEmpty && code != null) {
            cacheNumberMissingCall(callee.first.id, code);
            GetIt.I<INotificationRepo>().missedCall(callee.first.id);
          }
        },
        onOutgoingCallRejectedCauseBusy: (callId, callee) {
          log("onOutgoingCallRejectedCauseBusy");
          final code = GetIt.I<AppState>().callingCompoundingCustomerCode;
          if (code != null) {
            cacheNumberMissingCall(callee.id, code);
          }
        },
        onOutgoingCallDeclined: (callId, called) {
          log("onOutgoingCallDeclined");
        },
      ),
      requireConfig: (data) => ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall()
        ..layout = ZegoLayout.pictureInPicture(
          isSmallViewDraggable: true,
          switchLargeOrSmallViewByClick: true,
        )
        ..useSpeakerWhenJoining = false,

      // ..audioVideoViewConfig =
      //     ZegoPrebuiltAudioVideoViewConfig(showSoundWavesInAudioMode: true),
      ringtoneConfig: const ZegoRingtoneConfig(
        incomingCallPath: "assets/ringtone/incomingCallRingtone.mp3",
        outgoingCallPath: "assets/ringtone/outgoingCallRingtone.mp3",
      ),

      child: child,
    );
  }
}
