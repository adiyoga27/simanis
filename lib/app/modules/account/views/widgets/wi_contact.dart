part of account;

class WiContact extends StatelessWidget {
  const WiContact({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> labels = ['Alamat', 'No. Telepon', 'Email', 'Website'],
        values = [
          'Jalan. Ahmad Yani Utara, Gang Sriti No. 88, Kel. Peguyangan, Kec. Denpasar Utara, Kota Denpasar, Bali 80115.',
          '+62 3619 0083 84',
          'varashsaddannusantara@gmail.com',
          'https://saddannusantara.com/'
        ];

    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: Br.radiusOnly(tl: 3, tr: 3)),
      child: Stack(
        children: [
          Column(
            mainAxisSize: Mas.min,
            children: [
              Col(
                children: [
                  Textr(
                    'Kontak Kami',
                    style: Gfont.fs20,
                    margin: Ei.all(20),
                  ),
                  Container(
                    constraints: BoxConstraints(maxHeight: Get.height * 0.7),
                    child: SingleChildScrollView(
                      physics: BounceScroll(),
                      child: Col(
                        children: List.generate(labels.length, (i) {
                          List<String> links = ['tel:+623619008384', 'mailto:itvarash@gmail.com', 'https://saddannusantara.com/'];

                          return InkTouch(
                            onTap: () {
                              if (i == 0) {
                                Helpers.openMap(-8.639872, 115.191442);
                              } else {
                                Helpers.goto(links[i - 1]);
                              }
                            },
                            padding: Ei.all(20),
                            border: Br.only([i == 0 ? '' : 't']),
                            child: Row(
                              mainAxisAlignment: Maa.spaceBetween,
                              children: [
                                Flexible(
                                  child: Col(children: [
                                    Text(labels[i]),
                                    Textr(values[i], margin: Ei.only(t: 5), style: Gfont.muted.copyWith(fontSize: 15)),
                                  ]),
                                ),
                                Iconr(La.angleRight, color: Colors.black45, margin: Ei.only(l: 15))
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
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
