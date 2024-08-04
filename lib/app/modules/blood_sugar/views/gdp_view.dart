import 'package:flutter/material.dart';

import 'package:get/get.dart';

class GdpView extends GetView {
  const GdpView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GdpView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'GdpView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
