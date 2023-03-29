import '../../../../utils/export/ui_export.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class ActivityTopNav extends StatefulWidget {
  const ActivityTopNav(
      {Key? key,
      required this.groups,
      required this.currentIndex,
      required this.onTap})
      : super(key: key);
  final List<CompoundingCarStateGroup> groups;
  final int currentIndex;
  final Function(int index) onTap;

  @override
  State<ActivityTopNav> createState() => _ActivityTopNavState();
}

class _ActivityTopNavState extends State<ActivityTopNav> {
  final AutoScrollController controller = AutoScrollController();

  @override
  void didUpdateWidget(covariant ActivityTopNav oldWidget) {
    super.didUpdateWidget(oldWidget);
    controller.scrollToIndex(
      widget.currentIndex,
      preferPosition: AutoScrollPosition.middle,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      scrollDirection: Axis.horizontal,
      itemCount: widget.groups.length,
      itemBuilder: (BuildContext context, int index) {
        final key = widget.groups[index];
        return AutoScrollTag(
          key: ValueKey(index),
          controller: controller,
          index: index,
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
              color: key == widget.groups.toList()[widget.currentIndex]
                  ? AppColors.primaryMain
                  : AppColors.primaryLight,
            ),
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Text(
              key.name,
              style: AppStyles.s14w4.withColor(
                  key == widget.groups.toList()[widget.currentIndex]
                      ? AppColors.primaryLight
                      : AppColors.primaryMain),
            ),
          ).inkWell(
            onTap: () {
              widget.onTap(index);
            },
          ),
        );
      },
    );
  }
}
