import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/app_intro_controller.dart';

class AppIntroView extends GetView<AppIntroController> {
  const AppIntroView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AppIntroView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'AppIntroView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
