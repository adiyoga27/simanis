import 'package:get/get.dart' hide GetStringUtils;
import 'package:lazyui/lazyui.dart';
import 'package:simanis/app/core/utils/fetch.dart';
import 'package:simanis/app/core/utils/my_location.dart';
import 'package:simanis/app/core/utils/procis/procis.dart';
import 'package:simanis/app/core/utils/toast.dart';
import 'package:simanis/app/data/models/profile_model.dart';
import 'package:simanis/app/data/repository/api/api.dart';
import 'package:simanis/app/data/repository/api/response_handler.dart';

import '../../../data/services/api/api.dart';

class AccountUpdateController extends GetxController {
  AccountApi api = AccountApi();
 ProfileModel profile = ProfileModel();
  final forms = LzForm.make([
      'name', 'birthdate','phone', 'jk', 'is_smoke','medical_history', 
      'email', 'provinsi', 'kota', 'kecamatan', 
      'address','kelurahan','kode_pos', 'tall','weight','blood']);

  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    openInit();
  }
  
  void openInit() async {
      isLoading.value = true;
      ResHandler res = await api.getProfile();
      profile = ProfileModel.fromJson(res.data);
      forms.fill({
        'name': profile.name,
        'birthdate': profile.birthdate.format('dd-MM-yyyy'),
        'phone': profile.phone,
        'jk': profile.jk,
        'is_smoke': profile.isSmoke == 1 ? 'Merokok' : 'Tidak Merokok',
        'medical_history': profile.medicalHistory,
        'email': profile.email,
        'username': profile.username,
        'provinsi': profile.province,
        'kota': profile.city,
        'kecamatan': profile.subdistrict,
        'address': profile.address,
        'kelurahan': profile.village,
        'kode_pos': profile.kodePos,
        'tall': profile.tall,
        'weight': profile.weight,
        'blood': profile.blood,
       
      });
      isLoading.value = false;
      update();
  }
  Future updateProfile() async {
    try {
    final form = LzForm.validate(forms,
          required: ['*','kode_pos'],
          messages: FormMessages(required: {
            'username': 'Masukkan ID member',
            'password': 'Masukkan password',
            'name': 'Masukkan Nama Pengguna ',
            'birthdate': 'Masukkan Tanggal Lahir',
            'phone': 'Masukkan nomor kontak pengguna',
            'jk': 'Masukkan jenis kelamin',
            'blood': 'Golongan darah belum dipilih',
            'tall': 'Masukkan tinggi badan',
            'weight': 'Masukkan berat badan',
            'is_smoke': 'Pilih status perokok',
            'medical_history': 'Masukkan riwayat kesehatan',
            'email': 'Masukkan email ',
            'provinsi': 'Pilih Provinsi Anda ',
            'kecamatan': 'Pilih kota/kabupaten anda ',
            'subdistrict': 'Pilih Kecamatan Anda ',
            'address': 'Masukkan alamat tinggal anda ',
            'passwordk': 'Konfirmasi kata sandi tidak boleh kosong',

          }));


      if (form.ok) {

              Toasts.overlay('Memproses...');
          final payload = {...form.value};
          payload['province'] = payload['provinsi'];
          payload['city'] = payload['kota'];
          payload['subdistrict'] = payload['kecamatan'];
          payload['village'] = payload['kelurahan'];
          payload['kode_pos'] = payload['kode_pos'];
          payload['is_smoke'] = payload['is_smoke'] == 'Merokok'? 1 : 0;

          ResponseHandler res = await AuthService.updateProfile(payload);
          if (res.status) {
            Toasts.dismiss();

            Toasts.show(res.message);
            Get.back();

          } else {
            Toasts.dismiss();
            Toasts.show(res.message);
          }


      }
    } catch (e, s) {
      Errors.check(e, s);
    }
  }

  

  List<Option> provinces = [];
  Map<String, List<Option>> cities = {};
  Map<String, List<Option>> districts = {};

  String? provinceId, cityId, districtId;
  Future onTap(SelectController control) async {
    try {
      switch (control.label) {
        case 'Provinsi':
          if (provinces.isEmpty) {
            Toasts.overlay('Memuat data provinsi...');
            final list = await ProcisApi.getProvince();
            provinces = list
                .map((e) =>
                    Option(option: e['province'], value: e['province_id']))
                .toList();
          }

          control.options = provinces;

          break;

        case 'Kota':
          if (provinceId == null) {
            Toasts.show('Anda belum memilih provinsi.');
            return false;
          }

          if (cities[provinceId] == null) {
            Toasts.overlay('Memuat data kota...');
            final list = await ProcisApi.getCity(provinceId!);

            List<Option> options = list
                .map((e) => Option(option: e['city_name'], value: e['city_id']))
                .toList();
            cities = {...cities, provinceId!: options};
          }

          control.options = cities[provinceId]!;
          break;

        default:
          if (cityId == null) {
            Toasts.show('Anda belum memilih kota.');
            return false;
          }

          if (districts[cityId] == null) {
            Toasts.overlay('Memuat data kecamatan...');
            final list = await ProcisApi.getSubdistrict(cityId!);

            List<Option> options = list
                .map((e) => Option(
                    option: e['subdistrict_name'], value: e['subdistrict_id']))
                .toList();
            districts = {...districts, cityId!: options};
          }

          control.options = districts[cityId]!;
      }
    } catch (e, s) {
      Errors.check(e, s);
      return false;
    }
  }

   Future onSelect(SelectController control) async {
    try {
      switch (control.label) {
        case 'Provinsi':
          provinceId = control.option?.value;
          cityId = null;
          districtId = null;

          LzForm.reset(forms, only: ['kota', 'kecamatan']);
          break;

        case 'Kota':
          if (provinceId == null) {
            return Toasts.show('Anda belum memilih provinsi.');
          }

          cityId = control.option?.value;
          districtId = null;

          LzForm.reset(forms, only: ['kecamatan']);
          break;

        default:
          if (cityId == null) return Toasts.show('Anda belum memilih kota.');
          districtId = control.option?.value;
      }
    } catch (e, s) {
      Errors.check(e, s);
      return false;
    }
  }
  Future setByMyLocation(LzButtonControl state) async {
    try {
      state.submit();
      MyLocation location = await MyLocation.get();

      // get data provinsi, kota, dan kecamatan
      List provinces = await ProcisApi.getProvince();
      Map province = provinces.firstWhere(
          (e) => e['province'].toString().contains(location.province ?? ''),
          orElse: () => {});
      provinceId = province['province_id'];

      String? cityName, subdistrictName;

      if (provinceId != null) {
        List cities = await ProcisApi.getCity(provinceId!);
        Map city = cities.firstWhere(
            (e) => e['city_name'].toString().contains(location.city ?? ''),
            orElse: () => {});
        cityName = city['city_name'];
        cityId = city['city_id'];

        if (cityId != null) {
          List subdistricts = await ProcisApi.getSubdistrict(cityId!);
          Map subdistrict = subdistricts.firstWhere(
              (e) => e['subdistrict_name'].toString().contains(
                  (location.subdistrict ?? '')
                      .replaceAll('Kecamatan', '')
                      .trim()),
              orElse: () => {});
          subdistrictName = subdistrict['subdistrict_name'];
          districtId = subdistrict['subdistrict_id'];
        }
      }

      provinceId = province['province_id'];

      List addresses = [
        location.street,
        location.village,
        location.subdistrict,
        location.city,
        location.postalCode,
        location.province,
      ];

      // convert into string if not null or empty
      String address = addresses
          .where((e) => e != null && e.toString().isNotEmpty)
          .join(', ');

      LzForm.fill(forms, {
        'provinsi': province['province'] ?? '',
        'kota': cityName ?? '',
        'kecamatan': subdistrictName ?? '',
        'kelurahan': location.village,
        'kodepos': location.postalCode,
        'alamat': address,
      });

      Get.back();
      Toasts.show('Alamat berhasil diisi.');
    } catch (e, s) {
      Errors.check(e, s);
    } finally {
      state.abort();
    }
  }
}
