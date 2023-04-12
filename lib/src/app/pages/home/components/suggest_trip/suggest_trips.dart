import 'package:app_settings/app_settings.dart';
import 'package:exxe/src/app/pages/home/components/suggest_trip/list_suggest_trip.dart';
import 'package:exxe/src/utils/export/ui_export.dart';

import '../../../../../data/data.dart';

class SuggestTripHome extends StatefulWidget {
  const SuggestTripHome({Key? key}) : super(key: key);

  @override
  State<SuggestTripHome> createState() => _SuggestTripHomeState();
}

class _SuggestTripHomeState extends State<SuggestTripHome> {
  final ValueNotifier<int> _index = ValueNotifier<int>(0);
  late RemoveListener removeListener;
  LocationPermissionEnum locationPermission =
      LocationPermissionEnum.locationInvalid;

  @override
  void initState() {
    removeListener = GetIt.I.get<AppState>().addListener((state) {
      if (state.currentLocation != null &&
          locationPermission != LocationPermissionEnum.locationValid) {
        setState(() {
          locationPermission = LocationPermissionEnum.locationValid;
        });
      }
    });

    loadLocation();

    super.initState();
  }

  loadLocation() async {
    await GoogleMapService.instance.enableLocation().then((value) async {
      log('Position: $value');
      LocationModel? locationModel =
          await GetIt.I<LocationHelper>().createLocationModel(value);

      if (locationModel == null) {
        locationPermission = LocationPermissionEnum.locationInvalid;
      } else {
        GetIt.I.get<AppState>().updateCurrentLocation(locationModel);
        locationPermission = LocationPermissionEnum.locationValid;
      }
    }).catchError((e) {
      locationPermission = LocationPermissionEnum.couldNotGetLocation;
    });

    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _index.dispose();
    removeListener();
  }

  @override
  Widget build(BuildContext context) {
    if (locationPermission != LocationPermissionEnum.locationValid) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            Text(
              "Vị trí hiện tại của bạn sẽ giúp chúng tôi gợi ý cho bạn nhưng chuyến đi phù hợp.",
              style: AppStyles.s15w6,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Expanded(
                    child: ButtonWidget(
                      onClick: () {
                        GetIt.I<LocationHelper>().handleLocation(context);
                      },
                      child: Text("Lấy vị trí hiện tại",
                          style: AppStyles.s14w6
                              .withColor(AppColors.primaryLight)),
                    ),
                  ),
                  if (locationPermission ==
                      LocationPermissionEnum.couldNotGetLocation) ...[
                    const SizedBox(width: 8),
                    Expanded(
                      child: ButtonWidget(
                        backgroundColor: AppColors.primaryMain +
                            AppColors.primaryLight.withOpacity(0.95),
                        onClick: () {
                          AppSettings.openLocationSettings();
                          AppDialog.I.closeDialog();
                        },
                        child: Text(
                          "Mở cài đặt quyền vị trí",
                          style:
                              AppStyles.s14w6.withColor(AppColors.primaryMain),
                        ),
                      ),
                    )
                  ]
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              const SizedBox(width: 8),
              Text(
                "Các chuyến tiện chuyến",
                style: AppStyles.s21w7,
              ),
              const Spacer(),
              SvgPicture.asset(AppIcons.searchOutline).inkWell(
                padding: const EdgeInsets.all(8),
                onTap: () {
                  GetIt.I<LocationHelper>().handleLocation(context,
                      routeName: Routes.joinConvenientTrip,
                      args: {'compoundingType': CompoundingType.convenient});
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const ListSuggestTrips(type: null),
        const SizedBox(height: 16),
      ],
    );
  }
}
