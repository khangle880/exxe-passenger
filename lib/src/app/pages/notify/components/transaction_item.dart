import '../../../../data/models/models.dart';
import '../../../../utils/export/ui_export.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem(this.data, {Key? key}) : super(key: key);
  final NotificationTransModel data;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
          alignment: Alignment.center,
          child: Image.asset(
            AppIcons.logoBig,
            width: 50,
            height: 50,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thông báo giao dịch',
              style: AppStyles.s16w6.withColor(data.read == false
                  ? AppColors.primaryMain
                  : AppColors.gray95x06),
            ),
            const SizedBox(
              height: 4,
            ),
            SizedBox(
              height: 60,
              width: MediaQuery.of(context).size.width * 2 / 3,
              child: Text(
                data.ref ?? '',
                style: AppStyles.s14w6.withColor(
                  data.read == false ? AppColors.gray95 : AppColors.gray60x52,
                ),
                maxLines: 3,
              ),
            ),
          ],
        )
      ],
    );
  }
}
