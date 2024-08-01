import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:get/get.dart';
import 'package:lazyui/lazyui.dart';
import 'package:simanis/app/core/values/value.dart';

import '../controllers/app_intro_controller.dart';

class AppIntroView extends GetView<AppIntroController> {
  const AppIntroView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // List<String> labels = ['Belanja Poin', 'Rekrut Member', 'Invoice'];
    // List<String> descriptions = [
    //   'Dapatkan poin setiap belanja yang dapat Anda tukarkan dengan berbagai produk lainnya.',
    //   'Memungkinkan Anda untuk merekrut orang lain menjadi anggota jaringan Anda dan membantu meningkatkan penjualan produk atau layanan perusahaan.',
    //   'Kelola tagihan dan pembayaran dengan mudah dan cepat.'
    // ];

    // List<String> icons = ['non-point.svg', 'data-member.svg', 'invoice.svg'];
    List<String> images = [
      'intro1.png',
      'intro2.png',
      'intro3.png',
      'intro4.png'
    ];
    List<String> labels = [
      'Selamat Datang di Varash!',
      'Promo Belanja!',
      'Semua Bisa Menjadi Nyata!',
      'Tunggu Apalagi?'
    ];
    List<String> descriptions = [
      'Aplikasi yang memudahkan Anda dalam melakukan pembelian semua produk dan layanan Varash.',
      'Temukan banyak promo belanja mulai dari awal bulan hingga akhir bulan, hanya dalam satu genggaman!',
      'Wujudkan impian Anda sekarang bersama Varash!',
      'Ayo pakai aplikasi Varash dan rasakan semua manfaatnya!'
    ];

    Widget bubble(double size, [Color? color]) => Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
              color: color ?? Colors.white10, shape: BoxShape.circle),
        );

    List<Positioned> bubbles = [
      Positioned(
        left: -50,
        top: -30,
        child: bubble(180)
            .animate(onPlay: (o) => o.repeat(reverse: true))
            .moveY(duration: 2.s)
            .moveX(duration: 5.s, begin: 5, end: 10)
            .blur(
                duration: 1.s,
                begin: const Offset(11, 5),
                end: const Offset(5, 10)),
      ),
      Positioned(
        left: -70,
        top: 200,
        child: bubble(100, Colors.white24)
            .animate(onPlay: (o) => o.repeat(reverse: true))
            .blurXY(duration: 4.s, begin: 7, end: 10)
            .moveY(duration: 5.s, begin: -15, end: 55)
            .moveX(duration: 5.s, begin: 5, end: 55)
            .scaleXY(duration: 8.s, begin: 1, end: 2.5),
      ),
      Positioned(
        right: -50,
        bottom: -30,
        child: bubble(200, Colors.white12)
            .animate(onPlay: (o) => o.repeat(reverse: true))
            .moveY(duration: 2.s)
            .blur(
                duration: 1.s,
                begin: const Offset(15, 15),
                end: const Offset(5, 5)),
      ),
      Positioned(
        left: -70,
        bottom: -50,
        child: bubble(300, Colors.green.withOpacity(.4))
            .animate(onPlay: (o) => o.repeat(reverse: true))
            .moveY(duration: 5.s, begin: -55, end: 100)
            .moveX(duration: 5.s, begin: -55, end: 100)
            .blur(
                duration: 1.s,
                begin: const Offset(35, 35),
                end: const Offset(15, 15))
            .scaleXY(duration: 8.s, begin: 1, end: .5)
            .moveY(duration: 5.s, begin: -55, end: 100)
            .then()
            .moveX(duration: 5.s, begin: -55, end: 100)
            .scaleXY(duration: 8.s, begin: 1, end: 5),
      ),
      Positioned(
        right: -50,
        top: 150,
        child: bubble(100, Colors.white12)
            .animate(onPlay: (o) => o.repeat(reverse: true))
            .moveY(duration: 2.s)
            .blur(
                duration: 1.s,
                begin: const Offset(15, 15),
                end: const Offset(5, 5)),
      ),
    ];

    return Scaffold(
        body: Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              Container(
                height: Get.height,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.green.shade700,
                    Colors.green.shade400,
                    Colors.green.shade200,
                  ],
                )),
              ),
              Stack(
                children: [
                  ...bubbles,
                  CarouselSlider(
                      carouselController: controller.carouselController,
                      options: CarouselOptions(
                          viewportFraction: 1,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          height: Get.height,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          onPageChanged: (index, _) {
                            controller.slide.value = index;
                          },
                          scrollPhysics: BounceScroll()),
                      items: List.generate(
                          images.length,
                          (i) => Column(
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: Maa.center,
                                        children: [
                                          LzImage(
                                            images[i],
                                            size: 200,
                                            fit: BoxFit.contain,
                                          ).margin(b: 25),
                                          Textr(
                                            labels[i],
                                            style: Gfont.fs(25).white.bold,
                                            textAlign: Ta.center,
                                            margin: Ei.only(b: 10),
                                          ),
                                          Text(
                                            descriptions[i],
                                            style: Gfont.fs18.white,
                                            textAlign: Ta.center,
                                          )
                                        ],
                                      ),
                                    ).padding(all: 35),
                                  ),
                                ],
                              ).margin(t: context.padding.top))),
                  Poslign(
                    alignment: Alignment.bottomCenter,
                    child: Obx(() => LzSlideIndicator(
                          length: images.length,
                          active: controller.slide.value,
                          activeColor: Colors.white,
                          color: Colors.white54,
                          size: (index) =>
                              [controller.slide.value == index ? 15 : 8, 8],
                        ).margin(all: 15)),
                  ),
                  Poslign(
                      alignment: Alignment.topCenter,
                      child: ColorFiltered(
                        colorFilter: ColorsFilters.white,
                        child: const LzImage('logo.png',
                                size: 50, fit: BoxFit.contain)
                            .margin(t: 50),
                      ))
                ],
              ),
            ],
          ),
        ),
        LineProgressIndicator(
          repeat: true,
          duration: 10.s,
          progressColor: Colors.green,
          onComplete: () {
            controller.carouselController.nextPage();
          },
        ),
        Container(
          padding: Ei.all(35),
          child: Column(
            children: [
              LzButton(
                text: 'Masuk',
                icon: La.arrowRight,
                radius: 50,
                onTap: (state) {
                  state.submit(abortOn: 1.s);
                  Utils.timer(() => Get.back(), 1.s);
                },
              ).dark().sized(200),
              Textr('#sehatkayabahagia', margin: Ei.only(t: 25)),
              Textr(
                'v$version',
                style: Gfont.fs14.muted,
                margin: Ei.only(t: 5),
              ),
            ],
          ),
        )
      ],
    )

        // Center(
        //     child: Stack(
        //   children: [

        // Poslign(
        //   alignment: Alignment.bottomCenter,
        //   margin: Ei.only(b: 35),
        //   child: Row(
        //     mainAxisAlignment: Maa.spaceBetween,
        //     children: [
        //       Touch(
        //         onTap: () => controller.carouselController.previousPage(),
        //         child: Iconr(
        //           La.angleLeft,
        //           padding: Ei.all(20),
        //         ),
        //       ),
        //       Obx(() => Slidebar(
        //             length: 3,
        //             active: controller.slide.value,
        //             activeColor: LzColors.black,
        //             size: (index) => [10, 10],
        //           )),
        //       Touch(
        //         onTap: () => controller.carouselController.nextPage(),
        //         child: Iconr(
        //           La.angleRight,
        //           padding: Ei.all(20),
        //         ),
        //       )
        //     ],
        //   ),
        // ),

        // Button
        // Poslign(
        //   alignment: Alignment.bottomCenter,
        //   margin: Ei.only(v: 45, h: 15),
        //   child: Touch(
        //     onTap: () => Get.back(),
        //     child: Obx(() => Textr(
        //           controller.slide.value == 2 ? 'Masuk' : 'Masuk',
        //           style: Gfont.bold.fcolor(Colors.orange),
        //           padding: Ei.only(v: 15, h: 20),
        //         )),
        //   ),
        // )
        //   ],
        // )),
        // bottomNavigationBar: Row(
        //   mainAxisAlignment: Maa.center,
        //   children: [
        //     Textr(
        //       'Masuk',
        //       padding: Ei.all(20),
        //       style: Gfont.bold.fsize(18),
        //     ).onTap(() => Get.back()),
        //   ],
        // ),
        );
  }
}

class ColorsFilters {
  static const ColorFilter white = ColorFilter.matrix([
    1,
    0,
    0,
    0,
    255,
    0,
    1,
    0,
    0,
    255,
    0,
    0,
    1,
    0,
    255,
    0,
    0,
    0,
    1,
    0,
  ]);
}
