import 'package:carousel_slider/carousel_slider.dart';
import 'package:exxe/src/utils/export/ui_export.dart';

import '../../../../../data/data.dart';
import 'suggest_item.dart';

class ListSuggestTrips extends StatefulWidget {
  const ListSuggestTrips({Key? key, required this.type}) : super(key: key);
  final CompoundingType? type;

  @override
  State<ListSuggestTrips> createState() => _ListSuggestTripsState();
}

class _ListSuggestTripsState extends State<ListSuggestTrips> {
  List<CompoundingCarModel>? compoundingCars;
  late RemoveListener removeListener;

  @override
  void initState() {
    super.initState();
    loadSuggestList(
        GetIt.I.get<AppState>().currentState.currentLocation?.coordinate);
    removeListener = GetIt.I.get<AppState>().addListener((state) {
      if (state.isNewAction &&
          state.action == ActionStateEnum.loadedCurrentLocation &&
          state.payload is CoordinateModel) {
        final payload = state.payload as CoordinateModel;
        loadSuggestList(payload);
      }
    });
  }

  loadSuggestList(CoordinateModel? coor) {
    if (coor == null) return;
    compoundingCars = null;
    if (mounted) {
      setState(() {});
    }
    CompoundingCarControllerRepo()
        .getCompoundingCarAvailable(
      currentCoordinate:
          CoordinateModel(latitude: coor.latitude, longitude: coor.longitude),
      type: widget.type,
    )
        .then((either) {
      either.fold((l) {
        log(l.toString());
        compoundingCars = [];
      }, (data) {
        compoundingCars = data;
        if (mounted) {
          setState(() {});
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    removeListener();
  }

  final options = CarouselOptions(
    height: 305,
    aspectRatio: 18 / 9,
    viewportFraction: 0.7,
    initialPage: 0,
    enableInfiniteScroll: true,
    // reverse: false,
    autoPlay: true,
    autoPlayInterval: const Duration(seconds: 3, milliseconds: 500),
    autoPlayAnimationDuration: const Duration(milliseconds: 800),
    autoPlayCurve: Curves.fastOutSlowIn,
    enlargeCenterPage: false,
    scrollDirection: Axis.horizontal,
  );

  @override
  Widget build(BuildContext context) {
    return compoundingCars == null
        ? _buildShimmer()
        : compoundingCars!.isEmpty
            ? const SizedBox(
                height: 50,
                child: Center(
                  child: Text(
                    "Hiện tại không có sẵn chuyến, vui lòng tạo chuyến mới !",
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textError),
                  ),
                ),
              )
            : SizedBox(
                height: 305,
                child: CarouselSlider(
                    items: compoundingCars!
                        .map(
                          (e) => GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, Routes.joinConvenientTripDetail,
                                  arguments: {'compoundingCar': e});
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, top: 4, bottom: 4),
                              child: SuggestRideItem(
                                compoundingCar: e,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    options: options),
              );
  }

  _buildShimmer() {
    return CarouselSlider(
      items: List.generate(10, (index) => _shimmerItem()),
      options: options,
    );
  }

  _shimmerItem() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 4),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 157,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  height: 20,
                  width: double.infinity,
                  color: Colors.grey,
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 6.0, vertical: 15),
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  height: 20,
                  width: double.infinity,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                height: 36,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: 20,
                        width: 60,
                        color: Colors.grey,
                      ),
                    ),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: 20,
                        width: 60,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
