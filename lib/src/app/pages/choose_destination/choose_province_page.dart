import 'package:exxe/src/data/data.dart';
import 'package:exxe/src/storage/models/suggestive_province.dart';
import 'package:exxe/src/utils/export/ui_export.dart';
import 'package:tiengviet/tiengviet.dart';

import '../widget_join_convenient_trip/card_suggestions.dart';

class ChooseProvincePage extends StatefulWidget {
  const ChooseProvincePage({
    Key? key,
    required this.searchType,
    required this.selectLocation,
    this.currentProvince,
  }) : super(key: key);
  final SearchType searchType;
  final Function(LocationModel location) selectLocation;
  final ProvinceModel? currentProvince;

  @override
  State<ChooseProvincePage> createState() => _ChooseProvincePageState();
}

class _ChooseProvincePageState extends State<ChooseProvincePage> {
  late final TextEditingController textController;
  ProvinceModel? selectProvince;
  List<SuggestiveProvince>? suggestProvince;
  late List<ProvinceModel> listProvinces;

  @override
  void initState() {
    super.initState();
    final locationHelper = GetIt.I.get<LocationHelper>();
    listProvinces =
        locationHelper.sortWithHcmHnInFirst(locationHelper.provinces);

    if (widget.currentProvince != null) {
      getSuggestiveProvince(widget.currentProvince!.provinceId!);
    }
    textController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        backgroundColor: AppColors.greyLight,
        title: widget.searchType.name,
        context: context,
      ),
      body: Container(
        color: AppColors.gray05,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: AppStyles.border15,
                border: Border.all(
                  width: 0.5,
                  color: AppColors.gray70x76.withAlpha(50),
                ),
              ),
              child: Row(
                children: [
                  widget.searchType.icon,
                  const SizedBox(width: 4),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.searchType.name,
                          style: AppStyles.s16w7.withColor(AppColors.gray95),
                        ),
                        const SizedBox(height: 4),
                        TextField(
                          controller: textController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(top: 3),
                            hintText: "Nhập tên Tỉnh / Thành phố",
                            hintStyle:
                                AppStyles.s14w4.withColor(AppColors.gray50),
                            border: InputBorder.none,
                            isDense: true, // Added this
                            // contentPadding: EdgeInsets.all(8),
                          ),
                          onChanged: searchProvince,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Gợi ý",
              style: AppStyles.s16w7.withColor(AppColors.gray95),
            ),
            const SizedBox(height: 12),
            (suggestProvince != null)
                ? SizedBox(
                    width: double.infinity,
                    height: 70,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: suggestProvince!.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            ProvinceModel province = listProvinces.firstWhere(
                                (element) =>
                                    element.provinceId ==
                                    suggestProvince![index].provinceId);
                            final model = LocationModel(
                              coordinate: CoordinateModel(
                                  latitude: double.parse(province.latitude!),
                                  longitude: double.parse(province.longitude!)),
                              provinceId: province.provinceId!.ceil(),
                              province: province,
                            );
                            widget.selectLocation(model);
                            Navigator.pop(context);
                          },
                          child: CardSuggestion(
                            textCity: suggestProvince![index].provinceName,
                            textProvince:
                                widget.currentProvince!.provinceShortName!,
                            textKm: suggestProvince![index].distance.toString(),
                          ),
                        );
                      },
                    ),
                  )
                : const SizedBox(),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  final province = listProvinces[index];
                  return InkWell(
                    onTap: () async {
                      if (widget.currentProvince?.provinceId != null &&
                          widget.currentProvince?.provinceId ==
                              province.provinceId!.ceil()) {
                        AppDialog.I.showWarning(
                          message:
                              'Hiện tại hệ thống chỉ hổ trợ dịch vụ liên tỉnh, Vui lòng chọn địa điểm khác',
                        );
                      } else {
                        final model = LocationModel(
                          coordinate: CoordinateModel(
                              latitude: double.parse(province.latitude!),
                              longitude: double.parse(province.longitude!)),
                          provinceId: province.provinceId!.ceil(),
                          province: province,
                        );
                        widget.selectLocation(model);
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        province.provinceName!,
                        style: AppStyles.s14w4.withColor(AppColors.gray70x76),
                      ),
                    ),
                  );
                },
                itemCount: listProvinces.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void searchProvince(String query) {
    final suggestions =
        GetIt.I.get<LocationHelper>().provinces.where((province) {
      final provinceName = province.provinceVietnameseName?.toLowerCase();
      final input = TiengViet.parse(query.toLowerCase().replaceAll(' ', ''));
      return provinceName!.contains(input);
    }).toList();

    setState(() {
      listProvinces = suggestions;
    });
  }

  void getSuggestiveProvince(num key) async {
    var data = await SuggestiveProvinceHiveBox.instance
        .readSuggestProvince(key, widget.searchType);
    if (data.isNotEmpty) {
      setState(() {
        suggestProvince = data;
      });
    }
  }
}
