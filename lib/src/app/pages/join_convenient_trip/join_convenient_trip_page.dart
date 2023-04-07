import 'package:exxe/src/utils/export/ui_export.dart';

import '../../../data/data.dart';
import '../../../storage/models/suggestive_province.dart';
import '../pages.dart';

class JoinConvenientTripPage extends StatefulWidget {
  const JoinConvenientTripPage({Key? key, required this.compoundingType})
      : super(key: key);
  final CompoundingType compoundingType;

  @override
  State<JoinConvenientTripPage> createState() => _JoinConvenientTripPageState();
}

class _JoinConvenientTripPageState extends State<JoinConvenientTripPage> {
  late PaginationHelper controller;
  late final ScrollController _controller;

  late final ExpandableController expandableController;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    expandableController = ExpandableController(initialExpanded: true);
    // Setup the listener.
    _controller.addListener(() {
      bool isTop = _controller.position.pixels < 10;
      expandableController.expanded = isTop;
    });
    context
        .read<JoinConvenientTripCubit>()
        .getCompoundingType(widget.compoundingType);
  }

  @override
  Widget build(BuildContext context) {
    JoinConvenientTripState state =
        context.watch<JoinConvenientTripCubit>().state;
    return Scaffold(
      endDrawer: Drawer(
        backgroundColor: AppColors.white,
        child: JoinConvenientDrawer(
          range: state.filterRange,
          car: state.filterCarType,
          brand: state.filterCarBrand,
          onRangeChanged: (range, car, brand) {
            context.read<JoinConvenientTripCubit>().updateFilter(
                  range: range,
                  carType: car,
                  carBrand: brand,
                );
          },
        ),
      ),
      appBar: CustomAppBarWidget(
        backgroundColor: AppColors.greyLight,
        title: state.carType == CompoundingType.compounding
            ? "Ghép chuyến"
            : "Tiện chuyến",
        context: context,
      ),
      floatingActionButton: state.carType == CompoundingType.compounding
          ? Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: FloatingActionButton.extended(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    Routes.bookingJoinFillForm,
                    arguments: {
                      'carCustomModel': CompoundingCarCustomerModel(
                        compoundingType: CompoundingType.compounding,
                        fromProvince: state.pickupPoint?.province,
                        toProvince: state.destinationPoint?.province,
                        expectedGoingOnDate: state.dateTime,
                      ),
                    },
                  );
                },
                backgroundColor: AppColors.primaryButton,
                icon: const Icon(Icons.add_circle_outline_outlined),
                label: const Text('Tạo Chuyến'),
              ),
            )
          : null,
      body: BlocListener<JoinConvenientTripCubit, JoinConvenientTripState>(
        listenWhen: (previous, current) =>
            previous.pickupPoint != current.pickupPoint ||
            previous.destinationPoint != current.destinationPoint,
        listener: (context, state) async {
          if (state.pickupPoint != null && state.destinationPoint != null) {
            var distance = await GetIt.I<PlaceRepository>().getDirection(
              fromLat: double.parse(state.pickupPoint!.province!.latitude!),
              fromLong: double.parse(state.pickupPoint!.province!.longitude!),
              toLat: double.parse(state.destinationPoint!.province!.latitude!),
              toLong:
                  double.parse(state.destinationPoint!.province!.longitude!),
            );
            distance.fold(
              (failure) {
                log('ko tính dc khoang cách 2 tỉnh');
              },
              (data) async {
                await SuggestiveProvinceHiveBox.instance.saveSuggestProvince(
                    SuggestiveProvince(
                      provinceId: state.destinationPoint!.provinceId!,
                      provinceName:
                          state.destinationPoint!.province!.provinceShortName!,
                      distance: data.getDistanceKm,
                    ),
                    state.pickupPoint!.provinceId!,
                    SearchType.destinationProvince);
                await SuggestiveProvinceHiveBox.instance.saveSuggestProvince(
                    SuggestiveProvince(
                      provinceId: state.pickupPoint!.provinceId!,
                      provinceName:
                          state.pickupPoint!.province!.provinceShortName!,
                      distance: data.getDistanceKm,
                    ),
                    state.destinationPoint!.provinceId!,
                    SearchType.pickUpProvince);
              },
            );
          }
        },
        child: Container(
          color: AppColors.greyLight,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 8),
                child: ExpandableTheme(
                  data: const ExpandableThemeData(
                    iconColor: Colors.blue,
                    useInkWell: true,
                  ),
                  child: ExpandablePanel(
                    controller: expandableController,
                    collapsed: PickupInfoCollapseCard(
                      pickupPoint: state.pickupPoint,
                      destinationPoint: state.destinationPoint,
                      onClickedPickupGoingOn: () {
                        Navigator.pushNamed(
                          context,
                          Routes.chooseDestination,
                          arguments: {
                            'searchType': SearchType.pickUpProvince,
                            'selectLocation': (location) {
                              context
                                  .read<JoinConvenientTripCubit>()
                                  .getFromProvince(location);
                            },
                            'currentProvince': state.destinationPoint?.province
                          },
                        );
                      },
                      onClickedDestinationPoint: () {
                        Navigator.pushNamed(
                          context,
                          Routes.chooseDestination,
                          arguments: {
                            'searchType': SearchType.destinationProvince,
                            'selectLocation': (location) {
                              context
                                  .read<JoinConvenientTripCubit>()
                                  .getToProvince(location);
                            },
                            'currentProvince': state.pickupPoint?.province
                          },
                        );
                      },
                      selectedDate: state.dateTime,
                      onSelectDate: () {
                        CustomCalendar.showCalendar(
                          context,
                          (date) {
                            context
                                .read<JoinConvenientTripCubit>()
                                .getDateTime(date);
                          },
                          minDate: DateTime.now(),
                          initDate: state.dateTime ?? DateTime.now(),
                        );
                      },
                    ),
                    expanded: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        PickupItineraryCard(
                          pickupPoint: state.pickupPoint,
                          destinationPoint: state.destinationPoint,
                          onClickedPickupGoingOn: () {
                            Navigator.pushNamed(
                              context,
                              Routes.chooseDestination,
                              arguments: {
                                'searchType': SearchType.pickUpProvince,
                                'selectLocation': (LocationModel location) {
                                  context
                                      .read<JoinConvenientTripCubit>()
                                      .getFromProvince(location);
                                },
                                'currentProvince':
                                    state.destinationPoint?.province
                              },
                            );
                          },
                          onClickedDestinationPoint: () {
                            Navigator.pushNamed(
                              context,
                              Routes.chooseDestination,
                              arguments: {
                                'searchType': SearchType.destinationProvince,
                                'selectLocation': (LocationModel location) {
                                  context
                                      .read<JoinConvenientTripCubit>()
                                      .getToProvince(location);
                                },
                                'currentProvince': state.pickupPoint?.province
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: PickupDate(
                            selectedDate: state.dateTime,
                            onSelectDate: () {
                              CustomCalendar.showCalendar(
                                context,
                                (date) {
                                  context
                                      .read<JoinConvenientTripCubit>()
                                      .getDateTime(date);
                                },
                                minDate: DateTime.now(),
                                initDate: state.dateTime ?? DateTime.now(),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: CompoundingCarRecommend(
                  externalScrollController: _controller,
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  isShowFilter: true,
                  from: state.pickupPoint,
                  to: state.destinationPoint,
                  goingOnTime: state.dateTime,
                  carId: state.filterCarType?.carId,
                  fromExpectedGoingOnDate: state.filterRange?.startDate,
                  toExpectedGoingOnDate: state.filterRange?.endDate,
                  type: state.carType == CompoundingType.compounding
                      ? CompoundingType.compounding
                      : CompoundingType.convenient,
                  onItemSelected: (CompoundingCarModel carModel) {
                    Navigator.pushNamed(
                      context,
                      Routes.joinConvenientTripDetail,
                      arguments: {
                        "compoundingCar": carModel,
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
