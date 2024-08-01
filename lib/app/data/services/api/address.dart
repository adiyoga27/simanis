

import 'package:simanis/app/core/utils/fetch.dart';

class AddressApi extends Fetch {
  Future<ResHandler> getProvince() async =>
      await get('https://api-mobile.saddannusantara.com/gsongkir/province.php');
  Future<ResHandler> getCity(String provinceId) async =>
      await get('https://api-mobile.saddannusantara.com/gsongkir/city.php?province=$provinceId');
  Future<ResHandler> getSubdistrict(String cityId) async =>
      await get('https://api-mobile.saddannusantara.com/gsongkir/subdistrict.php?city=$cityId');

}
