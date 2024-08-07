import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lazyui/lazyui.dart';
import 'package:simanis/app/widgets/detail_card_widget.dart';
import 'package:simanis/app/widgets/widget.dart';

import '../controllers/foot_care_controller.dart';

class FootCareView extends GetView<FootCareController> {
  const FootCareView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Perawatan Kaki'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Fetcher(
              onInit: controller.getData,
              onLoading: () => LzLoader.bar(message: 'Memuat informasi...'),
              onData: (control) {
                   final data = controller.data;

                 if (data.isEmpty) {
                  return LzNoData(
                    message: 'Tidak ada data apapun',
                    onTap: () => control.refresh(),
                  );
                }
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
