part of account;

class WiAboutApp extends StatelessWidget {
  const WiAboutApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String appDescription = '''
merupakan aplikasi berbasis mobile yang dibuat untuk memudahkan semua reseller dalam melakukan proses belanja produk, kontrol jaringan, dll. Adanya aplikasi ini diharapkan dapat membantu semua reseller untuk semakin tumbuh dan berkembang bersama Varash.
''';

    String galkaIconUrl = 'https://galkasoft.id/wp-content/uploads/elementor/thumbs/image-1-prcv4dq55z29cspaxaknlxr85m4mdqrm52ymq7w00w.png';
    String galkaUrl = 'https://galkasoft.id';

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
                              text: TextSpan(text: 'Varash App ', style: Gfont.bold, children: [
                            TextSpan(text: appDescription, style: Gfont.normal),
                          ])),
                          Textr('#sehatkayabahagia', style: Gfont.muted, margin: Ei.only(t: 25)),
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
                                TextSpan(text: 'Galkasoft', style: Gfont.bold),
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
