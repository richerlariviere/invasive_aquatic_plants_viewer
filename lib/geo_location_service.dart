import 'package:angular2/core.dart';
import 'dart:html';
import 'package:google_maps/google_maps.dart';

@Injectable()
class GeoLocationService {
  num currentLatitude = 0;
  num currentLongitude = 0;

  LatLng getCurrentLatLng() async {
    if (window.navigator.geolocation != null) {
      final position = await window.navigator.geolocation.getCurrentPosition();

      final LatLng pos =
          new LatLng(position.coords.latitude, position.coords.longitude);
      return pos;
    }

    return null;
  }
}
