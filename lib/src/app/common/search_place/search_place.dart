import 'dart:async';

import 'package:exxe/src/app/common/search_place/components/search_default_card.dart';
import 'package:exxe/src/utils/export/ui_export.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import '../../../data/data.dart';
import 'components/search_suggest.dart';

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
  MapboxMapController? mapController;
  final LocationModel currentLocation =
      GetIt.I.get<AppState>().currentState.currentLocation!;

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
    mapController?.addSymbol(
      SymbolOptions(
        geometry: LatLng(
          currentLocation.coordinate!.latitude!,
          currentLocation.coordinate!.longitude!,
        ),
        iconImage: 'assets/images/car_marker.png',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.greyLight,
        body: Stack(
          children: [
            Builder(
              builder: (_) {
                final String accessToken =
                    dotenv.maybeGet('MAPBOXTOKEN', fallback: null) ?? "";
                final String key =
                    dotenv.maybeGet('GOONG_MAP_KEY', fallback: null) ?? "";
                return MapboxMap(
                  accessToken: accessToken,
                  styleString:
                      'https://tiles.goong.io/assets/goong_map_web.json?api_key=$key',
                  onMapCreated: (MapboxMapController controller) {
                    mapController = controller;
                  },
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      currentLocation.coordinate!.latitude!,
                      currentLocation.coordinate!.longitude!,
                    ),
                    zoom: 15.0,
                  ),
                );
              },
            ),
            BlocConsumer<SearchPlaceBloc, SearchPlaceState>(
              listenWhen: (previous, current) =>
                  previous.locationModel != current.locationModel,
              listener: (context, state) async {
                if (state.locationModel != null) {
                  mapController?.animateCamera(
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
                  mapController?.clearSymbols();
                  mapController?.addSymbol(
                    SymbolOptions(
                      geometry: LatLng(
                        state.locationModel!.coordinate!.latitude!,
                        state.locationModel!.coordinate!.longitude!,
                      ),
                      iconImage: AppIcons.locationPng,
                      iconSize: 2,
                      iconOffset: const Offset(0, -10)
                    ),
                  );
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
                  SearchDefaultCard(
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
                    SearchDefaultCard(
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

                      return SearchSuggest(
                        index: index,
                        suggestivePlaces: state.suggestivePlaces!,
                        title: title,
                        subtitle: state.suggestivePlaces![index].description!,
                        callback: () {
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
}
