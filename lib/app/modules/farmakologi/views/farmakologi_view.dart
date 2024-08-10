import 'package:alarm/alarm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:get/get.dart';
import 'package:lazyui/lazyui.dart';
import 'package:simanis/app/core/utils/toast.dart';
import 'package:simanis/app/modules/farmakologi/views/shortcut_button.dart';
import 'package:simanis/app/modules/farmakologi/views/widgets/tile.dart';
import 'package:simanis/app/widgets/widget.dart';

import '../controllers/farmakologi_controller.dart';

class FarmakologiView extends GetView<FarmakologiController> {
  const FarmakologiView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final forms = controller.forms;
    final _fireStore = FirebaseFirestore.instance;
    return Scaffold(
      appBar: AppBar(title: const Text('Farmakologi')),
      body: Obx(() {
        bool isLoading = controller.isLoading.value;

        if (isLoading) {
          return LzLoader.bar(message: 'Sedang Memuat...');
        }
        return StreamBuilder(
            stream: controller.alarmList,
            builder: (context, AsyncSnapshot<List<Map>> snapshot) {
              List<Map> docs = snapshot.data ?? [];
              // if connection is waiting
              if (snapshot.connectionState == ConnectionState.waiting) {
                return LzLoader.bar(message: 'Memuat alarm...');
              }

              // if there is no notification
              else if (!snapshot.hasData || docs.isEmpty) {
                return const LzNoData(
                    message: 'Tidak Ada Jadwal Obat Yang disetting.');
              }
              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  Map data = docs[index];

                  return Touch(
                    onTap: () {
                      forms.fill({
                        'alarm_id': data['alarm_id'],
                        'title': data['title'],
                        'description': data['description'],
                        'date_at': data['date_at'],
                        'dosis': data['dosis'],
                        'time_at': data['time_at'],
                      });
                      // show dialog to edit alarm data
                      Get.dialog(
                        name: "Edit Jadwal Obat",
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
                                      hint:
                                          'Tuliskan deskripsi tentang obat....',
                                      model: forms['description'],
                                    ),
                                    LzForm.select(
                                        labelStyle: const LzFormLabelStyle(
                                            fontWeight: FontWeight.bold),
                                        label: 'Dosis Perhari *',
                                        initValue:
                                            const Option(option: '1 Kali'),
                                        options: [
                                          '1 Kali',
                                          '2 Kali',
                                          '3 Kali',
                                          '4 Kali'
                                        ].generate(
                                            (data, i) => Option(option: data)),
                                        model: forms['dosis']),
                                    LzForm.input(
                                        labelStyle: const LzFormLabelStyle(
                                            fontWeight: FontWeight.bold),
                                        label: 'Tanggal Mulai *',
                                        hint:
                                            'Tanggal waktu dimulainya minum obat ',
                                        model: controller.forms['date_at'],
                                        suffixIcon: La.calendar,
                                        onTap: (model) {
                                          LzPicker.datePicker(
                                            context,
                                            initialDate: DateTime.now(),
                                            minDate: DateTime(2024),
                                          ).then((value) {
                                            if (value != null) {
                                              model.text =
                                                  value.format('yyyy-MM-dd');
                                            }
                                          });
                                        }),
                                    LzForm.input(
                                        labelStyle: const LzFormLabelStyle(
                                            fontWeight: FontWeight.bold),
                                        label: 'Waktu Mulai *',
                                        hint:
                                            'Masukkan waktu dimulainya minum obat ',
                                        model: controller.forms['time_at'],
                                        suffixIcon: La.calendar,
                                        onTap: (model) {
                                          LzPicker.timePicker(
                                            context,
                                            initialDate: DateTime.now(),
                                            minDate: DateTime(2024),
                                          ).then((value) {
                                            logg(value);
                                            if (value != null) {
                                              model.text =
                                                  value.format('kk:mm');
                                            }
                                          });
                                        }),
                                  ],
                                ),
                                LzButton(
                                  text: 'Ubah',
                                  onTap: (control) {
                                    controller.onUpdate(data['alarm_id']);
                                  },
                                ),
                                Padding(
                                  padding: Ei.sym(v: 10.0, h: 25.0),
                                  child: LzButton(
                                    color: Colors.red,
                                    textColor: Colors.white,
                                    text: 'Hapus',
                                    onTap: (control) async {
                                      logg(data['alarm_id']);
                                      await Alarm.stop(data['alarm_id'])
                                          .then((_) {
                                        logg(
                                            "success berhasil mengubah jadwal obat");

                                        FirebaseFirestore firestore =
                                            FirebaseFirestore.instance;

                                        firestore
                                            .collection('alarms')
                                            .where('alarm_id',
                                                isEqualTo: data['alarm_id'])
                                            .get()
                                            .then(
                                                (QuerySnapshot querySnapshot) {
                                          querySnapshot.docs.forEach((doc) {
                                            logg(doc);

                                            // Menghapus dokumen yang ditemukan
                                            firestore
                                                .collection('alarms')
                                                .doc(doc.id)
                                                .delete()
                                                .then((_) {
                                              Toasts.show(
                                                  "Berhasil Menghapus Jadwal Obat");
                                              logg(
                                                  "Document with id ${doc.id} deleted");

                                              Get.back();
                                            }).catchError((error) {
                                              logg(
                                                  "Failed to delete document: $error");
                                            });
                                          });
                                        });
                                      });
                                    },
                                  ),
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
                    child: Padding(
                      padding: Ei.sym(h: 15),
                      child: Card(
                        color: Colors.white,
                        child: Padding(
                          padding: Ei.sym(h: 18.0, v: 20.0),
                          child: Row(
                            children: [
                              Flexible(
                                child: Col(
                                  children: [
                                    Row(
                                      mainAxisAlignment: Maa.spaceBetween,
                                      children: [
                                        Text(
                                          data['title'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin: Ei.only(t: 5),
                                      child: Row(
                                        mainAxisAlignment: Maa.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              data['description'],
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: Gfont.muted,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Textr(DateTime.parse(data['date_at']).format('dd MMMM yyyy'),
                                      style: Gfont.fs(15.0), margin: Ei.only()),
                                  Textr(data['time_at'],
                                      style: Gfont.fs(15.0), margin: Ei.only()),
                                ],
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            });
        // return StreamBuilder(stream: stream, builder: builder)
      }),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ExampleAlarmHomeShortcutButton(
                refreshAlarms: controller.loadAlarms),
            FloatingActionButton(
              backgroundColor: Colors.white,
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
                                  labelStyle: const LzFormLabelStyle(
                                      fontWeight: FontWeight.bold),
                                  label: 'Tanggal Mulai *',
                                  hint: 'Tanggal waktu dimulainya minum obat ',
                                  model: controller.forms['date_at'],
                                  suffixIcon: La.calendar,
                                  onTap: (model) {
                                    LzPicker.datePicker(
                                      context,
                                      initialDate: DateTime.now(),
                                      minDate: DateTime(2024),
                                    ).then((value) {
                                      if (value != null) {
                                        model.text = value.format('yyyy-MM-dd');
                                      }
                                    });
                                  }),
                              LzForm.input(
                                  labelStyle: const LzFormLabelStyle(
                                      fontWeight: FontWeight.bold),
                                  label: 'Waktu Mulai *',
                                  hint: 'Masukkan waktu dimulainya minum obat ',
                                  model: controller.forms['time_at'],
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

              child: const Icon(Icons.alarm_add_rounded, size: 25),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
