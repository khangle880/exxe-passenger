import '../../../../utils/export/ui_export.dart';

class NotificationTabs extends StatefulWidget {
  const NotificationTabs({
    Key? key,
    required this.groupTypes,
    required this.initialIndex,
    required this.onTap,
  }) : super(key: key);
  final Map<NotificationTypeGroup, List<NotificationType>> groupTypes;
  final int initialIndex;
  final Function(int index) onTap;

  @override
  State<NotificationTabs> createState() => _NotificationTabsState();
}

class _NotificationTabsState extends State<NotificationTabs> {
  late int index;

  @override
  void initState() {
    super.initState();
    index = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: widget.groupTypes.keys
          .toList()
          .asMap()
          .map(
            (i, key) => MapEntry(
                i,
                GestureDetector(
                  onTap: () {
                    widget.onTap(i);
                    index = i;
                    setState(() {});
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 1,
                          spreadRadius: 1,
                          color: AppColors.gray10,
                        )
                      ],
                      color: key == widget.groupTypes.keys.toList()[index]
                          ? AppColors.primaryMain
                          : AppColors.primaryMain + AppColors.primaryLightBlur,
                    ),
                    margin: const EdgeInsets.only(right: 12),
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: Text(
                      key.name,
                      style: AppStyles.s14w4.withColor(
                          key == widget.groupTypes.keys.toList()[index]
                              ? AppColors.primaryLight
                              : AppColors.primaryMain),
                    ),
                  ),
                )),
          )
          .values
          .toList(),
    );
  }
}
