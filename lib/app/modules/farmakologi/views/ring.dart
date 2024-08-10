import 'package:alarm/alarm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lazyui/lazyui.dart';
import 'package:simanis/app/core/utils/toast.dart';

class ExampleAlarmRingScreen extends StatelessWidget {
  const ExampleAlarmRingScreen({required this.alarmSettings, super.key});

  final AlarmSettings alarmSettings;

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'You alarm (${alarmSettings.id}) is ringing...',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Text('🔔', style: TextStyle(fontSize: 50)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RawMaterialButton(
                  onPressed: () {
                    final now = DateTime.now();

                    firestore
                        .collection('alarms')
                        .where('alarm_id', isEqualTo: "${alarmSettings.id}")
                        .get()
                        .then((QuerySnapshot querySnapshot) {
                      if (querySnapshot.docs.isNotEmpty) {
                        // Mengambil dokumen pertama yang ditemukan
                        var doc = querySnapshot.docs.first;
                        var timeAt = DateTime(
                          now.year,
                          now.month,
                          now.day,
                          now.hour,
                          now.minute,
                        ).add(Duration(hours: 5));

                        // Mengupdate field 'time_at' dengan nilai baru
                        firestore.collection('alarms').doc(doc.id).update({
                          'date_at':
                              "${timeAt.year}-${timeAt.month}-${timeAt.hour}", // contoh, update
                          'time_at':
                              "${timeAt.hour}:${timeAt.minute}", // contoh, update dengan waktu sekarang
                        }).then((_) {
                          print("Field 'time_at' updated successfully");
                          Toasts.show(
                              "Alarm akan berbunyi kembali dalam kurun waktu 5 menit");
                          Alarm.set(
                            alarmSettings: alarmSettings.copyWith(
                              dateTime: timeAt,
                            ),
                          ).then((_) => Get.back());
                        }).catchError((error) {
                          print("Failed to update field: $error");
                          Toasts.show("Gagal setting alarm");
                        });
                      } else {
                        Toasts.show("Tidak ada dalam database");
                      }
                    }).catchError((error) {
                      print("Failed to get documents: $error");
                    });
                  },
                  child: Text(
                    'Snooze',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                RawMaterialButton(
                  onPressed: () async {
                    await Alarm.stop(alarmSettings.id).then((_) {
                      final now = DateTime.now();
                      firestore
                          .collection('alarms')
                          .where('alarm_id', isEqualTo: alarmSettings.id)
                          .get()
                          .then((QuerySnapshot querySnapshot) {
                        querySnapshot.docs.forEach((doc) {
                     
                     int duration = doc['duration'];

                          // Mengupdate field 'time_at' dengan nilai baru
                          var timeAt = DateTime(
                            now.year,
                            now.month,
                            now.day,
                            now.hour,
                            now.minute,
                          ).add(Duration(hours:  duration));
                          firestore.collection('alarms').doc(doc.id).update({
                            'date_at':
                                timeAt.format('yyyy-MM-dd'), // contoh, update
                            'time_at':
                                timeAt.format('kk:mm'), // contoh, update dengan waktu sekarang
                          }).then((_) {
                            Toasts.show(
                                "Alarm akan berbunyi kembali dalam kurun waktu $duration jam");

                            Alarm.set(
                              alarmSettings:
                                  alarmSettings.copyWith(dateTime: timeAt),
                            ).then((_) => Get.back());
                          }).catchError((error) {
                            Toasts.show("Gagal setting alarm");
                          });
                        });
                      });
                    });
                  },
                  child: Text(
                    'Stop',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
