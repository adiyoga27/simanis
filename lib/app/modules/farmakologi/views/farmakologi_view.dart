import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lazyui/lazyui.dart';

import '../controllers/farmakologi_controller.dart';

class FarmakologiView extends GetView<FarmakologiController> {
  const FarmakologiView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farmakologi'),
        centerTitle: true,
      ),
      body: Obx(() {
        bool isLoading = controller.isLoading.value;
        if (isLoading) {
          return LzLoader.bar(message: 'Sedang Memuat...');
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Obx(() {
                return Text(
                  controller.selectedTime != null
                      ? 'Alarm set for: ${controller.selectedTime!.hour}:${controller.selectedTime!.minute}'
                      : 'No alarm set',
                  style: TextStyle(fontSize: 20),
                );
              }),
              ElevatedButton(
                onPressed: () => _pickTime(context),
                child: const Text('Set Alarm'),
              ),
            ],
          ),
        );
      }),
    );
  }

  Future<void> _pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      final now = DateTime.now();
      final selectedTime =
          DateTime(now.year, now.month, now.day, picked.hour, picked.minute);

      controller.setAlarm(selectedTime);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Alarm set for ${picked.format(context)}')),
      );
    }
  }
}
