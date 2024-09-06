import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:lazyui/lazyui.dart';
import 'package:simanis/app/modules/farmakologi/controllers/farmakologi_controller.dart';
import 'package:simanis/app/routes/app_pages.dart';

class FarmakologiView extends GetView<FarmakologiController> {
  const FarmakologiView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Farmakologi')),
      body:  Column(
        children: [
           const Center(
              child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'NOTE',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
          )),
          Padding(
            padding:  EdgeInsets.all(14.0),
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HtmlWidget(
                  
                textStyle: gfont.copyWith(fontSize: 16.0),
                '''
<p style="font-weight: bold; text-align: justify;"><strong>1. Obat tablet (oral)</strong></p>
<ul>
    <li style="text-align: justify;">Pemberian 3x (jarak minum obat 8 jam dari jam pertama minum obat)</li>
    <li style="text-align: justify;">Pemeberian 2x (jarak minum obat 12 jam dari jam pertama minum obat)</li>
    <li style="text-align: justify;">Pemberian 1x (jarak minum obat 24 jam dari jam pertama minum obat)</li>
</ul>
<p style="text-align: justify; font-weight: bold;"><strong>2. Obat suntik insulin (injeksi)</strong></p>
<ul>
    <li style="text-align: justify;">Insulin bolus (3x suntik) diberikan 3x sehari disesuaikan dengan jam sesaat sebelum makan.</li>
    <li style="text-align: justify; ">Insulin basal (1x suntik) diberikan 1x sehari disesuaikan dengan kondisi masing masing orang, biasa diberikan malam hari pada jam 21.00 – 22.00.</li>
</ul>
<p style="text-align: justify;">Catatan : Dosis obat disesuaikan dengan saran dokter</p>
'''),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: LzButton(
        text: 'Check Jadwal Obat',
        onTap: (control) => Get.toNamed(Routes.CHECK_JADWAL),
      ).dark().style(LzButtonStyle.shadow, spacing: 20),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
