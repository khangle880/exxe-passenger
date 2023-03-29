import 'dart:async';
import 'package:exxe/src/utils/export/ui_export.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../data/data.dart';

class ShareLocationPage extends StatefulWidget {
  const ShareLocationPage({super.key, required this.callBack});
  final Function(CoordinateModel coordinateModel) callBack;
  @override
  State<ShareLocationPage> createState() => _ShareLocationPageState();
}

class _ShareLocationPageState extends State<ShareLocationPage> {
  final CoordinateModel coordinateModel =
      GetIt.I.get<AppState>().currentState.currentLocation!.coordinate!;

  final Set<Marker> markers = {};

  final Set<Polyline> polyLines = {};

  final Completer<GoogleMapController> goggleMapController = Completer();
  bool isClick = true;
  @override
  void initState() {
    super.initState();
    markers.add(
      Marker(
        markerId: const MarkerId('fromPoint'),
        position: LatLng(
          coordinateModel.latitude!,
          coordinateModel.longitude!,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            GoogleMapBackground(
              controller: goggleMapController,
              markers: markers,
              polyLines: polyLines,
            ),
            const Positioned(
              left: 10.0,
              top: 10.0,
              child: SafeArea(
                child: IconArrowBackCircle(),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.maxFinite,
                color: AppColors.gray05,
                margin: const EdgeInsets.only(
                    bottom: 17, left: 24, right: 24, top: 12),
                child: ButtonWidget(
                  backgroundColor: AppColors.accBlueMain,
                  onClick: () {
                    widget.callBack(coordinateModel);
                  },
                  child: Text(
                    "Chia sẻ vị trí ngay",
                    style: AppStyles.s14w6.withColor(AppColors.primaryLight),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
