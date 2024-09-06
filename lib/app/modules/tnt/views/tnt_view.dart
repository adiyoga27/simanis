import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lazyui/lazyui.dart';

import '../controllers/tnt_controller.dart';

class TntView extends GetView<TntController> {
  const TntView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final forms = controller.forms;
    return Obx(() {
      bool isLoading = controller.isLoading.value;

      if (isLoading) {
        return LzLoader.bar(message: 'Memuat Nutrisi...');
      }
      return Wrapper(
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                title: const Text('Nutrisi'),
                centerTitle: true,
              ),
              body: LzFormList(
                  style: LzFormStyle(activeColor: LzColors.dark),
                  children: [
                    Container(
                      padding: Ei.all(18.0),
                      color: Colors.yellow.shade100,
                      child: const Text(
                          "Jumlah kalori yang diberikan paling sedikit 1000-1200 kal perhari untuk wanita dan 1200-1600 kal perhari untuk pria"),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    LzFormGroup(
                      keepLabel: true,
                      labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                      label: 'Form Check',
                      prefixIcon: La.userTie,
                      children: [
                        LzForm.radio(
                            label: 'Jenis Kelamin *',
                            options: ['Laki-laki', 'Perempuan']
                                .generate((data, i) => Option(option: data)),
                            model: forms['jk']),
                        LzForm.input(
                            label: 'Tinggi Badan *',
                            hint: 'Masukkan nama tinggi badan anda ....',
                            model: forms['tall']),
                        LzForm.input(
                            label: 'Berat Badan *',
                            hint: 'Masukkan nama berat badan anda ....',
                            model: forms['weight']),
                        LzForm.input(
                            label: 'Umur *',
                            hint: 'Masukkan umur anda ....',
                            model: forms['age']),
                        LzForm.select(
                            label: 'Berat Badan Saat ini *',
                            options: [
                              'Gemuk',
                              'Kurus',
                            ].generate((data, i) => Option(option: data)),
                            model: forms['status_weight']),
                        LzForm.select(
                            label: 'Aktivitas Fisik *',
                            options: [
                              'Istirahat',
                              'Aktivitas Ringan (Kantor, Guru, Ibu Rumah Tangga)',
                              'Aktivitas Sedang (Pegawai Industri, Mahasiswa, Militer TIdak Berperang)',
                              'Aktivitas Berat (petani, buruh, atlet, militer berperang)',
                              'Aktivitas Sangat Berat (Tukang Becak, Tukang Gali)'
                            ].generate((data, i) => Option(option: data)),
                            model: forms['activity']),
                      ],
                    ),
                    LzButton(
                      text: 'Check',
                      onTap: (control) async { 
                        controller.check();
                      },
                    ).dark().style(LzButtonStyle.shadow),
                  ])));
    });
  }
}
