import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:lazyui/lazyui.dart';
import 'package:simanis/app/core/utils/toast.dart';
import 'package:simanis/app/data/repository/api/api.dart';
import 'package:simanis/app/data/repository/api/response_handler.dart';
import 'package:simanis/app/routes/app_pages.dart';

class FootScreeningController extends GetxController {
  final forms = LzForm.make([
    'sensasi_terbakar',
    'sensasi_sentuhan',
    'pulsasi_nyeri',
    'pulsasi_kaki',
    'pulsasi_pemeriksaan',
    'bentuk_kulit',
    'bentuk_kapalan',
    'bentuk_kaki',
  ]);

  // login with username and password
  Future onSubmit() async {
    try {
      final form = LzForm.validate(forms,
          required: ['*'],
          messages: FormMessages(required: {
            'sensasi_terbakar': 'Semua kolom wajib diisi.',
            'sensasi_sentuhan': 'Semua kolom wajib diisi.',
            'pulsasi_nyeri': 'Semua kolom wajib diisi.',
            'pulsasi_kaki': 'Semua kolom wajib diisi.',
            'pulsasi_pemeriksaan': 'Semua kolom wajib diisi.',
            'bentuk_kulit': 'Semua kolom wajib diisi.',
            'bentuk_kapalan': 'Semua kolom wajib diisi.',
            'bentuk_kaki': 'Semua kolom wajib diisi.',
          }));

      if (form.ok) {
        Toasts.overlay('Memproses...');
        final payload = {...form.value};

        int diagnosis = checkRadio(payload['sensasi_terbakar']) +
            checkRadio(payload['sensasi_sentuhan']) +
            checkRadio(payload['pulsasi_nyeri']) +
            checkRadio(payload['pulsasi_kaki']) +
            checkRadio(payload['pulsasi_pemeriksaan']) +
            checkRadio(payload['bentuk_kulit']) +
            checkRadio(payload['bentuk_kapalan']) +
            checkRadio(payload['bentuk_kaki']);
        logg(diagnosis);
        Toasts.dismiss();

        if (diagnosis >= 3) {
          Get.dialog(LzConfirm(
              title: 'RESIKO TINGGI',
              message:
                  'Anda memiliki resiko tinggi terhadap penyakit DM. Silahkan Hubungi Dokter untuk konsultasi',
              confirmText: 'Rekomendasi Edukasi',
              onConfirm: () {}));
        } else if (diagnosis >= 1) {
          Get.dialog(LzConfirm(
              title: 'RESIKO RINGAN',
              message:
                  'Anda tergolong kategori ringan terhadap penyakit DM. Silahkan mulai edukja',
              confirmText: 'Rekomendasi Edukasi',
              onConfirm: () {}));
        } else {}
      }
    } on FirebaseException catch (e, s) {
      Errors.check(e, s);
    } catch (e, s) {
      Errors.check(e, s);
    } finally {}
  }

  int checkRadio(String value) {
    if (value == 'YA') {
      return 1;
    }
    return 0;
  }
}
