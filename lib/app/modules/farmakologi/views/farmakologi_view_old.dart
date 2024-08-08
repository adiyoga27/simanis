import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lazyui/lazyui.dart';
import 'package:simanis/app/modules/farmakologi/views/shortcut_button.dart';
import 'package:simanis/app/modules/farmakologi/views/widgets/tile.dart';

import '../controllers/farmakologi_controller.dart';

class FarmakologiView extends GetView<FarmakologiController> {
  const FarmakologiView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   return Scaffold(
    backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Farmakologi')),
      body: Obx(() {
        bool isLoading = controller.isLoading.value;

          if (isLoading) {
            return LzLoader.bar(message: 'Sedang Memuat...');
          }
          return SafeArea(
            child: controller.alarms.isNotEmpty
                ? ListView.separated(
                    itemCount: controller.alarms.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      return ExampleAlarmTile(
                        key: Key(controller.alarms[index].id.toString()),
                        title: TimeOfDay(
                          hour: controller.alarms[index].dateTime.hour,
                          minute: controller.alarms[index].dateTime.minute,
                        ).format(context),
                        onPressed: () => controller.navigateToAlarmScreen(controller.alarms[index]),
                        onDismissed: () {
                          Alarm.stop(controller.alarms[index].id).then((_) => controller.loadAlarms());
                        },
                      );
                    },
                  )
                : Center(
                    child: Text(
                      'No alarms set',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
          );
        }
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ExampleAlarmHomeShortcutButton(refreshAlarms: controller.loadAlarms),
            FloatingActionButton(
              onPressed: () => controller.navigateToAlarmScreen(null),
              child: const Icon(Icons.alarm_add_rounded, size: 33),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
  

   
}
