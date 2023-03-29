import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../../data/models/models.dart';
import '../../../../utils/export/ui_export.dart';
import 'components.dart';

class ItemRead extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  ItemRead({
    Key? key,
    required this.data,
    required this.onDelete,
    required this.index,
  }) : super(key: key);
  final NotificationModel data;
  final Function(int index) onDelete;
  final int index;

  static shimmer() {
    return const ItemReadShimmer();
  }

  @override
  State<ItemRead> createState() => _ItemReadState();
}

class _ItemReadState extends State<ItemRead> {
  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(motion: const ScrollMotion(), children: [
        SlidableAction(
          backgroundColor: AppColors.utilRed,
          icon: Icons.delete,
          label: 'Xóa',
          onPressed: (BuildContext context) {
            widget.onDelete(widget.index);
          },
        )
      ]),
      child: Container(
        height: MediaQuery.of(context).size.width * 0.28,
        padding: const EdgeInsets.only(top: 16, left: 16, right: 24),
        decoration: BoxDecoration(
          color: widget.data.read!
              ? AppColors.white
              : AppColors.primaryMain + AppColors.primaryLightBlur,
        ),
        child: widget.data.type! == NotificationType.transactionNotification
            ? TransactionItem(widget.data as NotificationTransModel)
            : widget.data.type! == NotificationType.promotionNotification
                ? PromotionItem(widget.data as NotificationPromotionModel)
                : CompoundingItem(widget.data as NotificationCompoundingModel),
      ),
    );
  }
}

class ItemReadShimmer extends StatelessWidget {
  const ItemReadShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.width * 0.25,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: AppColors.primaryMain + AppColors.primaryLightBlur),
        child: ListTile(
          leading: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 50,
              height: 50,
              color: Colors.grey,
            ),
          ),
          title: Container(
            margin: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                ShimmerUtils.buildShimmerWithText(AppStyles.s14w4,
                    text: "thong bao giao dich"),
                const SizedBox(
                  width: 50,
                  height: 20,
                )
              ],
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerUtils.buildShimmerWithText(AppStyles.s12w4,
                  text: "thong bao giao dich ma khuyen mai"),
              const SizedBox(
                height: 4,
              ),
              ShimmerUtils.buildShimmerWithText(AppStyles.s12w4,
                  text: "thong bao giao dich khuey fsfav dadaaaa "),
            ],
          ),
        ));
  }
}
