import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:get/get.dart';
import 'package:lazyui/lazyui.dart';
import 'package:simanis/app/core/utils/toast.dart';
import 'package:simanis/app/modules/farmakologi/views/shortcut_button.dart';
import 'package:simanis/app/modules/farmakologi/views/widgets/tile.dart';

import '../controllers/farmakologi_controller.dart';

class FarmakologiView extends GetView<FarmakologiController> {
  const FarmakologiView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final forms = controller.forms;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Farmakologi')),
      body: Obx(() {
        bool isLoading = controller.isLoading.value;

        if (isLoading) {
          return LzLoader.bar(message: 'Sedang Memuat...');
        }
        // return StreamBuilder(stream: stream, builder: builder)
        return SizedBox();
      }),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ExampleAlarmHomeShortcutButton(
                refreshAlarms: controller.loadAlarms),
            FloatingActionButton(
              // onPressed: () => controller.navigateToAlarmScreen(null),
              onPressed: () {
                Get.dialog(
                  name: "Tambah Jadwal Obat",
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: InkWell(
                      onTap: () => Get.back(),
                      child: ListView(
                        children: [
                          LzFormGroup(
                            keepLabel: true,
                            label: 'Kesehatan *',
                            prefixIcon: La.userTie,
                            children: [
                              LzForm.input(
                                labelStyle: const LzFormLabelStyle(
                                    fontWeight: FontWeight.bold),
                                label: 'Judul *',
                                hint: 'Berikan judul tentang obat ....',
                                model: forms['title'],
                              ),
                              LzForm.input(
                                labelStyle: const LzFormLabelStyle(
                                    fontWeight: FontWeight.bold),
                                label: 'Deskripsi *',
                                hint: 'Tuliskan deskripsi tentang obat....',
                                model: forms['description'],
                              ),
                              LzForm.select(
                                  labelStyle: const LzFormLabelStyle(
                                      fontWeight: FontWeight.bold),
                                  label: 'Dosis Perhari *',
                                  initValue: const Option(option: '1 Kali'),
                                  options: [
                                    '1 Kali',
                                    '2 Kali',
                                    '3 Kali',
                                    '4 Kali'
                                  ].generate((data, i) => Option(option: data)),
                                  model: forms['dosis']),
                              LzForm.input(
                                  label: 'Waktu Mulai *',
                                  hint: 'Masukkan waktu dimulainya minum obat ',
                                  model: controller.forms['start_at'],
                                  suffixIcon: La.calendar,
                                  onTap: (model) {
                                    LzPicker.timePicker(
                                      context,
                                      initialDate: DateTime.now(),
                                      minDate: DateTime(2024),
                                    ).then((value) {
                                      logg(value);
                                      if (value != null) {
                                        model.text = value.format('kk:mm');
                                      }
                                    });
                                  }),
                            ],
                          ),
                          LzButton(
                            text: 'Simpan',
                            onTap: (control) {
                              controller.onSubmit();
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Center(
                                child: Text(
                              'Tutup',
                              style: TextStyle(color: Colors.white),
                            )),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },

              child: const Icon(Icons.alarm_add_rounded, size: 33),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
