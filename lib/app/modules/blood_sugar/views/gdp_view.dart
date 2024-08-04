import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lazyui/lazyui.dart';
import 'package:simanis/app/modules/blood_sugar/controllers/blood_sugar_controller.dart';
import 'package:simanis/app/modules/blood_sugar/views/blood_sugar_view.dart';

class GdpView extends GetView<BloodSugarController> {
  const GdpView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Pemantauan Gula Darah Puasa'),
          centerTitle: true,
        ),
        body: Container(
          padding: Ei.all(15.0),
          child: ListView(
            children: [
              const Text(
                  "Silahkan pastikan anda lakukan pemeriksaan gula darah sebelum makan dan di Pagi Hari"),
              const SizedBox(
                height: 15.0,
              ),
              LzFormGroup(label: 'Tools Check', prefixIcon: La.user, children: [
                LzForm.input(
                    label: 'Indicator',
                    hint: 'Masukkan hasil check pada alat :',
                    model: controller.forms['data']),
              ]),
              LzButton(
                text: 'Daftar',
                onTap: (control) => controller.onSubmitGDP(),
              ).dark().style(LzButtonStyle.shadow, spacing: 20)
              // CardListBloodSugar(
              //   title: "Tutorial Cara Melakukan Cek Gula Darah Mandiri",
              //   onTap: () => Get.toNamed(Routes.WEBVIEW,
              //       arguments: Webview(
              //           title: 'Cara Melakukan Cek Gula Darah',
              //           url: 'https://flutter.dev')),
              // ),
            ],
          ),
        ));
  }
}
