part of 'api.dart';

class EducationApi extends Fetch {
  Future<ResHandler> getEduaction() async =>
      await get('https://simanis.codingaja.com/api/education/edukasi');
        Future<ResHandler> getPhysicalTraining() async =>
      await get('https://simanis.codingaja.com/api/education/latihan-fisik');
  Future<ResHandler> getFootCare() async =>
      await get('https://simanis.codingaja.com/api/education/perawatan-kaki');
}