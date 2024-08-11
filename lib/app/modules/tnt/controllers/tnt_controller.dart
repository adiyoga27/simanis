import 'package:get/get.dart';
import 'package:lazyui/lazyui.dart';
import 'package:simanis/app/core/utils/fetch.dart';
import 'package:simanis/app/data/models/profile_model.dart';
import 'package:simanis/app/data/services/api/api.dart';
import 'package:simanis/app/routes/app_pages.dart';

class TntController extends GetxController {
 AccountApi api = AccountApi();
 ProfileModel profile = ProfileModel();
 double bmi = 0.0;
 double kalori = 0.0;
 int age = 0;
 int tall = 0;
 String jk = '';
 String activity = '';
 String bmiNote = '';
 int weight = 0;
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
        age = int.parse(payload['age']);
        tall = int.parse(payload['tall']);
        weight = int.parse(payload['weight']);
        jk = payload['jk'];
            if(payload['jk'] == 'Laki-laki'){
                kalori = 88.4 + (13.4 * double.parse(payload['weight'])) + (4.8 * double.parse(payload['tall'])) - (5.68 * double.parse(payload['age']));
                bmi = (tall - 100) - ((tall - 100) * 0.1);

            }else{
                kalori = 447.6 + (9.25 * double.parse(payload['weight'])) + (3.10 * double.parse(payload['tall'])) - (4.33 * double.parse(payload['age']));
                bmi = (tall - 100) - ((tall - 100) * 0.15);


            }


            
              if(bmi > 28){
                bmiNote = 'Obesitas';
              }else if(bmi >= 25){
                bmiNote = 'Berat Berlebih';
              }else if(bmi >= 17){
                bmiNote = 'Berat Ideal';
              }else{
                bmiNote = 'Berat Rendah';
              }
            Get.toNamed(Routes.CHECK_TNM);
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