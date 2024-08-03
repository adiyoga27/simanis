import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import 'package:get/get.dart';
import 'package:lazyui/lazyui.dart';
import 'package:simanis/app/core/values/colors.dart';
import 'package:simanis/app/widgets/detail_card_widget.dart';
import 'package:simanis/app/widgets/widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../controllers/physical_training_controller.dart';

class PhysicalTrainingView extends GetView<PhysicalTrainingController> {
  const PhysicalTrainingView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Latihan Fisik'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Fetcher(
              onInit: controller.getData,
              onLoading: () => LzLoader.bar(message: 'Memuat informasi...'),
              onData: (control) {
                return Refreshtor(
                  onRefresh: () => control.refresh(),
                  child: LzListView(
                    physics: BounceScroll(),
                    padding: Ei.only(b: 100, others: 20),
                    children: List.generate(controller.data.length, (i) {
                      final data = controller.data;
          
                      final info = data[i];
          
                      String? title = info.title.orIf();
                      String? image = info.image.orIf();
                      String? content = info.content.orIf();
          
                      return DetailCardWidget(content: content, image: image, title: title);
                    }),
                  ),
                );
              }),
        ],
      ),
    );
  }
}

