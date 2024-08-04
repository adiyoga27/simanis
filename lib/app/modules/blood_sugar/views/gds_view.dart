import 'package:flutter/material.dart';

import 'package:get/get.dart';

class GdsView extends GetView {
  const GdsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GdsView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'GdsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
