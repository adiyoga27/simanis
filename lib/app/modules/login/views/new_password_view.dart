import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lazyui/lazyui.dart' hide Errors;
import 'package:simanis/app/core/values/colors.dart';
import 'package:simanis/app/core/values/value.dart';
import 'package:simanis/app/modules/login/controllers/login_controller.dart';
import 'package:simanis/app/ui/widgets/widget.dart';
import 'package:simanis/app/widgets/widget.dart';

class NewPasswordView extends GetView<LoginController> {
  const NewPasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => LoginController());
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
                          const LzImage('logo.png',
                                  size: 90, fit: BoxFit.contain)
                              .margin(b: 45),
                          CustomBottomSheet(
                            padding: Ei.all(20),
                            child: Col(
                              children: [
                                Col(
                                  children: [
                                    Text(
                                      'New Password',
                                      style: Gfont.fs17.bold,
                                    ),
                                    Textr(
                                      'Silakan buat password baru anda ...',
                                      margin: Ei.only(b: 25, t: 5),
                                      style: Gfont.muted,
                                    ),
                                    LzFormGroup(
                                      keepLabel: true,
                                      children: [
                                    
                                        LzForm.input(
                                          label: 'Password Baru',
                                          hint: 'Password Baru',
                                          keyboard: Tit.text,
                                          autofocus: true,
                                          model:
                                              controller.npForms['password'],
                                        ),
                                          LzForm.input(
                                            label: 'Konfirmasi Password',
                                          hint: 'Ulangi Password Baru',
                                          keyboard: Tit.text,
                                          autofocus: true,
                                          model:
                                              controller.npForms['confirm_password'],
                                        ),
                                      ],
                                    ),
                                    Center(
                                      child: LzButton(
                                              text: 'Reset Password',
                                              padding: Ei.sym(v: 10, h: 30),
                                              onTap: (state) {
                                                controller.requestResetPassword(state);
                                              })
                                          .dark(),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )

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
