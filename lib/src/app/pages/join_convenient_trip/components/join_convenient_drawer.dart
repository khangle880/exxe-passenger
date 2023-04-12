import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../data/models/models.dart';
import '../../../../utils/export/ui_export.dart';

class JoinConvenientDrawer extends StatefulWidget {
  const JoinConvenientDrawer(
      {Key? key,
      this.range,
      this.car,
      this.brand,
      required this.onRangeChanged})
      : super(key: key);
  final PickerDateRange? range;
  final CarModel? car;
  final CarBrandModel? brand;
  final void Function(
          PickerDateRange? range, CarModel? car, CarBrandModel? brand)
      onRangeChanged;

  @override
  State<JoinConvenientDrawer> createState() => _JoinConvenientDrawerState();
}

class _JoinConvenientDrawerState extends State<JoinConvenientDrawer> {
  late PickerDateRange? range;
  late CarModel? car;
  late CarBrandModel? brand;

  @override
  void initState() {
    super.initState();
    range = widget.range;
    car = widget.car;
    brand = widget.brand;
  }

  @override
  Widget build(BuildContext context) {
    final carTypes = GetIt.I<AppState>().cars;
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
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
                  const SizedBox(width: 8),
                  SelectDateRange(
                      range: range,
                      isFuture: true,
                      onRangeChanged: (value) {
                        range = value;
                      }),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Loại xe",
                            style: AppStyles.s14w7.withColor(AppColors.gray95),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildCarTypes(carTypes),
                        const SizedBox(height: 20),
                        // _buildCarBrands(carBrands),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: ButtonWidget(
                    onClick: () {
                      range = null;
                      car = null;
                      brand = null;
                      setState(() {});
                    },
                    backgroundColor: AppColors.primaryMainBlur,
                    child: Text(
                      "Đặt lại",
                      style: AppStyles.s14w6.withColor(AppColors.primaryMain),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ButtonWidget(
                    onClick: () {
                      widget.onRangeChanged(range, car, brand);
                      Scaffold.of(context).closeEndDrawer();
                    },
                    backgroundColor: AppColors.primaryMain,
                    child: Text(
                      "Áp dụng",
                      style: AppStyles.s14w6.withColor(AppColors.primaryLight),
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

  _buildCarBrands(List<CarBrandModel> brands) {
    final listItems = Wrap(
      alignment: WrapAlignment.spaceEvenly,
      spacing: 8.0,
      runSpacing: 16.0,
      children: brands
          .map(
            (e) =>
                e.brandName != null ? _buildCarBrandItem(e) : const SizedBox(),
          )
          .toList(),
    );

    if (brands.length < 5) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "Mẫu xe",
              style: AppStyles.s14w7.withColor(AppColors.gray95),
            ),
          ),
          const SizedBox(height: 12),
          listItems,
        ],
      );
    }

    return ExpandablePanel(
      theme: const ExpandableThemeData(
        headerAlignment: ExpandablePanelHeaderAlignment.center,
        tapBodyToExpand: true,
        tapBodyToCollapse: true,
        hasIcon: false,
      ),
      header: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            Text(
              "Mẫu xe",
              style: AppStyles.s14w7.withColor(AppColors.gray95),
            ),
            const Spacer(),
            Text(
              "Xem thêm",
              style: AppStyles.s14w4.withColor(AppColors.gray70x76),
            ),
            ExpandableIcon(
              theme: ExpandableThemeData(
                iconPadding: EdgeInsets.zero,
                expandIcon: SvgPicture.asset(AppIcons.directionDown,
                    height: 20, width: 20, color: AppColors.primaryMain),
                collapseIcon: SvgPicture.asset(AppIcons.directionTop,
                    height: 20, width: 20, color: AppColors.primaryMain),
              ),
            ),
          ],
        ),
      ),
      collapsed: Wrap(
        alignment: WrapAlignment.spaceEvenly,
        spacing: 8.0,
        runSpacing: 8.0,
        children: brands
            .sublist(0, 5)
            .map(
              (e) => e.brandName != null
                  ? _buildCarBrandItem(e)
                  : const SizedBox(),
            )
            .toList(),
      ),
      expanded: listItems,
    );
  }

  Widget _buildCarBrandItem(CarBrandModel item) {
    return GestureDetector(
      onTap: () {
        brand = item;
        setState(() {});
      },
      child: Container(
        decoration: BoxDecoration(
          color: brand == item ? AppColors.primaryMain : AppColors.gray05,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        child: Text(
          item.brandName!,
          style: AppStyles.s14w4.withColor(
              brand == item ? AppColors.primaryLight : AppColors.gray70x76),
        ),
      ),
    );
  }

  Widget _buildCarTypes(List<CarModel> carTypes) {
    return Wrap(
      alignment: WrapAlignment.spaceEvenly,
      spacing: 16.0,
      runSpacing: 8.0,
      children: (carTypes
            ..sort((a, b) => (a.numberSeat ?? 0).compareTo(b.numberSeat ?? 0)))
          .map(
            (e) => e.name != null
                ? GestureDetector(
                    onTap: () {
                      car = e;
                      setState(() {});
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            car == e ? AppColors.primaryMain : AppColors.gray05,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 16),
                      child: Text(
                        e.name!.replaceAll("XE ", ""),
                        style: AppStyles.s14w4.withColor(car == e
                            ? AppColors.primaryLight
                            : AppColors.gray70x76),
                      ),
                    ),
                  )
                : const SizedBox(),
          )
          .toList(),
    );
  }
}
