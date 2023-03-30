import 'dart:async';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/export/ui_export.dart';

class SupportButton extends StatefulWidget {
  const SupportButton({Key? key}) : super(key: key);

  @override
  State<SupportButton> createState() => _SupportButtonState();
}

class _SupportButtonState extends State<SupportButton> {
  bool isBlurred = true;
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  Timer? timer;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      backgroundColor: Colors.transparent,
      overlayColor: Colors.transparent,
      overlayOpacity: 0.2,
      onOpen: () {
        timer = Timer(const Duration(seconds: 10), () {
          isDialOpen.value = false;
        });
      },
      onClose: () {
        timer?.cancel();
      },
      openCloseDial: isDialOpen,
      closeManually: false,
      dialRoot: (ctx, open, toggleChildren) {
        return AnimatedOpacity(
          duration: Duration(milliseconds: !open ? 1000 : 100),
          opacity: !open ? 0.65 : 1,
          child: Image.asset(
            AppIcons.supportBot,
            width: 35,
            height: 35,
            color: AppColors.primaryLight,
          ).inkWell(
            padding: const EdgeInsets.all(6),
            onTap: toggleChildren,
            radius: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(60),
              color: AppColors.primaryMain,
            ),
          ),
        );
      },
      spacing: 10,
      children: [
        SpeedDialChild(
          backgroundColor: AppColors.primaryMain,
          // labelBackgroundColor: AppColors.black,
          labelStyle: AppStyles.s14w5.withColor(AppColors.black),
          child: SvgPicture.asset(
            AppIcons.calling,
            height: 24,
            width: 24,
            color: AppColors.primaryLight,
          ),
          label: 'Gọi hỗ trợ',
          onTap: () {
            launchUrl(
              Uri.parse('tel:0915691231'),
            );
          },
        ),
        SpeedDialChild(
          backgroundColor: AppColors.green60,
          // labelBackgroundColor: AppColors.black,
          labelStyle: AppStyles.s14w5.withColor(AppColors.black),
          child: SvgPicture.asset(
            AppIcons.message,
            height: 24,
            width: 24,
            color: AppColors.primaryLight,
          ),
          label: 'Nhắn tin hỗ trợ',
          onTap: () {
            ChatSocketHelper.I.openAdminRoomChat(context);
          },
        ),
      ],
    );
  }
}
