import 'package:flutter/material.dart';

import 'package:get/get.dart';

class DetailPhysicalTrainingView extends GetView {
  const DetailPhysicalTrainingView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DetailPhysicalTrainingView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'DetailPhysicalTrainingView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
