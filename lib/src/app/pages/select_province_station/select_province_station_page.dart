import '../../../utils/export/logic_export.dart';
import '../../../utils/export/ui_export.dart';
import '../pages.dart';
import 'controller/select_province_station_cubit.dart';

class SelectProvinceStationPage extends StatefulWidget {
  const SelectProvinceStationPage({
    Key? key,
    required this.callback,
    required this.type,
    this.currentProvinceId,
  }) : super(key: key);
  final void Function(ProvinceModel provinceModel, StationModel stationModel)
      callback;
  final SearchType type;
  final num? currentProvinceId;

  @override
  State<SelectProvinceStationPage> createState() =>
      _SelectProvinceStationPageState();
}

class _SelectProvinceStationPageState extends State<SelectProvinceStationPage> {
  late TextEditingController controller;
  List<ProvinceModel> listProvinces = GetIt.I.get<LocationHelper>().provinces;
  late final SelectProvinceStationCubit bloc;
  StationModel? selectedItem;

  @override
  void initState() {
    bloc = context.read<SelectProvinceStationCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectProvinceStationCubit, SelectProvinceStationState>(
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: AppColors.primaryLight,
          appBar: CustomAppBarWidget(
            centerTitle: true,
            autoGeneraIconLeading: true,
            backgroundColor: AppColors.primaryLight,
            title: widget.type.name,
            context: context,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                if (state.selectedProvince != null) ...[
                  _buildProvinceRow(state.selectedProvince!.provinceName!, () {
                    selectedItem = null;
                    return bloc.clearSelection();
                  }),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 16),
                    child: buildTextTitle('Trạm đón ', isRequirement: true),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.stations!.length,
                      itemBuilder: (context, index) {
                        return buildListStationItem(state.stations![index]);
                      },
                    ),
                  )
                ],
                if (state.selectedProvince == null)
                  Expanded(child: buildSearchListProvince(state)),
              ],
            ),
          ),
          bottomNavigationBar: state.selectedStation == null
              ? null
              : ButtonWidget(
                  onClick: () {
                    log("ten tinh ${state.selectedProvince!.provinceName} ten tram ${state.selectedStation!.stationName}");
                    widget.callback(
                      state.selectedProvince!,
                      state.selectedStation!,
                    );
                    Navigator.pop(context);
                  },
                  radius: 12,
                  child: Text(
                    "Tiếp tục",
                    style: AppStyles.s16w6.withColor(AppColors.primaryLight),
                  ),
                ).bottomSingle(),
        );
      },
    );
  }

  _buildProvinceRow(String title, Function() onCancel) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColors.primaryMainBlur,
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                title,
                style: AppStyles.s16w4.withColor(AppColors.primaryMain),
              ),
            ),
          ),
          Material(
            child: InkWell(
              onTap: onCancel,
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: SvgPicture.asset(
                  AppIcons.close,
                  color: AppColors.primaryMain,
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
        ],
      ),
    );
  }

  buildSearchListProvince(SelectProvinceStationState state) {
    if (state.selectedProvince == null) {
      return SearchListView(
        list: listProvinces,
        onSelected: (ProvinceModel value) {
          if (widget.currentProvinceId == value.provinceId) {
            AppDialog.I.showWarning(
                message: "Hệ thống hiện tại chưa hỗ trợ đi trong tỉnh");
          } else {
            bloc.changeProvince(value);
          }
        },
        getName: (ProvinceModel value) {
          return value.provinceName!;
        },
        title: 'Chọn tỉnh / Thành phố',
      );
    } else {
      return const SizedBox();
    }
  }

  Widget buildTextTitle(String text, {bool isRequirement = true}) {
    return isRequirement
        ? RichText(
            text: TextSpan(
              text: text,
              style: AppStyles.s16w7.withColor(AppColors.gray95x06),
              children: const [
                TextSpan(
                  text: " *",
                  style: TextStyle(color: AppColors.utilRed),
                )
              ],
            ),
          )
        : Text(
            text,
            style: AppStyles.s16w7.withColor(AppColors.gray95x06),
          );
  }

  Widget buildListStationItem(StationModel stationModel) {
    final isSelected = selectedItem?.stationId == stationModel.stationId;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedItem = stationModel;
        });
        bloc.changeStation(stationModel);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.only(left: 16, right: 16),
        height: 48,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryMain + AppColors.primaryLight.withOpacity(0.9)
              : AppColors.gray60x9d + AppColors.primaryLight.withOpacity(0.9),
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
