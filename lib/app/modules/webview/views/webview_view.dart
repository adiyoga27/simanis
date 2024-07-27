import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:lazyui/lazyui.dart' hide Errors;
import 'package:simanis/app/widgets/widget.dart';

import '../controllers/webview_controller.dart';

class WebviewView extends GetView<WebviewController> {
  const WebviewView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    InAppWebViewController? webViewController;

    Webview? args = Get.arguments is Webview
        ? Get.arguments
        : Webview(url: 'https://www.google.com', title: 'Google');

    String? title = args?.title;
    String url = args?.url ?? 'https://www.google.com';
    Map<String, String>? header =
        args?.header ?? {'Authorization': 'Bearer ${args?.token}'};

    Widget body = CustomWebView(
      url: url,
      headers: header,
      onWebViewCreated: (InAppWebViewController webviewController) {
        webViewController = webviewController;
        controller.isLoading.value = true;
      },
      onProgressChanged: (_, progress) {
        controller.isLoading.value = (progress / 100) < 1.0;
      },
    );

    final key = GlobalKey();

    return WillPopScope(
        onWillPop: () => CustomWebView.goBack(webViewController),
        child: title == null
            ? Scaffold(body: body)
            : Scaffold(
                appBar: AppBar(
                  title: Text(title),
                  centerTitle: true,
                  leading: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => CustomWebView.goBack(webViewController)),
                  actions: [
                    IconButton(
                      icon: Icon(La.bars, key: key),
                      onPressed: () {
                        DropX.show(key, useCaret: false,
                            options: ['Reload'].options(icons: [La.redoAlt]),
                            onSelect: (value) {
                          if (value.index == 0) {
                            controller.isLoading.value = true;
                            webViewController?.reload();
                          }
                        });
                      },
                    )
                  ],
                ),
                body: Obx(() {
                  bool isLoading = controller.isLoading.value;

                  return Stack(
                    children: [
                      isLoading
                          ? const Center(child: Text('Memuat halaman...'))
                          : const None(),
                      body
                    ],
                  );
                })));
  }
}

class Webview {
  final String? title;
  final String? url;
  final String? token;
  final Map<String, String>? header;

  Webview({this.title, this.url, this.token, this.header});
}
