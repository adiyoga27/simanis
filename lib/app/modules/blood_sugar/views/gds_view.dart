import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lazyui/lazyui.dart';
import 'package:simanis/app/modules/blood_sugar/controllers/blood_sugar_controller.dart';

class GdsView extends GetView<BloodSugarController> {
  const GdsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Check Gula Darah Sewaktu'),
          centerTitle: true,
        ),
        body: Container(
          padding: Ei.all(15.0),
          child: ListView(
            children: [
              const Text(
                  "Silahkan pastikan anda lakukan pemeriksaan gula darah 1-2 Jam Setelah Makan"),
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
                text: 'Check',
                onTap: (control) => controller.onSubmitGDS(),
              ).dark().style(LzButtonStyle.shadow, spacing: 20),
              Container(
                decoration:  BoxDecoration(
                        border: Br.all(color: Colors.black12),
                        borderRadius: Br.radius(LazyUi.radius))
                ,
                child: Column(
                  children: [
                    Text("Check ke rumah sakit")
                  ],
                ).lz.clip(all: LazyUi.radius),
              )
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
