import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../utils/export/ui_export.dart';
import '../../../common/widgets/filter/select_date_range.dart';

class WalletDrawer extends StatefulWidget {
  const WalletDrawer(
      {Key? key,
      this.range,
      required this.onRangeChanged,
      this.paymentPurposeGroup})
      : super(key: key);

  final PickerDateRange? range;
  final List<PaymentPurposeGroup>? paymentPurposeGroup;
  final Function(PickerDateRange? range,
      List<PaymentPurposeGroup>? paymentPurposeGroup) onRangeChanged;

  @override
  State<WalletDrawer> createState() => _WalletDrawerState();
}

class _WalletDrawerState extends State<WalletDrawer> {
  PickerDateRange? selected;
  List<PaymentPurposeGroup>? paymentPurposeGroup;

  @override
  void initState() {
    super.initState();
    selected = widget.range;
    paymentPurposeGroup = widget.paymentPurposeGroup;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Bộ lọc',
                  style: AppStyles.s21w6,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(
                    AppIcons.close,
                    height: 30,
                    width: 30,
                  ),
                ).inkWell(
                  onTap: () {
                    Scaffold.of(context).closeEndDrawer();
                  },
                ),
              ],
            ),
          ),
          const Divider(
            color: AppColors.gray20,
            height: 2,
            thickness: 2,
          ),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              alignment: Alignment.centerLeft,
              child: Text("Loại giao dịch", style: AppStyles.s14w7)),
          Wrap(
            alignment: WrapAlignment.spaceEvenly,
            spacing: 8.0,
            runSpacing: 16.0,
            children: PaymentPurposeGroup.values.map((e) {
              final isSelected = (paymentPurposeGroup ?? []).contains(e);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      paymentPurposeGroup
                          ?.removeWhere((element) => element == e);
                    } else {
                      paymentPurposeGroup = (paymentPurposeGroup ?? [])..add(e);
                    }
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        isSelected ? AppColors.primaryMain : AppColors.gray05,
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                  child: Text(
                    e.name,
                    style: AppStyles.s14w4.withColor(isSelected
                        ? AppColors.primaryLight
                        : AppColors.gray70x76),
                  ),
                ),
              );
            }).toList(),
          ),
          SelectDateRange(
              range: selected,
              onRangeChanged: (value) {
                selected = value;
              }),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      selected = null;
                      paymentPurposeGroup = null;
                      setState(() {});
                    },
                    child: ButtonWidget(
                      backgroundColor: AppColors.primaryMainBlur,
                      child: Text(
                        "Đặt lại",
                        style: AppStyles.s14w6.withColor(AppColors.primaryMain),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      widget.onRangeChanged(selected, paymentPurposeGroup);
                      Scaffold.of(context).closeEndDrawer();
                    },
                    child: ButtonWidget(
                      backgroundColor: AppColors.primaryMain,
                      child: Text(
                        "Áp dụng",
                        style:
                            AppStyles.s14w6.withColor(AppColors.primaryLight),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
