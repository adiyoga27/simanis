import 'package:get/get.dart';
import 'package:lazyui/lazyui.dart';

class BloodSugarController extends GetxController {
  final forms = LzForm.make(['data']);
  RxBool isLoading = false.obs;
  RxBool isSubmit = false.obs;

  late int calculate = 0;
  late String title = "";
  final count = 0.obs;

  void onSubmitGDP() {
    if (forms.value['data'].isEmpty) {
      return LzToast.show('Wajib di isi tools check !');
    }
    isLoading.value = true;
    isSubmit.value = false;

    calculate = int.parse(forms.value['data']);
    // calculate = forms.value['data'];
    if (calculate >= 300) {
      title = "TERLALU TINGGI";
    } else if (calculate > 130) {
      title = "TINGGI";
    } else if (calculate >= 80) {
      title = "NORMAL";
    } else if (calculate < 80) {
      title = "RENDAH";
    }
    isSubmit.value = true;

    isLoading.value = false;
  }

  void onSubmitGDS() {
    if (forms.value['data'].isEmpty) {
      return LzToast.show('Wajib di isi tools check !');
    }
    isSubmit.value = false;

    isLoading.value = true;

    calculate = int.parse(forms.value['data']);
    // calculate = forms.value['data'];
    if (calculate >= 300) {
      title = "TERLALU TINGGI";
    } else if (calculate >= 180) {
      title = "TINGGI";
    } else if (calculate >= 80) {
      title = "NORMAL";
    } else if (calculate >= 70) {
      title = "RENDAH";
    } else if (calculate < 70) {
      title = "TERLALU RENDAH";
    }
    isLoading.value = false;
    isSubmit.value = true;
  }
}
