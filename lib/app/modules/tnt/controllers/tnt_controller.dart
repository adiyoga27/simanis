import 'dart:math';

import 'package:get/get.dart';
import 'package:lazyui/lazyui.dart';
import 'package:simanis/app/core/utils/fetch.dart';
import 'package:simanis/app/data/models/diet_model.dart';
import 'package:simanis/app/data/models/profile_model.dart';
import 'package:simanis/app/data/services/api/api.dart';
import 'package:simanis/app/routes/app_pages.dart';

class TntController extends GetxController {
  AccountApi api = AccountApi();
  EducationApi educationApi = EducationApi();
  ProfileModel profile = ProfileModel();
  double bmi = 0.0;
  double kalori = 0.0;
  int age = 0;
  int tall = 0;
  String jk = '';
  String activity = '';
  String bmiNote = '';
  double weight = 0.0;
  double totalKebutuhanKalori = 0.0;
  double beratIdeal = 0.0;
  final forms =
      LzForm.make(['tall', 'weight', 'jk', 'activity', 'age', 'status_weight']);

  RxBool isLoading = false.obs;
  RxList<Time> data = RxList([]);

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
      'tall': profile.tall,
      'weight': profile.weight,
      'jk': profile.jk,
      'age': calculateAge(profile.birthdate!),
    });
    isLoading.value = false;
    update();
  }

  Future check() async {
    isLoading.value = true;
    try {
      final form = LzForm.validate(forms,
          required: ['*'],
          messages: FormMessages(required: {
            'jk': 'Masukkan jenis kelamin',
            'tall': 'Masukkan tinggi badan',
            'weight': 'Masukkan berat badan',
            'activity': 'Pilih aktivitas fisik',
            'status_weight': 'Pilih status berat badan',
          }));

      if (form.ok) {
        final payload = {...form.value};
        age = int.parse(payload['age']);
        tall = int.parse(payload['tall']);
        weight = double.parse(payload['weight']);
        jk = payload['jk'];
        activity = payload['activity'];

        bmi = weight / ((tall / 100 * tall / 100));
        if (bmi > 28) {
          bmiNote = 'Obesitas';
        } else if (bmi >= 25) {
          bmiNote = 'Berat Berlebih';
        } else if (bmi >= 17) {
          bmiNote = 'Berat Ideal';
        } else {
          bmiNote = 'Berat Rendah';
        }

        // 1. Hitung Berat Badan Ideal (BBI)
        double bbi = hitungBeratBadanIdeal(jk, tall);
        // 2. Hitung Kebutuhan Kalori Basal (KKB)
        double kkJk = hitungKebutuhanKaloriBasal(jk, bbi);
        // 3. Pertimbangan Umur
        double kkUmur = pertimbangkanUmur(kkJk, age);
        // 4. Tambah Faktor Aktivitas Fisik
        double kkAktivitas =
            tambahkanFaktorAktivitas(kkUmur, kkJk, activity);

        // 5. Pertimbangan Berat Badan Saat Ini
        double kkBerat = pertimbangkanBeratBadan(
            kkAktivitas, kkJk, payload['status_weight']);

        totalKebutuhanKalori = kkBerat;
        
          logg('Berat : $weight');
          logg('Tinggi : $tall');
          logg('Berat Ideal : $bbi');
          logg('IMT : $bmi');
          logg('Kalori Jenis Kelamin : $kkJk');
          logg('Umur : $kkUmur');
          logg('Aktivity : $kkAktivitas');
          logg('Berat : $kkBerat');
       try {
      ResHandler res = await educationApi.getDiets(totalKebutuhanKalori);
      logg(res.data);
      if( res.message == "Tidak ada rekomendasi"){
        this.data.value = [];
       
      }else{
         List data = res.data['times'] ?? [];

      this.data.value = [...data.map((e) => Time.fromJson(e))];
      }
    
    } catch (e, s) {
           Errors.check(e, s);

    }


        Get.toNamed(Routes.CHECK_TNM);
      }
    } catch (e, s) {
      Errors.check(e, s);
    }
    isLoading.value = false;
  }
}

int calculateAge(DateTime birthDate) {
  DateTime today = DateTime.now();
  int age = today.year - birthDate.year;

  // Jika ulang tahun belum terjadi tahun ini
  if (today.month < birthDate.month ||
      (today.month == birthDate.month && today.day < birthDate.day)) {
    age--;
  }

  return age;
}

double hitungBeratBadanIdeal(String jenisKelamin, int tbCm) {
  if (jenisKelamin == "Laki-laki") {
    return (tbCm - 100) - ((tbCm - 100) * 0.1);
  } else if (jenisKelamin == "Perempuan") {
    return (tbCm - 100) - ((tbCm - 100) * 0.15);
  }
  return 0.0;
}

double hitungKebutuhanKaloriBasal(String jenisKelamin, double bbi) {
  if (jenisKelamin == "Laki-laki") {
    return 30 * bbi;
  } else if (jenisKelamin == "Perempuan") {
    return 25 * bbi;
  }
  return 0.0;
}

double pertimbangkanUmur(double kalori, int usia) {
  if (usia >= 70 ) {
    return kalori - (kalori * 0.2);
  } else if (usia >= 60 ) {
    return kalori - ( kalori * 0.1 );
  } else if (usia >= 40) {
    return kalori - ( kalori * 0.05 );
  } else {
    return kalori;
  }
}

double tambahkanFaktorAktivitas(double kkUmur, double kkJK,  String aktivitas) {
  if (aktivitas == "Istirahat") {
    return kkUmur + (kkJK * 0.1);
  } else if (aktivitas == "Aktivitas Ringan (Kantor, Guru, Ibu Rumah Tangga)") {
    return kkUmur + (kkJK * 0.2);
  } else if (aktivitas == "Aktivitas Sedang (Pegawai Industri, Mahasiswa, Militer TIdak Berperang)") {
    return kkUmur + (kkJK * 0.3);
  } else if (aktivitas == "Aktivitas Berat (petani, buruh, atlet, militer berperang)") {
    return kkUmur + (kkJK * 0.4);
  } else if (aktivitas == "Aktivitas Sangat Berat (Tukang Becak, Tukang Gali)") {
    return kkUmur + (kkJK * 0.5);
  }
  return kkUmur;
}

double pertimbangkanBeratBadan(double kalori, double kkJk ,String statusBB) {
  if (statusBB == "Gemuk") {
    return kalori - (kkJk * 0.25);
  } else if (statusBB == "Kurus") {
    return kalori + (kkJk * 0.25);
  }
  return kalori;
}

double hitungBmr(String jenisKelamin, double bbKg, int tbCm, int usia) {
  if (jenisKelamin == "Laki-laki") {
    return 88.4 + (13.4 * bbKg) + (4.8 * tbCm) - (5.68 * usia);
  } else if (jenisKelamin == "Perempuan") {
    return 447.6 + (9.25 * bbKg) + (3.10 * tbCm) - (4.33 * usia);
  }
  return 0.0;
}

