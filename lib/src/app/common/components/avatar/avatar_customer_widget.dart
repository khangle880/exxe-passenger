// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:exxe/src/utils/export/ui_export.dart';

class AvatarCustomerWidget extends StatelessWidget {
  const AvatarCustomerWidget({
    Key? key,
    this.avatar,
  }) : super(key: key);
  final String? avatar;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      backgroundImage: avatar != null
          ? CachedNetworkImageProvider(
              Apis.baseUrl + avatar!,
            )
          : const CachedNetworkImageProvider(
              "https://vnn-imgs-a1.vgcloud.vn/image1.ictnews.vn/_Files/2020/03/17/trend-avatar-1.jpg",
            ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: 3.0,
            bottom: 3.0,
            child: Container(
              width: 5,
              height: 5,
              decoration: const ShapeDecoration(
                shape: CircleBorder(),
                color: AppColors.success,
              ),
            ),
          )
        ],
      ),
    );
  }
}
