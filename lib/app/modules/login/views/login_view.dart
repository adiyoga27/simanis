import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lazyui/lazyui.dart' hide Errors;
import 'package:simanis/app/core/values/colors.dart';
import 'package:simanis/app/core/values/value.dart';
import 'package:simanis/app/routes/app_pages.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
Get.lazyPut(()=>LoginController());
    // controller.forms.fill({'username': 'adiyoga27', 'password': 'Adiyoga1996'});

    return Wrapper(
      child: Scaffold(
        body: Stack(
          children: [
            LzImage(
              'people-login-bg.png',
              width: Get.width,
              height: Get.height,
              radius: 0,
            ),
            Column(
              children: [
                Expanded(
                  child: Center(
                      child: SizedBox(
                    width: 330,
                    child: SingleChildScrollView(
                      controller: controller.scrollController,
                      physics: BounceScroll(),
                      padding: Ei.sym(v: 25, h: 15),
                      child: Column(
                        mainAxisAlignment: Maa.center,
                        children: [
                          const LzImage('logo.png', size: 90, fit: BoxFit.contain).margin(b: 45),
                          LzFormGroup(
                            children: [
                              LzForm.input(label: 'Username', hint: 'Masukkan Username', model: controller.forms['username']),
                              LzForm.input(label: 'Password', hint: 'Masukkan password', obsecureToggle: true, model: controller.forms['password']),
                            ],
                          ),
                          LzButton(
                            color: AppColor.border,
                            textColor: Colors.white,
                            text: 'MASUK',
                            onTap: (state) => controller.login(state),
                            outline: false,
                          ).sized(Get.width),
                     
                             Padding(
                               padding:  Ei.only(l:25.0, r: 25.0, t: 5.0),
                               child: LzButton(
                                
                                                           color: const Color.fromARGB(195, 255, 52, 52),
                                                           textColor: Colors.white,
                                                           text: 'DAFTAR BARU',
                                                           onTap: (state) => Get.toNamed(Routes.REGISTRATION),
                                                           outline: false,
                                                         ).sized(Get.width),
                             ),
                          // Touch(
                          //     onTap: () {
                          //       Get.bottomSheet(const ForgetPasswordView()).then((value) {
                          //         if (value != null) {
                          //           // String phone = value['phone'] ?? '';
                          //           // String username = value['username'] ?? '';

                          //           // OtpView.open(
                          //           //     otpLength: 4,
                          //           //     title: 'Verifikasi Kode OTP',
                          //           //     message: 'Kode OTP telah dikirim ke nomor $phone',
                          //           //     onFilled: (String otp) async {
                          //           //       bool ok = await controller.verifyOtp(otp, username);
                          //           //       if (ok) {
                          //           //         Get.back();
                          //           //       } else {
                          //           //         OtpView.reset();
                          //           //       }
                          //           //     });
                          //         }
                          //       });
                          //     },
                          //     child: Textr('Lupa kata sandi?', style: Gfont.fbold(true), padding: Ei.all(15),)),
                        ],
                      ),
                    ),
                  )),
                ),
                MediaQuery.of(context).viewInsets.bottom > 0
                    ? const None()
                    : Center(
                        child: Column(
                          mainAxisSize: Mas.min,
                          children: [
                            Text('v$version', style: Gfont.fs14.white),
                          ],
                        ),
                      ).margin(v: 15)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
