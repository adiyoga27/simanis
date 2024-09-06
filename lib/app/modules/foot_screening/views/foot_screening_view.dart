import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import 'package:get/get.dart';
import 'package:lazyui/lazyui.dart';
import 'package:simanis/app/routes/app_pages.dart';
import 'package:widget_zoom/widget_zoom.dart';

import '../controllers/foot_screening_controller.dart';

class FootScreeningView extends GetView<FootScreeningController> {
  const FootScreeningView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final forms = controller.forms;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Screening Kaki'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          color: Colors.white30,
          child: ListView(
            children: [
              Center(
                child: WidgetZoom(
                  heroAnimationTag: 'tag',
          zoomWidget: const LzImage(
                    height: 360.0,
                  fit: BoxFit.fitWidth,
                    'sk.png',
                  )
                  .lz
                  .border(Br.all(), radius: Br.radius(5)),
                )
              ),
              const SizedBox(height: 10.0,),

               HtmlWidget(
                textStyle: gfont.copyWith(fontSize: 16.0),
                '<p style="text-align: justify; ">Beberapa hal yang bisa diperhatikan saat melakukan deteksi dini kelainan kaki seperti :</p><ul><li style="text-align: justify;">Kulit kaku yang kering, bersisik, dan retak-retak serta kaku</li><li style="text-align: justify;">Rambut kaki yang menipis</li><li style="text-align: justify;">Kelainan bentuk dan warna kuku (kuku yang menebal, rapuh, ingrowing nail).</li><li style="text-align: justify; ">Kalus (mata ikan) terutama di bagian telapak kaki.</li><li style="text-align: justify;">Perubahan bentuk jari-jari dan telapak kaki dan tulang-tulang kaki yang menonjol.</li><li style="text-align: justify;">Bekas luka atau riwayat amputasi jari-jari.</li><li style="text-align: justify;">Kaki baal, kesemutan, atau tidak terasa nyeri.</li><li style="text-align: justify;">Kaki yang terasa dingin</li><li style="text-align: justify;">Perubahan warna kulit kaki (kemerahan, kebiruan, atau kehitaman</li></ul><p style="text-align: justify;">Harus diperhatikan kaki diabetik dengan ulkus merupakan komplikasi yang sering terjadi. Biasanya luka tersebut berada di daerah bawah pergelangan kaki.</p>'
              ),
              const SizedBox(height: 100.0,)
            ],
          ),
        ),
      ),
      bottomNavigationBar: LzButton(
        text: 'Check Kaki Anda',
        onTap: (control) =>Get.toNamed(Routes.SURVEY_SCREENING),
      ).dark().style(LzButtonStyle.shadow, spacing: 20),
    );
  }
}
