import 'package:exxe/src/utils/export/ui_export.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import '../../../data/data.dart';

class GoogleMapSearchPlace extends StatelessWidget {
  final List<SymbolOptions> symbols;
  final CoordinateModel coordinateModel;
  final Function(LatLng)? onTap;

  const GoogleMapSearchPlace({
    Key? key,
    required this.symbols,
    required this.coordinateModel,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MapboxMap(
      accessToken: "EjG4C6ZIkGkbHriul6aKyPVFGj23m5uHRDiPrjO9",
      onMapCreated: (MapboxMapController controller) {
        controller.addSymbols(symbols);
      },
      zoomGesturesEnabled: false,
      initialCameraPosition: CameraPosition(
        target: LatLng(
          coordinateModel.latitude!,
          coordinateModel.longitude!,
        ),
        zoom: 15.0,
      ),
    );
  }
}
