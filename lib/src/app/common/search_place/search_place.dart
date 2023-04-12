import 'dart:async';

import 'package:exxe/src/utils/export/ui_export.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../data/data.dart';

class SearchPlace extends StatefulWidget {
  final SearchType searchType;
  final Function(LocationModel location) onSelect;
  final int? selectedProvince;

  const SearchPlace({
    Key? key,
    required this.searchType,
    required this.onSelect,
    this.selectedProvince,
  }) : super(key: key);

  @override
  State<SearchPlace> createState() => _SearchPlaceState();
}

class _SearchPlaceState extends State<SearchPlace> {
  final controller = TextEditingController();
  late final StreamController<bool> focusStream;
  FocusNode focusNode = FocusNode();
  late final SearchPlaceBloc bloc;
  final Completer<GoogleMapController> goggleMapController = Completer();

  final LocationModel currentLocation =
      GetIt.I.get<AppState>().currentState.currentLocation!;

  final Set<Marker> markers = {};

  @override
  void dispose() {
    controller.dispose();
    focusStream.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    focusStream = StreamController();
    focusStream.sink.add(true);
    focusNode.addListener(() {
      focusStream.sink.add(focusNode.hasFocus);
    });
    bloc = context.read<SearchPlaceBloc>();
    markers.add(
      Marker(
        markerId: const MarkerId('current_location'),
        position: LatLng(
          currentLocation.coordinate!.latitude!,
          currentLocation.coordinate!.longitude!,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = GetIt.I.get<AppState>().currentState.user;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.greyLight,
        body: Stack(
          children: [
            GoogleMapSearchPlace(
              onTap: (_) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              markers: markers,
              controller: goggleMapController,
              coordinateModel: currentLocation.coordinate!,
            ),
            BlocConsumer<SearchPlaceBloc, SearchPlaceState>(
              listenWhen: (previous, current) =>
                  previous.locationModel != current.locationModel,
              listener: (context, state) async {
                if (state.locationModel != null) {
                  final GoogleMapController controller =
                      await goggleMapController.future;
                  controller.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: LatLng(
                          state.locationModel!.coordinate!.latitude!,
                          state.locationModel!.coordinate!.longitude!,
                        ),
                        zoom: 15.0,
                      ),
                    ),
                  );
                  markers.clear();
                  markers.add(Marker(
                    markerId: const MarkerId('location'),
                    position: LatLng(
                      state.locationModel!.coordinate!.latitude!,
                      state.locationModel!.coordinate!.longitude!,
                    ),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueRose),
                  ));
                  if (mounted) {
                    setState(() {});
                  }
                }
              },
              builder: (context, state) {
                if (state.locationModel != null) {
                  return Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: double.maxFinite,
                      color: Colors.transparent,
                      margin: const EdgeInsets.only(
                          bottom: 17, left: 24, right: 24, top: 12),
                      child: ButtonWidget(
                        onClick: () {
                          if (state.locationModel!.provinceId!.ceil() ==
                              widget.selectedProvince) {
                            AppDialog.I.showWarning(
                                message:
                                    'Hệ thống chưa hổ trợ đi trong tỉnh vui lòng chọn khu vực khác');
                          } else {
                            widget.onSelect(state.locationModel!);
                            Navigator.pop(context);
                          }
                        },
                        radius: 12,
                        child: Text(
                          "Tiếp Tục",
                          style:
                              AppStyles.s16w6.withColor(AppColors.primaryLight),
                        ),
                      ),
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppbarSearchPlace(searchType: widget.searchType),
                const SizedBox(
                  height: 20,
                ),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: FormSearchPlace(
                    focusNode: focusNode,
                    onChange: (String data) {
                      bloc.add(LocationAutoComplete(searchText: data));
                    },
                    controller: controller,
                    searchType: widget.searchType,
                  ),
                ),
                _buildSuggestList(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _buildSuggestList() {
    final userInfo = GetIt.I.get<AppState>().currentState.user;
    return StreamBuilder<bool>(
      stream: focusStream.stream,
      builder: (_, snapshot) {
        if (snapshot.hasData && snapshot.data!) {
          return BlocBuilder<SearchPlaceBloc, SearchPlaceState>(
              builder: (_, state) {
            if (state.suggestivePlaces == null) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  _buildCard(
                    title: 'Vị trí hiện tại của bạn',
                    iconUrl: AppIcons.gps,
                    subtitle: currentLocation.address ??
                        'Không tìm thấy địa chỉ hiện tại của bạn',
                    callback: () {
                      if (widget.selectedProvince ==
                          currentLocation.provinceId) {
                        AppDialog.I.showWarning(
                            message:
                                'Hệ thống chưa hổ trợ đi trong tỉnh vui lòng chọn khu vực khác');
                      } else {
                        widget.onSelect(
                          LocationModel(
                            address: currentLocation.address,
                            provinceId: currentLocation.provinceId,
                            coordinate: currentLocation.coordinate,
                            province: currentLocation.province,
                          ),
                        );
                        if (mounted) {
                          Navigator.pop(context);
                        }
                      }
                      focusNode.unfocus();
                    },
                  ),
                  const SizedBox(height: 10),
                  if (userInfo?.provinceId?.provinceId != null &&
                      userInfo?.street != null)
                    _buildCard(
                      title: 'Nhà',
                      iconUrl: AppIcons.home,
                      subtitle:
                          '${userInfo!.street}, ${userInfo.wardId?.wardName}, ${userInfo.districtId?.districtName}, ${userInfo.provinceId?.provinceName}, ${userInfo.countryId?.countryName}',
                      callback: () async {
                        if (widget.selectedProvince ==
                            userInfo.provinceId?.provinceId!.ceil()) {
                          AppDialog.I.showWarning(
                              message:
                                  'Hệ thống chưa hổ trợ đi trong tỉnh vui lòng chọn khu vực khác');
                        } else {
                          String address =
                              '${userInfo.street}, ${userInfo.wardId?.wardName}, ${userInfo.districtId?.districtName}, ${userInfo.provinceId?.provinceName}, ${userInfo.countryId?.countryName}';
                          var data = await GetIt.I<LocationHelper>()
                              .getCoordinateFromAddress(address);
                          if (mounted) {
                            widget.onSelect(
                              LocationModel(
                                address: address,
                                provinceId:
                                    userInfo.provinceId!.provinceId!.ceil(),
                                coordinate: data,
                                province: userInfo.provinceId,
                              ),
                            );
                            Navigator.pop(context);
                          }
                        }
                      },
                    ),
                ],
              );
            } else {
              return Container(
                height: 350,
                margin: const EdgeInsets.symmetric(horizontal: 24.0),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: AppStyles.border15,
                ),
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.builder(
                    itemCount: state.suggestivePlaces!.length,
                    itemBuilder: (context, index) {
                      String title = state.suggestivePlaces![index]
                          .structuredFormatting!.mainText!;
                      title = title.isEmpty
                          ? state.suggestivePlaces![index].structuredFormatting!
                              .secondaryText!
                          : title;

                      return _buildResultSearch(
                        index,
                        state.suggestivePlaces!,
                        title,
                        state.suggestivePlaces![index].description!,
                        () {
                          controller.text =
                              state.suggestivePlaces![index].description!;
                          bloc.add(PickingNewPosition(
                              state.suggestivePlaces![index].placeId!));
                          focusNode.unfocus();
                        },
                      );
                    },
                  ),
                ),
              );
            }
          });
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget _buildCard({
    required String title,
    required String iconUrl,
    required String subtitle,
    required VoidCallback callback,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          iconUrl,
          color: AppColors.primaryButton,
          width: 20,
          height: 20,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  text: title,
                  fontSize: 16.0,
                  weight: FontWeight.w700,
                ),
                const SizedBox(height: 5),
                TextWidget(
                  text: subtitle,
                  fontSize: 14.0,
                  colorText: AppColors.gray70x76,
                  maxLine: 3,
                )
              ],
            ),
          ),
        )
      ],
    )
        .inkWell(
          onTap: callback,
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: AppColors.greyLight,
            borderRadius: AppStyles.border15,
          ),
        )
        .margin(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
        );
  }

  Widget _buildResultSearch(
      int index,
      List<SuggestivePlaceModel> suggestivePlaces,
      String title,
      String subtitle,
      VoidCallback callback) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          AppIcons.locationPurple,
          color: AppColors.primaryButton,
          width: 20,
          height: 20,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  text: title,
                  fontSize: 16.0,
                  weight: FontWeight.w700,
                ),
                const SizedBox(height: 5),
                TextWidget(
                  text: subtitle,
                  fontSize: 14.0,
                  colorText: AppColors.gray70x76,
                  maxLine: 3,
                )
              ],
            ),
          ),
        )
      ],
    ).inkWell(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: AppColors.greyLight,
          borderRadius: BorderRadius.only(
            topLeft: Radius.zero,
            topRight: Radius.zero,
            bottomLeft: index == suggestivePlaces.length - 1
                ? const Radius.circular(15)
                : Radius.zero,
            bottomRight: index == suggestivePlaces.length - 1
                ? const Radius.circular(15)
                : Radius.zero,
          )),
      onTap: callback,
    );
  }
}
