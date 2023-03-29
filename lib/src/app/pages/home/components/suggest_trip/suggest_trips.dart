import 'package:exxe/src/app/pages/home/components/suggest_trip/list_suggest_trip.dart';
import 'package:exxe/src/utils/export/ui_export.dart';

class SuggestTripHome extends StatefulWidget {
  const SuggestTripHome({Key? key}) : super(key: key);

  @override
  State<SuggestTripHome> createState() => _SuggestTripHomeState();
}

class _SuggestTripHomeState extends State<SuggestTripHome> {
  final ValueNotifier<int> _index = ValueNotifier<int>(0);
  late RemoveListener removeListener;
  bool hasLocation = false;

  @override
  void initState() {
    removeListener = GetIt.I.get<AppState>().addListener((state) {
      if (state.currentLocation != null && !hasLocation) {
        setState(() {
          hasLocation = true;
        });
      }
    });
    GetIt.I<LocationHelper>().loadLocation(context);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _index.dispose();
    removeListener();
  }

  @override
  Widget build(BuildContext context) {
    if (!hasLocation) return const SizedBox(height: 0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            children: [
              TextWidget(
                text: "Các chuyến gần tôi",
                fontSize: AppDimens.text21,
                weight: FontWeight.w700,
              )
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
