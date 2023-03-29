import '../../../../utils/export/ui_export.dart';

class PickupChip<T> extends StatelessWidget {
  const PickupChip(
      {Key? key,
      required this.list,
      required this.onSelected,
      this.selectedItem,
      this.itemWidth,
      required this.getName})
      : super(key: key);
  final List<T> list;
  final Function(T value) onSelected;
  final T? selectedItem;
  final Function(T value) getName;
  final double? itemWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) =>
            _buildItem(list[index]),
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(width: 12),
        itemCount: list.length,
      ),
    );
  }

  Widget _buildItem(item) {
    final isSelected = item == selectedItem;
    return GestureDetector(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: isSelected ? AppColors.primaryMain : AppColors.gray50,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        blurRadius: 3,
                        spreadRadius: 1,
                        color: const Color(0xFF2B15B1).withOpacity(.1),
                      )
                    ]
                  : null,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            getName(item),
            style: AppStyles.s14w4.withColor(
                isSelected ? AppColors.primaryMain : AppColors.gray70x76),
          ),
        ],
      ).inkWell(
        width: itemWidth,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryMain + AppColors.primaryLight.withOpacity(.95)
              : AppColors.greyLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: isSelected ? AppColors.primaryMain : Colors.transparent),
        ),
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
          onSelected(item);
        },
      ),
    );
  }
}
