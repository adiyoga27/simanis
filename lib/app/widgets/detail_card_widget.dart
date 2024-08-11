
import 'package:flutter/material.dart';
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

