import 'package:get/get.dart';
import 'package:lazyui/lazyui.dart';
import 'package:simanis/app/core/utils/fetch.dart';
import 'package:simanis/app/data/models/profile_model.dart';
import 'package:simanis/app/data/services/api/api.dart';

class TntController extends GetxController {
  //TODO: Implement TntController
 AccountApi api = AccountApi();
 ProfileModel profile = ProfileModel();
 double bmi = 0.0;
 final forms = LzForm.make(['tall','weight','jk', 'activity', 'age']);
 
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
            required: ['*','kode_pos'],
            messages: FormMessages(required: {
              'jk': 'Masukkan jenis kelamin',
              'tall': 'Masukkan tinggi badan',
              'weight': 'Masukkan berat badan',
            }));


        if (form.ok) {
        final payload = {...form.value};
            if(payload['jk'] == 'Laki-laki'){
                bmi = 88.4 + (13.4 * double.parse(payload['weight'])) + (4.8 * double.parse(payload['tall'])) - (5.68 * double.parse(payload['age']));
            }else{
                bmi = 447.6 + (9.25 * double.parse(payload['weight'])) + (3.10 * double.parse(payload['tall'])) - (4.33 * double.parse(payload['age']));
            }
        }
      }catch (e, s) {
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