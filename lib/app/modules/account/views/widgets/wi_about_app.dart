part of '../account.dart';


class WiAboutApp extends StatelessWidget {
  const WiAboutApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String appDescription = ''' kami memahami betapa pentingnya menjaga kesehatan Anda secara menyeluruh. Aplikasi kami dirancang khusus untuk membantu Anda mengelola diabetes dengan mudah dan efektif .
''';

    String galkaIconUrl = 'solusiindo.png';
    String galkaUrl = 'https://www.indoapps.id';

    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: Br.radiusOnly(tl: 3, tr: 3)),
      child: Stack(
        children: [
          Column(
            mainAxisSize: Mas.min,
            children: [
              Col(
                children: [
                  Container(
                    constraints: BoxConstraints(maxHeight: Get.height * 0.7),
                    child: SingleChildScrollView(
                      padding: Ei.all(20),
                      physics: BounceScroll(),
                      child: Col(
                        children: [
                          const LzImage(
                            'logo.png',
                            fit: BoxFit.contain,
                          ).margin(v: 35),
                          RichText(
                              text: TextSpan(text: 'Simanis,', style: Gfont.bold, children: [
                            TextSpan(text: appDescription, style: Gfont.normal),
                          ])),
                          Textr('#ayosehat', style: Gfont.muted, margin: Ei.only(t: 25)),
                          Textr('v${AppConfig.version} ${AppConfig.buildDate}', style: Gfont.muted, margin: Ei.only(t: 5)),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: Ei.sym(v: 15, h: 20),
                    margin: Ei.all(20),
                    decoration: BoxDecoration(border: Br.all(color: Colors.blueAccent), borderRadius: Br.radius(5)),
                    child: Touch(
                      onTap: () => Helpers.goto(galkaUrl),
                      child: Col(
                        children: [
                          Row(
                            children: [
                              LzImage(
                                galkaIconUrl,
                                size: 25,
                              ).margin(r: 10),
                              RichText(
                                  text: TextSpan(text: 'Developed by ', style: Gfont.normal, children: [
                                TextSpan(text: 'Indo Apps Solusindo', style: Gfont.bold),
                              ])),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
          Positioned.fill(
              child: Align(
            alignment: Alignment.topRight,
            child: Touch(
              child: Iconr(
                La.times,
                padding: Ei.all(20),
              ),
              onTap: () => Get.back(),
            ),
          ))
        ],
      ),
    );
  }
}
