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
        logg("bbi $bbi");
        // 2. Hitung Kebutuhan Kalori Basal (KKB)
        double kkb = hitungKebutuhanKaloriBasal(jk, bbi);
        logg("kkb $kkb");
        // 3. Pertimbangan Umur
        double kkbSetelahUmur = pertimbangkanUmur(kkb, age);
        logg("kkbSetelahUmur $kkbSetelahUmur");
        // 4. Tambah Faktor Aktivitas Fisik
        double kkbSetelahAktivitas =
            tambahkanFaktorAktivitas(kkbSetelahUmur, activity);

        logg("kaloriAkhir $kkbSetelahAktivitas");
        // 5. Pertimbangan Berat Badan Saat Ini
        double kaloriAkhir = pertimbangkanBeratBadan(
            kkbSetelahAktivitas, payload['status_weight']);
        logg("kaloriAkhir $kaloriAkhir");
        // 6. Hitung BMR (Basal Metabolism Rate)
        double bmr = hitungBmr(jk, weight, tall, age);
        logg("bmr $bmr");
        // 7. Hitung Total Kebutuhan Kalori Berdasarkan Tingkat Aktivitas
        totalKebutuhanKalori = hitungTotalKebutuhanKalori(bmr, activity);
        logg("totalKebutuhanKalori $totalKebutuhanKalori");


       try {
      ResHandler res = await educationApi.getDiets(totalKebutuhanKalori);
      List data = res.data['times'] ?? [];

      this.data.value = [...data.map((e) => Time.fromJson(e))];
        
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
  if (usia >= 49 && usia <= 59) {
    return kalori * 0.95;
  } else if (usia >= 60 && usia <= 69) {
    return kalori * 0.90;
  } else if (usia >= 70) {
    return kalori * 0.80;
  } else {
    return kalori;
  }
}

double tambahkanFaktorAktivitas(double kalori, String aktivitas) {
  if (aktivitas == "istirahat") {
    return kalori * 1.10;
  } else if (aktivitas == "ringan") {
    return kalori * 1.20;
  } else if (aktivitas == "sedang") {
    return kalori * 1.30;
  } else if (aktivitas == "berat") {
    return kalori * 1.40;
  } else if (aktivitas == "sangat_berat") {
    return kalori * 1.50;
  }
  return kalori;
}

double pertimbangkanBeratBadan(double kalori, String statusBB) {
  if (statusBB == "gemuk") {
    return kalori * 0.70;
  } else if (statusBB == "kurus") {
    return kalori * 1.30;
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

double hitungTotalKebutuhanKalori(double bmr, String aktivitas) {
  if (aktivitas == "jarang") {
    return bmr * 1.2;
  } else if (aktivitas == "ringan") {
    return bmr * 1.375;
  } else if (aktivitas == "cukup") {
    return bmr * 1.55;
  } else if (aktivitas == "sering") {
    return bmr * 1.725;
  } else if (aktivitas == "sangat_sering") {
    return bmr * 1.9;
  }
  return bmr;
}
