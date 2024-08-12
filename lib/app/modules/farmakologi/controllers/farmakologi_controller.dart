import 'dart:async';
import 'dart:io';

import 'package:alarm/alarm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lazyui/lazyui.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simanis/app/core/utils/toast.dart';
import 'package:simanis/app/data/repository/firestore/fs_notification.dart';
import 'package:simanis/app/data/repository/storage/auth_storage.dart';
import 'package:simanis/app/modules/farmakologi/views/edit_alarm.dart';
import 'package:simanis/app/modules/farmakologi/views/ring.dart';

class FarmakologiController extends GetxController {
  late List<AlarmSettings> alarms;
  RxBool isLoading = false.obs;
  final forms =
      LzForm.make(['title', 'dosis', 'date_at', 'time_at', 'description']);
  late DateTime selectedDateTime;

  final _fireStore = FirebaseFirestore.instance;

  // static StreamSubscription<AlarmSettings>? subscription;

  StreamController<List<Map>> alarmStreamController =
      StreamController<List<Map>>.broadcast();
  Stream<List<Map>> get alarmList => alarmStreamController.stream;
  List<Map> alarm = [];

  @override
  void onInit() {
    if (Alarm.android) {
      checkAndroidNotificationPermission();
      checkAndroidScheduleExactAlarmPermission();
    }
    loadAlarms();
    getAlarms();
    // subscription ??= Alarm.ringStream.stream.listen(navigateToRingScreen);
    super.onInit();

  }

  @override
  void onClose() {
    super.onClose();
    alarmStreamController.close();
  }

  void onSubmit() async {
    isLoading.value = true;
    final form = LzForm.validate(forms,
        required: ['*', 'kode_pos'],
        messages: FormMessages(required: {
          'title': 'Wajib memberikan judul',
          'description': 'Deskripsi wajib diisi',
          'date_at': 'Masukkan tanggal waktu pertama minum obat',
          'time_at': 'Masukkan waktu pertama minum obat',
          'dosis': 'Masukkan dosis minum obat',
        }));

    if (form.ok) {
      final auth = await Auth.user();
      String dosis = form.value['dosis'];
      int hours = int.parse(form.value['time_at'].split(':')[0]);
      int minutes = int.parse(form.value['time_at'].split(':')[1]);
      int interval = int.parse(dosis.replaceAll(' Kali', ""));
      int duration = 24 ~/ interval;
      final id = DateTime.now().millisecondsSinceEpoch % 10000 + 1;
 
      final dateNow = DateTime.now();
      final dateInput = DateTime.parse(form.value['date_at']);
      final dateFormatter = DateFormat('yyyy-MM-dd');
      var startAt = dateInput.copyWith(
        hour: hours.toInt(),
        minute: minutes.toInt(),
        second: 0,
        millisecond: 0,
        microsecond: 0,
      );
      if (dateFormatter.format(dateInput).compareTo(dateFormatter.format(dateNow)) < 0) {
        // ignore: void_checks
         Toasts.show('Tanggal yang anda pilih sudah lewat, silahkan pilih waktu yang berikutnya.');
      }else if (hours <= dateNow.hour && minutes <= dateNow.minute) {
        // ignore: void_checks
         Toasts.show('Waktu yang anda pilih sudah lewat, silahkan pilih waktu yang berikutnya.');
      }else{

      Alarm.set(
          alarmSettings: AlarmSettings(
              id: id,
              dateTime: startAt,
              loopAudio: true,
              vibrate: true,
              volume: 1,
              assetAudioPath: 'assets/alarm.wav',
              notificationTitle: form.value['title'],
              // notificationBody: 'Your alarm ($id) is ringing, Ayoo minum obat!',
              notificationBody: 'Pengingat minum obat, Ayo Segera Minum Obat!',
              enableNotificationOnKill: Platform.isIOS));

      _fireStore.collection('alarms').add({
        'title': form.value['title'],
        'description': form.value['description'],
        'dosis': form.value['dosis'],
        'created_by': auth.username,
        'created_at': Timestamp.now(),
        'alarm_id': id,
        'date_at': form.value['date_at'],
        'time_at': form.value['time_at'],
        'duration': duration,
      });
    Get.back();

    }

    isLoading.value = false;
    // getAlarms();
    }
        isLoading.value = false;
    // getAlarms();
  }

  void onUpdate(int alarmID) async {
    isLoading.value = true;
    final form = LzForm.validate(forms,
        required: ['*', 'kode_pos'],
        messages: FormMessages(required: {
          'title': 'Wajib memberikan judul',
          'description': 'Deskripsi wajib diisi',
          'date_at': 'Masukkan tanggal waktu pertama minum obat',
          'time_at': 'Masukkan waktu pertama minum obat',
          'dosis': 'Masukkan dosis minum obat',
        }));

    if (form.ok) {
      final auth = await Auth.user();
      String dosis = form.value['dosis'];
      int hours = int.parse(form.value['time_at'].split(':')[0]);
      int minutes = int.parse(form.value['time_at'].split(':')[1]);
      int interval = int.parse(dosis.replaceAll(' Kali', ""));
      int duration = 24 ~/ interval;

      final id = DateTime.now().millisecondsSinceEpoch % 10000 + 1;

     
      final dateNow = DateTime.now();
      final dateInput = DateTime.parse(form.value['date_at']);
      final dateFormatter = DateFormat('yyyy-MM-dd');
      var startAt = dateInput.copyWith(
        hour: hours.toInt(),
        minute: minutes.toInt(),
        second: 0,
        millisecond: 0,
        microsecond: 0,
      );
   if (dateFormatter.format(dateInput).compareTo(dateFormatter.format(dateNow)) < 0) {
        // ignore: void_checks
        Toasts.show('Tanggal yang anda pilih sudah lewat, silahkan pilih waktu yang berikutnya.');
         isLoading.value = false;
      }else if (hours <= dateNow.hour && minutes <= dateNow.minute) {
        // ignore: void_checks
         Toasts.show('Waktu yang anda pilih sudah lewat, silahkan pilih waktu yang berikutnya.');
          isLoading.value = false;
      }else{
await Alarm.stop(alarmID).then((_) {
        _fireStore
            .collection('alarms')
            .where('alarm_id', isEqualTo: alarmID)
            .get()
            .then((QuerySnapshot querySnapshot) {
          // ignore: avoid_function_literals_in_foreach_calls
          querySnapshot.docs.forEach((doc) {

            // Mengupdate field 'time_at' dengan nilai baru

            _fireStore.collection('alarms').doc(doc.id).update({
              'title': form.value['title'],
              'description': form.value['description'],
              'dosis': form.value['dosis'],
              'created_by': auth.username,
              'created_at': Timestamp.now(),
              'alarm_id': id,
              'date_at': form.value['date_at'],
              'time_at': form.value['time_at'],
              'duration': duration,
            }).then((_) {
              Toasts.show(
                  "Alarm minum obat berhasil diupdate");

              Alarm.set(
                alarmSettings: AlarmSettings(
                    id: id,
                    dateTime: startAt,
                    loopAudio: true,
                    vibrate: true,
                    volume: 1,
                    assetAudioPath: 'assets/alarm.wav',
                    notificationTitle: form.value['title'],
                    notificationBody:
                        'Pengingat minum obat, Ayo Segera Minum Obat!',
                    enableNotificationOnKill: Platform.isIOS),
              );
            }).catchError((error) {
              Toasts.show("Gagal setting alarm");
            });
          });
        });
      });
      isLoading.value = false;
    Get.back();
    }
        
  }
  

      

    isLoading.value = false;
  }

  /* ----------------------------------------------------------
  | GET ALARMS LIST
  --------------------------------------------- */
  String? username;
  RxBool isLoadMore = false.obs;
  bool isMax = false;
  DocumentSnapshot? lastDoc;

  Future getAlarms({bool pagination = false}) async {
    isLoading.value = true;
    logg('Get Alarm');

    if (isLoadMore.value || isMax) return;
    isLoadMore.value = pagination;

    try {
      final auth = await Auth.user();
      username = auth.username;

      FsNotification.instance.listenToAlarms(auth.username!, (query) {
        query.listen(
          (e) {
            isMax = e.docs.isEmpty && pagination;

            if (e.docs.isEmpty && !pagination) return sink([]);

            // set last document (for pagination purpose)
            lastDoc = e.docs.last;

            // if data is not empty, listen to changes
            handleChanges(e);
          },
        );
      }, limit: 15, lastDocument: lastDoc);
    } catch (e, s) {
      Errors.check(e, s);
    }
    isLoading.value = false;

  }

  /* ----------------------------------------------------------
  | HANDLE NOTIFICATION CHANGES
  --------------------------------------------- */
  List ids = [];

  void handleChanges(QuerySnapshot<Object?> changes) {
    try {
      for (DocumentChange<Object?> change in changes.docChanges) {
        ids = alarm.map((e) => e['id']).toList();
        String id = change.doc.id;

        Map<String, dynamic> data = change.doc.data() as Map<String, dynamic>;

        // List<Map> grouping(List<Map> list) {
        //   return list.groupBy('created_by', wrap: (data) {
        //     return [...data];
        //   }, groupKey: 'created_at');
        // }

        switch (change.type) {
          case DocumentChangeType.added:

            // periksa jika id sudah ada
            if (!ids.contains(id)) {
              ids.add(id);
              data['id'] = id;

              alarm.add(data);
              // data['created_at'] =
              //     DateTime.fromMillisecondsSinceEpoch(data['timestamp'])
              //         .format();

              List<Map> group = alarm;
              sink(group);
            }

            break;

          case DocumentChangeType.modified:
            int io = alarm.indexWhere((e) => e['id'] == id);
            if (io != -1) {
              Map<String, dynamic> data =
                  change.doc.data() as Map<String, dynamic>;
              alarm[io]['read_by'] = data['read_by'];
              alarm[io]['time_at'] = data['time_at'];
              alarm[io]['date_at'] = data['date_at'];
              alarm[io]['dosis'] = data['dosis'];
              alarm[io]['title'] = data['title'];

              List<Map> group = alarm;
              sink(group);
            }

            break;

          default:
            alarm.removeWhere((e) => e['id'] == id);
            sink(alarm);
            break;
        }
      }
    } catch (e, s) {
      Errors.check(e, s);
    }
  }

  void sink(List<Map> values) {
    if (!alarmStreamController.isClosed) alarmStreamController.sink.add(values);
  }

  void loadAlarms() {
    // Fetching alarms from the server or local storage here
    isLoading.value = true;
    alarms = Alarm.getAlarms();
    alarms.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);
    isLoading.value = false;
  }

  Future<void> navigateToRingScreen(AlarmSettings alarmSettings) async {
    await Get.to(ExampleAlarmRingScreen(
      alarmSettings: alarmSettings,
    ));

    loadAlarms();
    getAlarms();

    // Navigator.push(
    //   context,
    //   MaterialPageRoute<void>(
    //     builder: (context) =>
    //         ExampleAlarmRingScreen(alarmSettings: alarmSettings),
    //   ),
    // );
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
    // subscription?.cancel();
    super.dispose();
  }
}
