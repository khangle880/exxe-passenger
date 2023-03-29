import '../../../data/models/models.dart';
import '../../../utils/export/ui_export.dart';
import '../../common/widgets/search_list_view.dart';
import 'controllers/pickup_address_bloc.dart';

class PickupMyAddressPage extends StatelessWidget {
  const PickupMyAddressPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PickupAddressBloc>();
    return BlocBuilder<PickupAddressBloc, PickupAddressState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.primaryLight,
          appBar: CustomAppBarWidget(
            centerTitle: true,
            autoGeneraIconLeading: true,
            title: "Điền địa chỉ của bạn",
            fontSizeTitle: 18,
            context: context,
            backgroundColor: AppColors.primaryLight,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 16),
                if (state.province != null) ...[
                  _buildAddressRow(state.province!.provinceName!, () {
                    bloc.add(const ChangeProvinceEvent(null));
                  }),
                  const SizedBox(height: 12),
                ],
                if (state.district != null) ...[
                  _buildAddressRow(state.district!.districtName!, () {
                    bloc.add(const ChangeDistrictEvent(null));
                  }),
                  const SizedBox(height: 12),
                ],
                if (state.ward != null) ...[
                  _buildAddressRow(state.ward!.wardName!, () {
                    bloc.add(const ChangeWardEvent(null));
                  }),
                  const SizedBox(height: 12),
                ],
                if (state.province != null &&
                    state.district != null &&
                    state.ward != null) ...[
                  const SizedBox(height: 4),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Text("Địa chỉ", style: AppStyles.s18w7),
                  ),
                  const SizedBox(height: 4),
                  TextFormFieldBuilder.search(
                    style: AppStyles.s16w4,
                    textInputAction: TextInputAction.search,
                    hintText: "Nhập địa chỉ nhà cụ thể",
                    hintStyle: AppStyles.s16w4.withColor(
                      AppColors.gray50,
                    ),
                    onChanged: (value) {
                      bloc.add(ChangeAddressEvent(value));
                    },
                    suffixIcon: const SizedBox(),
                  ),
                ] else
                  Expanded(
                    child: _buildAddressList(bloc, state),
                  ),
              ],
            ),
          ),
          bottomNavigationBar: ButtonWidget(
            onClick: (state.address ?? "").isEmpty
                ? null
                : () {
                    Navigator.pop(
                      context,
                      LocationModel(
                          province: state.province,
                          district: state.district,
                          ward: state.ward,
                          address: state.address,
                          coordinate: const CoordinateModel()),
                    );
                  },
            radius: 12,
            child: Text("Tiếp tục",
                style: AppStyles.s16w6.withColor(AppColors.primaryLight)),
          ).bottomSingle(),
        );
      },
    );
  }

  _buildAddressRow(String title, Function() onCancel) {
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
                child: Text(title,
                    style: AppStyles.s16w4.withColor(AppColors.primaryMain))),
          ),
          Material(
            color: Colors.transparent,
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

  _buildAddressList(PickupAddressBloc bloc, PickupAddressState state) {
    if (state.province == null) {
      return SearchListView<ProvinceModel>(
        list: state.provinces,
        onSelected: (value) {
          bloc.add(ChangeProvinceEvent(value));
        },
        getName: (value) {
          return value.provinceName!;
        },
        title: "Chọn Tỉnh",
      );
    }
    if (state.district == null) {
      return SearchListView<DistrictModel>(
        list: state.districts,
        onSelected: (value) {
          bloc.add(ChangeDistrictEvent(value));
        },
        getName: (value) {
          return value.districtName!;
        },
        title: "Chọn Quận/Huyện",
      );
    }
    if (state.ward == null) {
      return SearchListView<WardModel>(
        list: state.wards,
        onSelected: (value) {
          bloc.add(ChangeWardEvent(value));
        },
        getName: (value) {
          return value.wardName!;
        },
        title: "Chọn Phường/Xã",
      );
    }
    return Container();
  }
}
