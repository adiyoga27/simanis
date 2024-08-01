
import 'package:simanis/app/core/utils/fetch.dart';
import 'package:simanis/app/core/utils/toast.dart';
import 'package:simanis/app/data/services/api/address.dart';

class ProcisApi {
  ProcisApi._();
  static final ProcisApi instance = ProcisApi._();

  AddressApi api = AddressApi();

  static Future<List> getProvince() async {
    ResHandler res = await ProcisApi.instance.api.getProvince();
    List data = res.body?['rajaongkir']?['results'] ?? [];

    Toasts.dismiss();
    return data;
  }

  static Future<List> getCity(String provinceId) async {
    ResHandler res = await ProcisApi.instance.api.getCity(provinceId);
    List data = res.body?['rajaongkir']?['results'] ?? [];

    Toasts.dismiss();
    return data;
  }

  static Future<List> getSubdistrict(String cityId) async {
    ResHandler res = await ProcisApi.instance.api.getSubdistrict(cityId);
    List data = res.body?['rajaongkir']?['results'] ?? [];

    Toasts.dismiss();
    return data;
  }

  static Future<Map<String, List>> getAll() async {
    List province = await ProcisApi.getProvince();
    List city = await ProcisApi.getCity(province[0]['province_id']);
    List subdistrict = await ProcisApi.getSubdistrict(city[0]['city_id']);

    Toasts.dismiss();
    return {
      'province': province,
      'city': city,
      'subdistrict': subdistrict,
    };
  }
}