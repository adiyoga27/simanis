import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:lazyui/lazyui.dart';

class ArticleView extends StatelessWidget {
  const ArticleView({
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
    return
      Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title:  Text(title!),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
              child: Column(
                children: [
                  LzImage(image, radius: 0.0,),
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0, bottom: 8.0),
                    child: Textr(title!, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
                  ),
                  Padding(
                    padding: Ei.sym(v: 12.0, h: 10.0),
                    child: HtmlWidget(content!),
                  ),
            
                ],
              ),
          
      ),
    );
  }
}

