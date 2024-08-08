import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:lazyui/lazyui.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simanis/app/data/repository/firestore/fs_notification.dart';
import 'package:simanis/app/data/repository/storage/auth_storage.dart';
import 'package:simanis/app/modules/farmakologi/views/edit_alarm.dart';
import 'package:simanis/app/modules/farmakologi/views/ring.dart';

class FarmakologiController extends GetxController {
    late List<AlarmSettings> alarms;
    RxBool isLoading = false.obs;
      final forms = LzForm.make([
      'title', 'dosis','start_at','description']);
      
 final _fireStore = FirebaseFirestore.instance;


  static StreamSubscription<AlarmSettings>? subscription;

@override
  void onInit() {
    super.onInit();
    if (Alarm.android) {
      checkAndroidNotificationPermission();
      checkAndroidScheduleExactAlarmPermission();
    }
    loadAlarms();
    subscription ??= Alarm.ringStream.stream.listen(navigateToRingScreen);

  }

void onSubmit() async {
  isLoading.value = true;
   final form = LzForm.validate(forms,
          required: ['*','kode_pos'],
          messages: FormMessages(required: {
            'title': 'Wajib memberikan judul',
            'description': 'Deskripsi wajib diisi',
            'start_at': 'Masukkan jam waktu pertama minum obat',
            'dosis': 'Masukkan dosis minum obat',
           

          }));


      if (form.ok) {
        final auth = await Auth.user();
        _fireStore.collection('todo').add({
                              'title': form.value['title'],
                              'description': form.value['description'],
                              'start_at': form.value['start_at'],
                              'dosis': form.value['dosis'],
                              'create_by': auth.username,
                              'alarm_id' : [],
                              'created': Timestamp.now(),
                            });
      }

  isLoading.value = false;
}














 void loadAlarms() {
   // Fetching alarms from the server or local storage here
    isLoading.value = true;
      alarms = Alarm.getAlarms();
      alarms.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);
    isLoading.value = false;

  }

  Future<void> navigateToRingScreen(AlarmSettings alarmSettings) async {
    await  Get.to(ExampleAlarmRingScreen(alarmSettings: alarmSettings,));
    
    
    // Navigator.push(
    //   context,
    //   MaterialPageRoute<void>(
    //     builder: (context) =>
    //         ExampleAlarmRingScreen(alarmSettings: alarmSettings),
    //   ),
    // );
    loadAlarms();
  }

  Future<void> navigateToAlarmScreen(AlarmSettings? settings) async {
    isLoading.value = true;
    
  final res = await Get.bottomSheet<bool?>(
    backgroundColor: Colors.white,
    FractionallySizedBox(
      heightFactor: 0.75,
      child: ExampleAlarmEditScreen(alarmSettings: settings),
    ),
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );

  if (res != null && res == true) loadAlarms();
    isLoading.value = false;

  }

  Future<void> checkAndroidNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isDenied) {
      alarmPrint('Requesting notification permission...');
      final res = await Permission.notification.request();
      alarmPrint(
        'Notification permission ${res.isGranted ? '' : 'not '}granted',
      );
    }
  }

  Future<void> checkAndroidExternalStoragePermission() async {
    final status = await Permission.storage.status;
    if (status.isDenied) {
      alarmPrint('Requesting external storage permission...');
      final res = await Permission.storage.request();
      alarmPrint(
        'External storage permission ${res.isGranted ? '' : 'not'} granted',
      );
    }
  }

  Future<void> checkAndroidScheduleExactAlarmPermission() async {
    final status = await Permission.scheduleExactAlarm.status;
    alarmPrint('Schedule exact alarm permission: $status.');
    if (status.isDenied) {
      alarmPrint('Requesting schedule exact alarm permission...');
      final res = await Permission.scheduleExactAlarm.request();
      alarmPrint(
        'Schedule exact alarm permission ${res.isGranted ? '' : 'not'} granted',
      );
    }
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }
}
