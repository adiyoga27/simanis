import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import 'package:get/get.dart';
import 'package:lazyui/lazyui.dart';
import 'package:simanis/app/core/values/colors.dart';
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
                  onRefresh: () => controller.getCategory(),
                  child: LzListView(
                    physics: BounceScroll(),
                    padding: Ei.only(b: 100, others: 20),
                    children: List.generate(controller.data.length, (i) {
                      final data = controller.data;
          
                      final info = data[i];
          
                      String? title = info.title.orIf();
                      String? image = info.image.orIf();
                      String? content = info.content.orIf();
          
                      return InkTouch(
                        onTap: () {
                          // Helpers.bottomSheet(InformationDetailView(info));
                          context.dialog(
                            Column(
                              children: [
                                const SizedBox(height: 100.0,),
                                Container(
                                    width: 350,
                                    margin: Ei.only(b: 7),
                                    decoration: BoxDecoration(
                                        color: Colors.white, borderRadius: Br.radius(7)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: HtmlWidget(content),
                                    )),
                                Textr('Tutup',
                                        style: Gfont.white.bold.copyWith(letterSpacing: 3),
                                        margin: Ei.only(t: 15))
                                    .lz
                                    .ignore()
                              ],
                            )
                          );
                        },
                        color: Colors.white,
                        padding: Ei.all(20),
                        border: Br.all(),
                        radius: Br.radius(5),
                        margin: Ei.only(b: 10),
                        child: Row(
                          children: [
                            LzImage(
                              image,
                              radius: 5,
                              size: 70,
                            )
                                .lz
                                .border(Br.all(), radius: Br.radius(5))
                                .margin(r: 15),
                            Flexible(
                              child: Col(
                                children: [
                                  Text(title.ucwords),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                );
              }),
        ],
      ),
    );
  }
}


