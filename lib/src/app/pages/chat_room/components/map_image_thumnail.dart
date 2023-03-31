import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../utils/export/logic_export.dart';

class MapImageThumbnail extends StatelessWidget {
  const MapImageThumbnail({
    Key? key,
    required this.lat,
    required this.long,
  }) : super(key: key);

  final String lat;
  final String long;

  String get _constructUrl => Uri(
        scheme: 'https',
        host: 'maps.googleapis.com',
        port: 443,
        path: '/maps/api/staticmap',
        queryParameters: {
          'center': '$lat,$long',
          'zoom': '20',
          'size': '700x500',
          'maptype': 'roadmap',
          'key': dotenv.maybeGet('GOOGLE_API_KEY', fallback: null),
          'markers': 'color:red|$lat,$long'
        },
      ).toString();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await GetIt.I<LocationHelper>().openMapNavigation(lat, long);
      },
      child: AbsorbPointer(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(
            _constructUrl,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
