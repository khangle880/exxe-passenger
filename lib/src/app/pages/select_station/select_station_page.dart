import 'package:exxe/src/utils/export/ui_export.dart';

import '../../../data/data.dart';

class SelectStationPage extends StatefulWidget {
  const SelectStationPage({
    super.key,
    required this.onSelectStation,
    required this.provinceModel,
    required this.searchType,
    this.initStation,
    this.isPickingUpFromStart,
    this.initAddress,
  });

  final Function(StationModel station, String? address, bool? isPickUp)
      onSelectStation;
  final ProvinceModel provinceModel;
  final SearchType searchType;
  final StationModel? initStation;
  final bool? isPickingUpFromStart;
  final String? initAddress;

  @override
  State<SelectStationPage> createState() => _SelectStationPageState();
}

class _SelectStationPageState extends State<SelectStationPage> {
  String? requestAddress;
  bool? isChoosePickUp;
  StationModel? selectedItem;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    selectedItem = widget.initStation;
    requestAddress = widget.initAddress;
    isChoosePickUp = widget.isPickingUpFromStart;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Scaffold(
        backgroundColor: AppColors.greyLight,
        appBar: CustomAppBarWidget(
          backgroundColor: AppColors.greyLight,
          title: widget.searchType.name,
          context: context,
        ),
        bottomNavigationBar: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: ButtonWidget(
              onClick: selectedItem != null
                  ? () {
                      if (formKey.currentState!.validate()) {
                        widget.onSelectStation(
                            selectedItem!, requestAddress, isChoosePickUp);
                        log('current address $requestAddress');
                        Navigator.pop(context);
                      }
                    }
                  : null,
              child: Text(
                'Tiếp tục',
                style: AppStyles.s16w6.withColor(AppColors.primaryLight),
              ),
            )),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 28),
                child: Row(
                  children: [
                    Text(
                      widget.searchType == SearchType.pickUpMap
                          ? 'Tram đón'
                          : 'Trạm đến',
                      style: AppStyles.s18w7.withColor(AppColors.primaryDark),
                    ),
                    TextWidget(
                      text: '*',
                      fontSize: 18,
                      weight: AppStyles.fontWeightW700,
                      colorText: AppColors.accRedMain,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (widget.provinceModel.pickingUpStations != null)
                ...widget.provinceModel.pickingUpStations!
                    .map((e) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: buildListItem(e),
                        ))
                    .toList(),
              widget.searchType == SearchType.pickUpStation
                  ? Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Row(
                        children: [
                          Switch(
                              activeColor: AppColors.primaryMain,
                              activeTrackColor: AppColors.accBlueMain,
                              value: isChoosePickUp ?? false,
                              onChanged: (value) {
                                setState(() {
                                  isChoosePickUp = value;
                                  if (!value) {
                                    requestAddress = null;
                                  }
                                });
                              }),
                          const SizedBox(width: 4),
                          TextWidget(
                            text: 'Đón tận nơi',
                            fontSize: 16,
                            weight: AppStyles.fontWeightW700,
                            colorText: AppColors.primaryDark,
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
              isChoosePickUp ?? false
                  ? _buildSelectAnotherStation(
                      onTap: () {
                        Navigator.pushNamed(context, Routes.searchPlace,
                            arguments: {
                              'searchType': SearchType.pickUpMap,
                              'onSelect': (LocationModel locationModel) {
                                setState(() {
                                  requestAddress = locationModel.address;
                                });
                              }
                            });
                      },
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  _buildSelectAnotherStation({Function()? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12, left: 24, right: 24),
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: CustomFormField(
              validator: (value) {
                if ((isChoosePickUp ?? false) && requestAddress == null) {
                  return 'Vui lòng chọn điếm dón';
                }
                return null;
              },
              child: Container(
                padding: const EdgeInsets.only(
                    left: 8, right: 16, top: 8, bottom: 8),
                height: 48,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset(AppIcons.circleBorder,
                        width: 32, height: 32),
                    const SizedBox(width: 4),
                    requestAddress == null
                        ? Expanded(
                            child: Text('Tìm điểm đón',
                                style: AppStyles.s14w4
                                    .withColor(AppColors.disable)))
                        : Expanded(
                            child: Text(
                              requestAddress!,
                              maxLines: 1,
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          TextWidget(
            fontSize: 14,
            weight: AppStyles.fontWeightW400,
            colorText: AppColors.gray70x76,
            maxLine: 2,
            text:
                '(*) Chi phí phát sinh khách hàng vui lòng tự thanh toán với tài xế',
          )
        ],
      ),
    );
  }

  Widget buildListItem(StationModel stationModel) {
    final isSelected = selectedItem?.stationId == stationModel.stationId;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedItem = stationModel;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.only(left: 16, right: 16),
        height: 48,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryMain + AppColors.primaryLight.withOpacity(0.9)
              : AppColors.disable + AppColors.primaryLight.withOpacity(0.9),
          border: isSelected ? Border.all(color: AppColors.primaryMain) : null,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              stationModel.stationName!,
              style: AppStyles.s14w4.withColor(
                  isSelected ? AppColors.primaryMain : AppColors.gray70x76),
            ),
            isSelected
                ? const Icon(
                    Icons.check,
                    color: AppColors.accBlueMain,
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
