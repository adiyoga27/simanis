import 'package:get/get.dart';
import 'package:lazyui/lazyui.dart';
import 'package:simanis/app/data/models/user_model.dart';
import 'package:simanis/app/data/repository/storage/auth_storage.dart';
import 'package:simanis/app/modules/account/controllers/account_controller.dart';

class HomeController extends GetxController {
  RxBool isLoading = true.obs, animateLogo = false.obs;
  UserModel? user;

  // refresh home page
  Future initHomePage() async {
    isLoading(true);


    try {

   

      // get user details
      // await Get.find<AccountController>().getProfile();

      // set data user
      user = await Auth.user();

     
      update(['appbar']);

   
    } catch (e, s) {
      Errors.check(e, s);
    }

    isLoading(false);
  }
}
