import 'package:angular2/core.dart';
import 'dart:html';
import 'dart:async';
import 'package:google_maps/google_maps.dart';
import 'invasive_plant.dart';
import 'package:csv_sheet/csv_sheet.dart';

@Injectable()
class InvasivePlantsService {
  Future<List<InvasivePlant>> getInvasivePlants() {
    return HttpRequest
        .getString('DB_invasive_sp_cdn.csv')
        .then((String fileContent) {
      String invasivePlantsContent = fileContent;

      var sheet = new CsvSheet(invasivePlantsContent, headerRow: true);
      List<InvasivePlant> invasivePlants = new List<InvasivePlant>();
      sheet.forEachRow((CsvRow cells) {
        var invasivePlant = new InvasivePlant();

        invasivePlant.position =
            new LatLng(double.parse(cells[6]), double.parse(cells[7]));
        invasivePlant.scientificName = cells[5];

        invasivePlants.add(invasivePlant);
      });

      return invasivePlants;
    }).catchError((Error error) {
      print(error.toString());
    });
  }
}
