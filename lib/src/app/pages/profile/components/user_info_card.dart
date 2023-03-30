import '../../../../data/data.dart';
import 'dart:convert';
import '../../../../utils/export/ui_export.dart';
import '../../../common/widgets/username_widget.dart';

class UserInfoCard extends StatefulWidget {
  const UserInfoCard({Key? key}) : super(key: key);

  @override
  State<UserInfoCard> createState() => _UserInfoCardState();
}

class _UserInfoCardState extends State<UserInfoCard> {
  late RemoveListener removeListener;

  @override
  void initState() {
    super.initState();
    removeListener = GetIt.I.get<AppState>().addListener((state) {
      if (state.isNewAction &&
          (state.action == ActionStateEnum.updateUserInfo)) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    removeListener();
  }

  Uint8List? image;

  @override
  Widget build(BuildContext context) {
    final PartnerModel userInfo = GetIt.I<AppState>().currentState.user!;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAvatar(userInfo),
            const SizedBox(width: 12.0),
            Expanded(child: _buildInfoUser(userInfo)),
          ],
        ),
        const SizedBox(height: 16),
        _buildAccountState(userInfo.identityCardId?.state),
      ],
    );
  }

  Column _buildInfoUser(PartnerModel userInfo) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Khách hàng", style: AppStyles.s10w4.withColor(AppColors.gray50)),
        const UserNameWidget(),
        const SizedBox(height: 4),
        Text(
          userInfo.email!,
          style: AppStyles.s14w4.withColor(AppColors.gray60x9d),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          userInfo.phone!.convertPhone(),
          style: AppStyles.s14w4.withColor(AppColors.gray60x9d),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Future _uploadImage(Uint8List bytes) async {
    final AttachmentParam attachmentParam =
        AttachmentParam(base64: base64.encode(bytes), type: MediaType.image);
    final result = await GetIt.I<IUserInfoRepo>()
        .createAvatarAttachment([attachmentParam]);

    image = null;
    return result.fold((failure) {
      log(failure.toString());
    }, (data) async {
      await GetIt.I<IUserInfoRepo>()
          .updateUserInformation(avatarAttachment: data.first)
          .then((value) {
        return value.fold((failure) {
          log(failure.toString());
        }, (user) {
          GetIt.I<AppState>().updateUser(user);
        });
      });
      setState(() {});
      return data.first;
    });
  }

  Widget _buildAvatar(PartnerModel userInfo) {
    return GestureDetector(
      onTap: () {
        PickupImageSheet.showBottomSheet(
          context,
          title: "Chụp ảnh đại diện",
          hasOverlay: false,
          onPicked: (Uint8List bytes) async {
            image = bytes;
            setState(() {});
            if (mounted) {
              Navigator.pop(context);
            }
            await _uploadImage(bytes);
          },
        );
      },
      child: image != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Image.memory(
                image!,
                fit: BoxFit.cover,
                height: 90,
                width: 90,
              ),
            )
          : CachedNetworkImage(
              height: 90,
              width: 90,
              imageUrl: Apis.baseUrl + (userInfo.avatarUrl?.imageUrl ?? ""),
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  color: AppColors.gray10,
                  borderRadius: BorderRadius.circular(16),
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover),
                ),
              ),
              placeholder: (context, url) =>
                  const SizedBox().appCenterProgressLoading,
              errorWidget: (context, url, error) =>
                  SvgPicture.asset(AppIcons.warning),
            ),
    );
  }

  _buildAccountState(VerifyState? state) {
    late final String content;
    late final Color textColor;
    late final Color backgroundColor;
    late final Widget icon;
    if (state != null) {
      content = "Tài khoản của bạn đã được xác minh!";
      textColor = const Color(0xFF118A33);
      backgroundColor = const Color(0xFFF3F9F5);
      icon = SvgPicture.asset(AppIcons.doubleCheck, width: 20, height: 20);
    } else {
      content = "Bổ sung thêm thông tin cá nhân!";
      textColor = AppColors.accOrange;
      backgroundColor = const Color(0xFFFEFAF4);
      icon = SvgPicture.asset(AppIcons.warning,
          width: 20, height: 20, color: AppColors.accOrange);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: backgroundColor),
      child: Row(
        children: [
          icon,
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              content,
              style: AppStyles.s12w4.withColor(textColor),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (state == null) ...[
            const SizedBox(width: 4),
            Text(
              "Chỉnh sửa",
              style: AppStyles.s12w4.withColor(AppColors.primaryLight),
            ).inkWell(
              onTap: () {
                Navigator.pushNamed(context, Routes.formRegister, arguments: {
                  'title': "Thông tin cá nhân",
                  'description':
                      "Tạo tài khoản EXXE để nhận tất cả các tính năng",
                });
              },
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: textColor),
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
            )
          ]
        ],
      ),
    );
  }
}
