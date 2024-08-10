
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:lazyui/lazyui.dart';
import 'package:simanis/app/widgets/article_view.dart';
import 'package:simanis/app/widgets/widget.dart';

class DetailCardWidget extends StatelessWidget {
  const DetailCardWidget({
    super.key,
    required this.content,
    required this.image,
    required this.title,
  });

  final String? content;
  final String? image;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return InkTouch(
      onTap: () => Get.to(ArticleView(content: content, image: image, title: title)),
      // {
      //   // Helpers.bottomSheet(InformationDetailView(info));
      //   context.dialog(
      //     SingleChildScrollView(
      //       child: Column(
      //         children: [
      //           Container(
                  
      //               width: 350,
      //               margin: Ei.only(l: 5, r: 5),
      //               decoration: BoxDecoration(
      //                   color: Colors.white, borderRadius: Br.radius(7)),
      //               child: Padding(
      //                 padding: const EdgeInsets.all(12.0),
      //                 child: HtmlWidget(content!),
      //               )),
      //           InkWell(
      //             onTap: ()=>Get.back(),
      //             child: Textr('Tutup',
      //                     style: Gfont.white.bold.copyWith(letterSpacing: 3),
      //                     margin: Ei.only(t: 15, b: 10.0))
      //                 .lz
      //                 .ignore(),
      //           )
      //         ],
      //       ),
      //     )
      //   );
      // },
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
                Text(title!.ucwords),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

