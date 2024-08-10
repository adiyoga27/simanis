import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lazyui/lazyui.dart';
import 'package:simanis/app/modules/blood_sugar/controllers/blood_sugar_controller.dart';
import 'package:simanis/app/modules/blood_sugar/views/blood_sugar_view.dart';
import 'package:simanis/app/modules/webview/views/webview_view.dart';
import 'package:simanis/app/routes/app_pages.dart';

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
        body: Obx(() {
          bool isLoading = controller.isLoading.value;

          if (isLoading) {
            return LzLoader.bar(message: 'Sedang Memuat...');
          }
          return Container(
            padding: Ei.all(15.0),
            child: ListView(
              children: [
                const Text(
                    "Silahkan pastikan anda lakukan pemeriksaan gula darah sebelum makan dan di Pagi Hari"),
                const SizedBox(
                  height: 15.0,
                ),
                LzFormGroup(
                    label: 'Tools Check',
                    prefixIcon: La.user,
                    children: [
                      LzForm.input(
                          label: 'Indicator',
                          hint: 'Masukkan hasil check pada alat :',
                          model: controller.forms['data']),
                    ]),
                LzButton(
                  text: 'Check',
                  onTap: (control) => controller.onSubmitGDP(),
                ).dark().style(LzButtonStyle.shadow, spacing: 20),
                !controller.isSubmit.value
                    ? const SizedBox(
                        height: 10.0,
                      )
                    : StatusGulaDarahWidget(
                        title: controller.title,
                        calculate: controller.calculate),

                // CardListBloodSugar(
                //   title: "Tutorial Cara Melakukan Cek Gula Darah Mandiri",
                //   onTap: () => Get.toNamed(Routes.WEBVIEW,
                //       arguments: Webview(
                //           title: 'Cara Melakukan Cek Gula Darah',
                //           url: 'https://flutter.dev')),
                // ),
              ],
            ),
          );
        }));
  }
}

class StatusGulaDarahWidget extends StatelessWidget {
  final String? title;
  final int calculate;

  const StatusGulaDarahWidget({
    super.key,
    required this.title,
    this.calculate = 0,
  });

  @override
  Widget build(BuildContext context) {
    if (calculate >= 300) {
      return Container(
        decoration: BoxDecoration(
            color: Colors.red[100],
            border: Br.all(color: Colors.black12),
            borderRadius: Br.radius(LazyUi.radius)),
        child: Padding(
          padding: const EdgeInsets.only(
              top: 20.0, bottom: 20.0, left: 10.0, right: 10.0),
          child: Column(
            children: [
              const LzImage(
                'close.png',
                size: 50,
              ),
              Padding(
                padding: Ei.only(t: 8.0, b: 8.0),
                child: Text(
                  title!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const Text(
                "Silahkan mencari rumah sakit terdekat di lokasi anda !!!",
                textAlign: TextAlign.center,
              ),
            ],
          ).lz.clip(all: LazyUi.radius),
        ),
      );
    } else if (calculate >= 130) {
      return Container(
        decoration: BoxDecoration(
            color: Colors.yellow[100],
            border: Br.all(color: Colors.black12),
            borderRadius: Br.radius(LazyUi.radius)),
        child: Padding(
          padding: const EdgeInsets.only(
              top: 25.0, bottom: 25.0, left: 10.0, right: 10.0),
          child: Column(
            children: [
              const LzImage(
                'warning.png',
                size: 50,
              ),
              Padding(
                padding: Ei.only(t: 8.0, b: 8.0),
                child: Text(
                  title!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              const Text(
                "Tes Gula Darah Puasa anda memasuki gejala hiperglikemia. Silahkan lakukan perawatan hiperglikemia",
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10.0,
              ),
              CardListBloodSugar(
                title: "Tutorial Cara Perawatan Hiperglikemia",
                onTap: () => Get.toNamed(Routes.WEBVIEW,
                    arguments: Webview(
                        title: 'Tutorial Cara Perawatan Hiperglikemia',
                        url: 'https://simanis.codingaja.my.id/tutorial-cara-perawatan-hiperglikemia')),
              ),
            ],
          ).lz.clip(all: LazyUi.radius),
        ),
      );
    } else if (calculate >= 80) {
      return Container(
        decoration: BoxDecoration(
            color: Colors.green[100],
            border: Br.all(color: Colors.black12),
            borderRadius: Br.radius(LazyUi.radius)),
        child: Padding(
          padding: const EdgeInsets.only(
              top: 25.0, bottom: 25.0, left: 10.0, right: 10.0),
          child: Column(
            children: [
              const LzImage(
                'good.png',
                size: 50,
              ),
              Padding(
                padding: Ei.only(t: 8.0, b: 8.0),
                child: Text(
                  title!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const Text(
                "Hasil tes gula darah normal, tetap jaga kesehatan",
                textAlign: TextAlign.center,
              ),
            ],
          ).lz.clip(all: LazyUi.radius),
        ),
      );
    } else if (calculate >= 70) {
      return Container(
        decoration: BoxDecoration(
            color: Colors.yellow[100],
            border: Br.all(color: Colors.black12),
            borderRadius: Br.radius(LazyUi.radius)),
        child: Padding(
          padding: const EdgeInsets.only(
              top: 25.0, bottom: 25.0, left: 10.0, right: 10.0),
          child: Column(
            children: [
              const LzImage(
                'warning.png',
                size: 50,
              ),
              Padding(
                padding: Ei.only(t: 8.0, b: 8.0),
                child: Text(
                  title!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const Text(
                "Tes Gula Darah Puasa anda memasuki gejala hipoglekimia. Silahkan lakukan perawatan hipoglekimia",
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10.0,
              ),
              CardListBloodSugar(
                title: "Tutorial Cara Perawatan Hipoglekimia",
                onTap: () => Get.toNamed(Routes.WEBVIEW,
                    arguments: Webview(
                        title: 'Tutorial Cara Perawatan Hipoglekimia',
                        url: 'https://simanis.codingaja.my.id/tutorial-cara-perawatan-hipoglekimia')),
              ),
            ],
          ).lz.clip(all: LazyUi.radius),
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
            color: Colors.red[100],
            border: Br.all(color: Colors.black12),
            borderRadius: Br.radius(LazyUi.radius)),
        child: Padding(
          padding: const EdgeInsets.only(
              top: 20.0, bottom: 20.0, left: 10.0, right: 10.0),
          child: Column(
            children: [
              const LzImage(
                'close.png',
                size: 50,
              ),
              Padding(
                padding: Ei.only(t: 8.0, b: 8.0),
                child: Text(
                  title!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const Text(
                "Silahkan mencari rumah sakit terdekat di lokasi anda !!!",
                textAlign: TextAlign.center,
              ),
            ],
          ).lz.clip(all: LazyUi.radius),
        ),
      );
    }

  }
}
