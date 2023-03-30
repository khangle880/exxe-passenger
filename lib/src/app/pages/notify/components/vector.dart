import '../../../../data/data.dart';
import '../../../../utils/export/ui_export.dart';

class VectorAppbar extends PopupMenuButton<MenuChooseItem> {
  VectorAppbar({
    Key? key,
    required String icon,
    required BuildContext context,
    void Function(MenuChooseItem)? onSelected,
    required INotificationRepo repo,
    required Function() callBack,
    required Function() callBackReadAllNotification,
  }) : super(
          key: key,
          onSelected: (item) async {
            if (item == MenuChooseItems.itemReaded) {
              callBackReadAllNotification();
            }
            if (item == MenuChooseItems.itemTrash) {
              callBack();
              Future.delayed(const Duration(milliseconds: 1000), () {
                Toast.show('Đã xóa hết thông báo', context, 3);
              });
            }
          },
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          icon: SvgPicture.asset(
            icon,
          ),
          itemBuilder: (context) => [
            ...MenuChooseItems.itemsRead.map(buildItem).toList(),
            const PopupMenuDivider(),
            ...MenuChooseItems.itemsTrash.map(buildItem).toList(),
            const PopupMenuDivider(),
            ...MenuChooseItems.itemsRemove.map(buildItem).toList(),
          ],
        );
}

PopupMenuItem<MenuChooseItem> buildItem(MenuChooseItem item) => PopupMenuItem(
    value: item,
    child: Row(
      children: [
        item.icon,
        const SizedBox(width: 10),
        Text(
          item.text,
          style: AppStyles.s16w6.withColor(AppColors.black),
        ),
      ],
    ));

class MenuChooseItem {
  final String text;
  final SvgPicture icon;

  MenuChooseItem({required this.icon, required this.text});
}

class MenuChooseItems {
  static List<MenuChooseItem> itemsTrash = [itemTrash];
  static List<MenuChooseItem> itemsRead = [itemReaded];
  static List<MenuChooseItem> itemsRemove = [itemRemove];
  static final itemReaded = MenuChooseItem(
      icon: SvgPicture.asset(AppIcons.tickDouble), text: 'Đánh dấu đã đọc');
  static final itemTrash = MenuChooseItem(
      icon: SvgPicture.asset(AppIcons.trash), text: 'Xóa tất cả');
  static final itemRemove =
      MenuChooseItem(icon: SvgPicture.asset(AppIcons.remove), text: 'Hủy');
}
