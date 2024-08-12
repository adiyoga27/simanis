import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import 'package:get/get.dart';
import 'package:lazyui/lazyui.dart';
import 'package:simanis/app/routes/app_pages.dart';

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
        padding: const EdgeInsets.all(10.0),
        child: Container(
          color: Colors.white,
          child: ListView(
            children: [
               HtmlWidget(
                '<p style="text-align: justify; ">Deteksi dini kelainan kaki pada pasien diabetes dapat dilakukan dengan penilaian karakteristik:</p><ul><li style="text-align: justify; ">Kulit kaku yang kering, bersisik dan retak-retak serta kaku</li><li style="text-align: justify; ">Rambut kaki yang menipis</li><li style="text-align: justify; ">Kelainan bentuk dan warna kuku (kuku yang menebal, rapuh, ingrowing nail)</li><li style="text-align: justify; ">Kalus (mata ikan) terutama dibagian kelapak kaki</li><li style="text-align: justify; ">Perubahan bentuk jari-jari dan telapak kaki tulang-tulang kaki yang menonjol</li><li style="text-align: justify; ">Bekas luka atau riwayat amputasi jari-jari</li><li style="text-align: justify; ">Kaki baal, kesemutan atau terasa nyeri</li><li style="text-align: justify; ">Kaki yang terasa dingin</li><li style="text-align: justify; ">Perubahan warna kulit kaki (kemerahan, kebiruan atau kehitaman)</li></ul><p style="text-align: justify; ">Kaki diabetik dengan ulkus merupakan komplikasi diabetes yang sering terjadi. Ulkus kaki diabetik adalah luka kronik pada daerah di bawah pergelangan kaki</p>'
              ),
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
