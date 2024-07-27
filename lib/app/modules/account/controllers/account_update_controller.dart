import 'package:flutter/material.dart';
import 'package:get/get.dart' hide GetStringUtils;
import 'package:lazyui/lazyui.dart';
import 'package:simanis/app/core/utils/fetch.dart';
import 'package:simanis/app/core/utils/toast.dart';
import 'package:simanis/app/widgets/forms/forms.dart';

import '../../../data/services/api/api.dart';

class AccountUpdateController extends GetxController {
  AccountApi api = AccountApi();

  Map<String, TextEditingController> forms = Forms.create([
    "nik_waris",
    "waris",
    {"hubungan": "Suami"},
    "npwp"
  ]);

  RxBool isLoading = false.obs;

  Future updateProfile() async {
    try {
      Forms valid = Forms.validate(forms, required: ['*', 'npwp']);

      if (!valid.ok) {
        return Toasts.show('Mohon lengkapi data anda');
      }

      Toasts.overlay('Memperbarui data...');
      ResHandler res = await api.updateProfile(forms.toMap());
      Toasts.dismiss();

      if (!res.status) {
        return Toasts.show(res.message);
      }

      Toasts.show(res.message ?? 'Data berhasil diperbarui');
      Get.back();
    } catch (e, s) {
      Errors.check(e, s);
    }
  }
}
