// import 'dart:async';
//
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:agora_uikit/agora_uikit.dart';
//
// class AgoraPage extends StatefulWidget {
//   const AgoraPage({Key? key, required this.channelToken}) : super(key: key);
//   final String channelToken;
//
//   @override
//   State<AgoraPage> createState() => _AgoraPageState();
// }
//
// class _AgoraPageState extends State<AgoraPage> {
//   int? _remoteUid;
//   bool _localUserJoined = false;
//   late final AgoraClient client;
//   final agoraAppId = dotenv.maybeGet('AGORAAPPID', fallback: null) ?? "";
//   late RtcEngine _engine;
//
//   @override
//   void initState() {
//     super.initState();
//
//     initAgora();
//     super.initState();
//   }
//
//   // void initAgora() async {
//   //   client = AgoraClient(
//   //     agoraConnectionData: AgoraConnectionData(
//   //       appId: agoraAppId,
//   //       channelName: 'test',
//   //       tempToken: widget.channelToken,
//   //       rtmEnabled: false,
//   //     ),
//   //     agoraChannelData: AgoraChannelData(
//   //       channelProfileType: ChannelProfileType.channelProfileCommunication1v1,
//   //       clientRoleType: ClientRoleType.clientRoleAudience,
//   //     ),
//   //
//   //     enabledPermission: [Permission.microphone],
//   //   );
//   //   await client.initialize();
//   // }
//
//
//   @override
//   void dispose() async {
//     _engine.leaveChannel();
//     _engine.release();
//     // client.engine.leaveChannel();
//     // client.engine.release();
//     super.dispose();
//   }
//
//   Future<void> initAgora() async {
//     // retrieve permissions
//     await [Permission.microphone].request();
//
//     //create the engine
//     _engine = createAgoraRtcEngine();
//     await _engine.initialize(
//       RtcEngineContext(
//         appId: agoraAppId,
//         channelProfile: ChannelProfileType.channelProfileCommunication1v1,
//       ),
//     );
//
//     _engine.registerEventHandler(
//       RtcEngineEventHandler(
//           onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
//             debugPrint("local user ${connection.localUid} joined");
//             setState(() {
//               _localUserJoined = true;
//             });
//           }, onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
//         debugPrint("remote user $remoteUid joined");
//         setState(() {
//           _remoteUid = remoteUid;
//         });
//       }, onUserOffline: (RtcConnection connection, int remoteUid,
//           UserOfflineReasonType reason) {
//         debugPrint("remote user $remoteUid left channel");
//         setState(() {
//           _remoteUid = null;
//         });
//       }, onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
//         debugPrint(
//             '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
//       }, onLeaveChannel: (RtcConnection connection, RtcStats stats) {
//         _engine.release();
//       }),
//     );
//
//     await _engine.setClientRole(role: ClientRoleType.clientRoleAudience);
//     await _engine.enableVideo();
//     await _engine.startPreview();
//
//     await _engine.joinChannel(
//       token: widget.channelToken,
//       channelId: 'test',
//       uid: 0,
//       options: const ChannelMediaOptions(),
//     );
//   }
//
//   // Create UI with local view and remote view
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Center(
//             child: _remoteVideo(),
//           ),
//           Align(
//             alignment: Alignment.topLeft,
//             child: SizedBox(
//               width: 100,
//               height: 150,
//               child: Center(
//                 child: _localUserJoined
//                     ? AgoraVideoView(
//                   controller: VideoViewController(
//                     rtcEngine: _engine,
//                     canvas: const VideoCanvas(uid: 0),
//                   ),
//                 )
//                     : const CircularProgressIndicator(),
//               ),
//             ),
//           ),
//         ],
//       ),
//       // body: SafeArea(
//       //   child: Stack(
//       //     children: [
//       //       AgoraVideoViewer(
//       //         client: client,
//       //         layoutType: Layout.floating,
//       //       ),
//       //       AgoraVideoButtons(
//       //         client: client,
//       //       ),
//       //     ],
//       //   ),
//       // ),
//     );
//   }
//
//   // Display remote user's video
//   Widget _remoteVideo() {
//     if (_remoteUid != null) {
//       return AgoraVideoView(
//         controller: VideoViewController.remote(
//           rtcEngine: _engine,
//           canvas: VideoCanvas(uid: _remoteUid),
//           connection: const RtcConnection(channelId: "test"),
//         ),
//       );
//     } else {
//       return const Text(
//         'Please wait for remote user to join',
//         textAlign: TextAlign.center,
//       );
//     }
//   }
// }
