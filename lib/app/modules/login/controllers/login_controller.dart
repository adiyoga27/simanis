import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lazyui/lazyui.dart';
import 'package:simanis/app/core/utils/fetch.dart';
import 'package:simanis/app/core/utils/toast.dart';
import 'package:simanis/app/data/repository/api/api.dart';
import 'package:simanis/app/data/repository/api/response_handler.dart';
import 'package:simanis/app/data/services/storage/storage.dart';
import 'package:simanis/app/modules/home/controllers/home_controller.dart';
import 'package:simanis/app/routes/app_pages.dart';
import 'package:simanis/app/widgets/forms/forms.dart';
import 'package:simanis/app/widgets/pad.dart';

class LoginController extends GetxController {
  final forms = LzForm.make(['username', 'password']);
  // Map<String, TextEditingController> forms = Forms.create(['username', 'password']);
  // Map<String, FocusNode> nodes = Forms.createNodes(['username', 'password']);
  String email = "";
  // obsecure password
  RxBool isObsecure = true.obs;

  // set obsecure password
  void setObsecure() {
    isObsecure.value = !isObsecure.value;
  }

  // login with username and password
  Future login(LzButtonControl state) async {
    try {
      final form = LzForm.validate(forms,
          required: ['*'],
          messages: FormMessages(required: {
            'username': 'Masukkan ID member',
            'password': 'Masukkan password',
          }));

      if (form.ok) {
        state.submit();
        ResponseHandler res = await AuthService.login(form.value);

        if (res.code == 403) {
          final payload = {...form.value};
          payload['email'] = res.data?['email'];

          Get.dialog(LzConfirm(
            title: "Verifikasi Email Anda !",
            message:
                "Silahkan check email ${res.data['email']} kotak masuk atau spam email anda !!!",
            confirmText: "Kirim Ulang Verifikasi",
            cancelText: "Batal",
            onConfirm: () async {
              ResponseHandler res = await AuthService.verifyEmail(payload);
              if (res.status) {
                Toasts.show(res.message);
              }
            },
          ));
          return;
        }

        if (res.status) {
          Map<String, dynamic> data = res.data;

          // save data user to local storage
          await storage.write('user', data);

          // subscribe to topic by username, and all
          if (res.data?['username'] != null) {
            // await FbMessaging.subscribeTopic([res.data['username'], 'all']);
          }

          String token = res.data['access_token'];
          dio.options.headers['authorization'] = 'Bearer $token';
          dio2.setToken(token);

          storage.write('token', token);

          Get.offAllNamed(Routes.HOME);
        } else {
          Toasts.show(res.message);
        }
      }
    } on FirebaseException catch (e, s) {
      Errors.check(e, s);
    } catch (e, s) {
      Errors.check(e, s);
    } finally {
      state.abort();
    }
  }

  /* -------------------------------------------------------------------------- 
  | FORGET PASSWORD
  | -------------------------------------------------- */
  // OtpApi otpApi = OtpApi();
  // Map<String, TextEditingController> fpForms = Forms.create(['username']);

  // Future<bool> verifyOtp(String otp, String username) async {
  //   bool ok = false;

  //   try {
  //     Toasts.overlay('Memverifikasi...');
  //     // ResHandler res = await otpApi.verify2(username, otp);
  //     // Toasts.dismiss();

  //     // if (!res.status) {
  //     //   return Toasts.show(res.message);
  //     // }

  //     // ok = true;
  //     // Toasts.show('Password berhasil direset, silakan cek SMS atau Whatsapp Anda');
  //     // Toasts.show(res.message ?? 'Berhasil memverifikasi, periksa whatsapp Anda');
  //   } catch (e, s) {
  //     Errors.check(e, s);
  //   }

  //   return ok;
  // }

  /* --------------------------------------------------------------------------
  | LOGOUT
  | -------------------------------------------------- */

  Future logout() async {
    try {
      Toasts.overlay('Logging out...');
      // remove user data from local storage
      await Storage.remove(only: ['token', 'user']);

      // unsubscribe to topic by username, and all
      // await FbMessaging.unsubscribeTopic(['${auth.idmember}', 'all']);

      Timer(1.s, () {
        Toasts.dismiss();

        Get.delete<HomeController>();

        // back to login page
        Get.offAndToNamed(Routes.LOGIN);
      });
    } catch (e, s) {
      Errors.check(e, s);
    }
  }

  /* -------------------------------------------------------------------------- 
  | SCROLL BEHAVIOUR
  | -------------------------------------------------- */

  ScrollController scrollController = ScrollController();

  void scrollBehavior() {
    double pixel = scrollController.position.pixels;

    if (Utils.scrollHasMax(scrollController, [20, 40])) {
      scrollController.animateTo(pixel,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInBack);
    }
  }

  @override
  void onInit() {
    super.onInit();
    openAppIntro();
    scrollController.addListener(scrollBehavior);
  }

  /* -------------------------------------------------------------------------- 
  | OPEN APP INTRO
  | */

  void openAppIntro() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      bool hadIntro = storage.read('guide_app_intro') ?? false;

      if (!hadIntro) {
        Get.toNamed(Routes.APPINTRO)
            ?.then((value) => storage.write('guide_app_intro', true));
      }
    });
  }

  /* -------------------------------------------------------------------------- 
  | FORGET PASSWORD
  | -------------------------------------------------- */
  final fpForms = LzForm.make(['email']);

  int failedAttempt = 0;

  Future requestOtp(LzButtonControl state) async {
    try {
      final form = fpForms.validate(required: ['*']);

      if (!form.ok) {
        return LzToast.show('Masukkan Email');
      }
      LzToast.overlay('Mengirim kode OTP...');

      failedAttempt = 0;
      ResponseHandler res = await AuthService.requestOtp(fpForms.value);

      LzToast.dismiss();
      email = res.data?['email'] ?? '';

      if (!res.status) {
        return LzToast.show(res.message ?? 'Terjadi kesalahan');
      }

      LzPad.show(Get.context!,
          expired: 5.m,
          title: 'Verifikasi Kode OTP',
          subtitle:
              'Silakan masukkan kode OTP yang kami kirimkan ke nomor $email untuk dapat mengganti password.',
          onCompleted: (otp) async {
        otp.pause();
        logg({'email': form.value['email'], 'otp': otp.value});
        final ok =
            await verifyOTP({'email': form.value['email'], 'otp': otp.value});

        if (ok) {
          Get.toNamed(Routes.NEW_PASSWORD);
        } else {
          failedAttempt++;
          otp.reset().resume();

          if (failedAttempt >= 3) {
            LzToast.show(
                'Anda telah melebihi batas percobaan sebanyak 3 kali, silakan coba lagi nanti.',
                duration: 5.s);
            failedAttempt = 0;
            Get.back();
            return;
          }
        }
      });
    } catch (e, s) {
      Errors.check(e, s);
    }
  }

  Future<bool> verifyOTP(Map<String, dynamic> payload) async {
    try {
      LzToast.overlay('Memverifikasi...');
      // final res = await api.account.verifyOTPForgetPassword(payload);
      ResponseHandler res = await AuthService.verifyOTPForgetPassword(payload);

      if (res.status) {
        Toasts.show("OTP Berhasil terverifikasi, silakan reset Password Anda");
        Get.back();
      } else {
        LzToast.show(res.message);
      }

      return res.status;
    } catch (e, s) {
      Errors.check(e, s);
    } finally {
      LzToast.dismiss();
    }

    return false;
  }

  final npForms = LzForm.make(['password', 'confirm_password']);

  Future requestResetPassword(LzButtonControl state) async {
    try {
      final form = npForms.validate(required: ['*']);

      if (!form.ok) {
        return LzToast.show('Wajib masukkan password dan email');
      }

      ResponseHandler res = await AuthService.verifyNewPassword({'password': form.value['password'], 'confirm_password': form.value['confirm_password'], 'email': email});

      if (res.status) {
        LzToast.show(res.message);
        Get.offAllNamed(Routes.LOGIN);

      } else {
        LzToast.show(res.message);
      }
    } catch (e, s) {
      Errors.check(e, s);
    }
  }
}
