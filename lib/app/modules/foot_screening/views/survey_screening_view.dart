import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lazyui/lazyui.dart';

import '../controllers/foot_screening_controller.dart';

class SurveyScreeningView extends GetView<FootScreeningController> {
  const SurveyScreeningView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final forms = controller.forms;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Screening Kaki'),
        centerTitle: true,
      ),
      body: LzFormList(
        style: LzFormStyle(activeColor: LzColors.dark),
        children: [
          LzFormGroup(
            label: "Sensasi terbakar, mati rasa, ataupun tajam pada kaki *",
            labelStyle:
                const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            children: [
              LzForm.radio(
                  options: ['YA', 'TIDAK']
                      .generate((data, i) => Option(option: data)),
                  model: forms['sensasi_terbakar']),
            ],
          ),
          LzFormGroup(
            label:
                "Sensasi sentuhan pada telapak kaki menggunakan ujung pena/pensil (tampilkan telapak kaki dan titik sensasi) *",
            labelStyle:
                const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            children: [
              LzForm.radio(
                  options: ['YA', 'TIDAK']
                      .generate((data, i) => Option(option: data)),
                  model: forms['sensasi_sentuhan']),
            ],
          ),
          LzFormGroup(
            label:
                "Nyeri saat malam hari atau istirahat pada kaki kanan dan kiri (Sering kesentuhan nyeri kaki saat istirahat) *",
            labelStyle:
                const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            children: [
              LzForm.radio(
                  options: ['YA', 'TIDAK']
                      .generate((data, i) => Option(option: data)),
                  model: forms['pulsasi_nyeri']),
            ],
          ),
          LzFormGroup(
            label: "Kaki terasa dingin *",
            labelStyle:
                const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            children: [
              LzForm.radio(
                  options: ['YA', 'TIDAK']
                      .generate((data, i) => Option(option: data)),
                  model: forms['pulsasi_kaki']),
            ],
          ),
          LzFormGroup(
            label:
                "Pemeriksaan nadi pada dorsalis pedis dan tibial posterior kaki kanan dan kaki kiri (Penurunan denyut nadi arteri dorsalis pedis, tibialis dan poplitea) *",
            labelStyle:
                const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            children: [
              LzForm.radio(
                  options: ['YA', 'TIDAK']
                      .generate((data, i) => Option(option: data)),
                  model: forms['pulsasi_pemeriksaan']),
            ],
          ),
          LzFormGroup(
            label: "Kulit kering dan pecah - pecah *",
            labelStyle:
                const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            children: [
              LzForm.radio(
                  options: ['YA', 'TIDAK']
                      .generate((data, i) => Option(option: data)),
                  model: forms['bentuk_kulit']),
            ],
          ),
          LzFormGroup(
            label: "Kapalan dan kuku kaki menebal *",
            labelStyle:
                const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            children: [
              LzForm.radio(
                  options: ['YA', 'TIDAK']
                      .generate((data, i) => Option(option: data)),
                  model: forms['bentuk_kapalan']),
            ],
          ),
          LzFormGroup(
            label: "Bentuk kaki berubah (cantumkan bentuk kaki diabetes) *",
            labelStyle:
                const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            children: [
              LzForm.radio(
                  options: ['YA', 'TIDAK']
                      .generate((data, i) => Option(option: data)),
                  model: forms['bentuk_kaki']),
            ],
          ),
        ],
      ),
      bottomNavigationBar: LzButton(
        text: 'Check',
        onTap: (control) {
          controller.onSubmit();
        },
      ).dark().style(LzButtonStyle.shadow, spacing: 20),
    );
  }
}
