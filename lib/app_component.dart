import 'package:angular2/core.dart';
import 'dart:html';
import 'package:google_maps/google_maps.dart';
import 'geo_location_service.dart';
import 'invasive_plants_service.dart';
import 'dart:async';

@Component(
    selector: 'app',
    templateUrl: 'app_component.html',
    styleUrls: const ['app_component.css'],
    providers: const [GeoLocationService, InvasivePlantsService])
class AppComponent implements OnInit, OnChanges {
  AppComponent(this._geolocationService, this._invasivePlantsService);

  final InvasivePlantsService _invasivePlantsService;
  final GeoLocationService _geolocationService;
  List<InfoWindow> _infoWindows = new List<InfoWindow>();
  GMap map;

  /// Handle component interaction via events
  void ngOnChanges(Map<String, SimpleChange> changes) {
    print("ngOnChanges");
  }

  /// Init map component
  void ngOnInit() async {
    print("ngOnInit");
    createGMap();
    setupCurrentLocation();
    loadInvasiveAquaticPlants();
  }

  /// Instanciate Google map api instance
  void createGMap() {
    final mapOptions = new MapOptions()..zoom = 15;
    map = new GMap(document.getElementById("map-canvas"), mapOptions);
  }

  /// Fetch current location and center the map on the point
  void setupCurrentLocation() async {
    final pos = await _geolocationService.getCurrentLatLng();
    final infowindow = new InfoWindow(new InfoWindowOptions()
      ..position = pos
      ..content = 'Votre position actuelle.');

    _infoWindows.add(infowindow);

    infowindow.open(map);
    map.center = pos;
  }

  void loadInvasiveAquaticPlants() async {
    _invasivePlantsService
        .getInvasivePlants()
        .then((List<InvasivePlants> result) {
      List<InvasivePlants> invasivePlants = result;

      for (var invasivePlant in invasivePlants) {
        var marker = new Marker(new MarkerOptions()
          ..position = invasivePlant.position
          ..map = map
          ..icon = "img/warning.svg"
          ..title = invasivePlant.scientificName);
        final infowindow = new InfoWindow(new InfoWindowOptions()
          ..position = invasivePlant.position
          ..content = invasivePlant.scientificName);
        marker.onClick.listen((e) {
          infowindow.open(map, marker);
        });
      }
    });
  }
}
