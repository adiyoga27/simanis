import 'package:get/get.dart';
import 'package:lazyui/lazyui.dart';

class BloodSugarController extends GetxController {
  final forms = LzForm.make(['data']);
  bool isLoading = false;
  late final int calculate;
  late final String title;
  final count = 0.obs;
 

  void onSubmitGDP() {
    isLoading = true;
    calculate = forms.value['data'] ;
    if(forms.value['data'] >= 300) {
      title = "TERLALU TINGGI";
    } else if(forms.value['data'] >= 180) {
      title = "TINGGI";

    }else if(forms.value['data'] >= 80) {
      title = "NORMAL";
    }else if(forms.value['data'] < 80) {
      title = "RENDAH";
    }
    isLoading = false;
  }
  void onSubmitGDS() {}
  void increment() => count.value++;
}
