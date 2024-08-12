
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lazyui/lazyui.dart';
import 'package:simanis/app/modules/blood_sugar/views/blood_sugar_view.dart';
import 'package:simanis/app/modules/webview/views/webview_view.dart';
import 'package:simanis/app/routes/app_pages.dart';

class AlertShowingDialogWidget extends StatelessWidget {
  final String? type;
  final String? title;
  final String? message;
  final String? link;
  const AlertShowingDialogWidget({
    super.key,
   this.type, this.title, this.message, this.link,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(top: Get.height * 0.3,bottom: Get.height * 0.3, left: 10.0, right: 10.0),
      child: Container(
        height: Get.height * 0.4,
              decoration: BoxDecoration(
        color: type == 'warning' ? Colors.yellow[100] : type == 'good' ? Colors.green[100] : Colors.red[100],
        border: Br.all(color: Colors.black12),
        borderRadius: Br.radius(LazyUi.radius)),
              child: Padding(
      padding: const EdgeInsets.only(
          top: 25.0, bottom: 25.0, left: 10.0, right: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
           LzImage(
             '$type.png',
            size: 50,
          ),
          Padding(
            padding: Ei.only(t: 10.0, b: 10.0),
            child: Text(
              title!,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 23.0),
            ),
          ),
           Text(
            "$message",
            style: TextStyle(fontSize: 15.0),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 10.0,
          ),
          type == 'warning' ? CardListBloodSugar(
            title: "Tutorial Cara Perawatan Hipoglekimia",
            onTap: () => Get.toNamed(Routes.WEBVIEW,
                arguments: Webview(
                    title: 'Tutorial Cara Perawatan Hipoglekimia',
                    url: 'https://simanis.codingaja.com/recomendasi-foot')),
          ) : const SizedBox(height: 1.0,),
        ],
      ),
              ),
            ),
    );
  }
}
