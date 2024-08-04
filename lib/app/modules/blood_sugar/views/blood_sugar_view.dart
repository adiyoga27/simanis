import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lazyui/lazyui.dart';
import 'package:simanis/app/modules/webview/views/webview_view.dart';
import 'package:simanis/app/routes/app_pages.dart';
import 'package:simanis/app/widgets/widget.dart';

import '../controllers/blood_sugar_controller.dart';

class BloodSugarView extends GetView<BloodSugarController> {
  const BloodSugarView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Pemantauan Gula Darah'),
          centerTitle: true,
        ),
        body: Container(
          padding: Ei.all(15.0),
          child: ListView(
            children: [
              const Text(
                  "Cek gulah darah mandiri bisa dilakukan oleh penyandang DM atau keluraga yang sudah mendapat edukasi dari petugas kesehatan. Lakukan cek gula darah mandiri jika merasakan beberapa gejala seperti : lemas, pusing, keringat dingin, gemetar, sesak, bau nafas kurang sedap, penglihatan kabur, dada berdebar-debar"),
              const SizedBox(
                height: 15.0,
              ),
              CardListBloodSugar(
                title: "Tutorial Cara Melakukan Cek Gula Darah Mandiri",
                onTap: () => Get.toNamed(Routes.WEBVIEW,
                    arguments: Webview(
                        title: 'Cara Melakukan Cek Gula Darah',
                        url: 'https://flutter.dev')),
              ),
              CardListBloodSugar(
                title: "Check Gula Darah Puasa (GDP)",
                onTap: () => Get.toNamed(
                  Routes.GDP,
                ),
              ),
              CardListBloodSugar(
                title: "Check Gula Darah Sewaktu (GDS)",
                onTap: () => Get.toNamed(Routes.GDS),
              ),
            ],
          ),
        ));
  }
}

class CardListBloodSugar extends StatelessWidget {
  final String? title;
  final Function()? onTap;
  const CardListBloodSugar({super.key, this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkTouch(
      onTap: onTap,
      color: Colors.white,
      padding: Ei.all(20),
      border: Br.all(),
      radius: Br.radius(5),
      margin: Ei.only(b: 10),
      child: Row(
        children: [
          const Icon(Icons.arrow_right_alt, size: 30),
          const SizedBox(width: 10),
          Flexible(
            child: Col(
              children: [
                Text(title!),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
