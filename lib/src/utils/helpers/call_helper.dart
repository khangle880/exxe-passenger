import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';

class CallHelper {
  static String id = '999';

  static void createIncomingCall({
    required String name,
    required String avatar,
    required String phone,
  }) async {
    CallKitParams callKitParams = CallKitParams(
      id: id,
      nameCaller: name,
      appName: 'Exxe',
      avatar: avatar,
      type: 0,
      textAccept: 'Accept',
      textDecline: 'Decline',
      textMissedCall: 'Missed call',
      duration: 30000,
      headers: <String, dynamic>{
        'platform': 'flutter',
        'phone': phone,
      },
      textCallback: 'Call back',
      android: const AndroidParams(
          isCustomNotification: true,
          isShowLogo: false,
          isShowCallback: false,
          isShowMissedCallNotification: true,
          ringtonePath: 'system_ringtone_default',
          backgroundColor: '#0955fa',
          backgroundUrl: 'https://i.pravatar.cc/500',
          actionColor: '#4CAF50',
          incomingCallNotificationChannelName: "Incoming Call",
          missedCallNotificationChannelName: "Missed Call"),
      ios: IOSParams(
        iconName: 'CallKitLogo',
        handleType: 'generic',
        supportsVideo: true,
        maximumCallGroups: 2,
        maximumCallsPerCallGroup: 1,
        audioSessionMode: 'default',
        audioSessionActive: true,
        audioSessionPreferredSampleRate: 44100.0,
        audioSessionPreferredIOBufferDuration: 0.005,
        supportsDTMF: true,
        supportsHolding: true,
        supportsGrouping: false,
        supportsUngrouping: false,
        ringtonePath: 'system_ringtone_default',
      ),
    );
    await FlutterCallkitIncoming.showCallkitIncoming(callKitParams);
  }

  static endCall() async {
    await FlutterCallkitIncoming.endCall(id);
  }

  static callMissed({
    required String name,
    required String avatar,
  }) async {
    CallKitParams params = CallKitParams(
      id: id,
      nameCaller: name,
      avatar: avatar,
      type: 1,
      textMissedCall: 'Missed call',
    );
    await FlutterCallkitIncoming.showMissCallNotification(params);
  }

  static startCall() async {
    CallKitParams params = CallKitParams(
      id: id,
      type: 1,
    );
    await FlutterCallkitIncoming.startCall(params);
  }

  static getCurrentCall() async {
    //check current call from pushkit if possible
    var calls = await FlutterCallkitIncoming.activeCalls();
    if (calls is List) {
      if (calls.isNotEmpty) {
        return calls[0];
      } else {
        return null;
      }
    }
  }
}
