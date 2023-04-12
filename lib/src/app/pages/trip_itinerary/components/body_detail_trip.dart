import 'package:exxe/src/utils/export/ui_export.dart';

import '../../../../data/models/models.dart';
import 'google_maps_image.dart';
import 'info_itinerary_trip.dart';

class BodyDetailTrip extends StatelessWidget {
  const BodyDetailTrip(this.carCustomer, {Key? key, this.onRefresh})
      : super(key: key);
  final CompoundingCarCustomerModel carCustomer;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * 0.29),
          child: GoogleMapImageDetailTrip(
            startLatitude: carCustomer.fromLatitude!,
            startLongitude: carCustomer.fromLongitude!,
            endLatitude: carCustomer.toLatitude!,
            endLongitude: carCustomer.toLongitude!,
            driver: carCustomer.carDriverId!,
            customer: carCustomer,
          ),
        ),
        Positioned(
          bottom: 0.0,
          child: InfoTripPanel(
            carCustomer,
            onRefresh: onRefresh,
          ),
        ),
        const DraggableSupportButton(),
      ],
    );
  }
}
