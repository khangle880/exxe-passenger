import 'package:exxe/src/utils/export/ui_export.dart';

import '../../../data/models/models.dart';
import 'components/body_detail_trip.dart';

class TripItineraryPage extends StatelessWidget {
  const TripItineraryPage({
    super.key,
    required this.carCustomer,
    required this.onRefresh,
  });

  final CompoundingCarCustomerModel carCustomer;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBarWidget(
        backgroundColor: Colors.transparent,
        title: 'Hành trình của bạn',
        context: context,
        actions: [
          Container(
            height: 40,
            width: 40,
            margin: const EdgeInsets.only(right: 20),
            decoration: const ShapeDecoration(
              color: AppColors.accBlueMain,
              shape: CircleBorder(),
            ),
            alignment: Alignment.center,
            child: const Center(
              child: Icon(Icons.refresh, color: AppColors.primaryLight),
            ),
          ).inkWell(onTap: onRefresh),
        ],
      ),
      body: BodyDetailTrip(
        carCustomer,
        onRefresh: onRefresh,
      ),
    );
  }
}
