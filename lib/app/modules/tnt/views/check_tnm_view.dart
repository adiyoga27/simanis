import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lazyui/lazyui.dart';

import '../controllers/tnt_controller.dart';

class CheckTNMView extends GetView<TntController> {
  const CheckTNMView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isLoading = controller.isLoading.value;

      if (isLoading) {
        return LzLoader.bar(message: 'Memuat TNM...');
      }
      return Wrapper(
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                title: const Text('HASIL TNM'),
                centerTitle: true,
              ),
              body: Column(
                  children: [
                    controller.bmi > 100 ? Text('Berat Badan Berlebih ${controller.bmi}') : Text('Berat Badan Normal ${controller.bmi}'),
                  ],
              )));
    });
  }
}
