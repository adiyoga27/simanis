import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lazyui/lazyui.dart';
import 'package:simanis/app/data/models/diet_model.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../controllers/tnt_controller.dart';

class CheckTNMView extends GetView<TntController> {
  const CheckTNMView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isLoading = controller.isLoading.value;

      if (isLoading) {
        return LzLoader.bar(message: 'Memuat TNM...');
      }
      return Wrapper(
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                title: const Text('HASIL TNM'),
                centerTitle: true,
              ),
              body: Padding(
                padding: const EdgeInsets.all(15.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 10.0),
                            controller.jk == 'Laki-laki'
                                ? const LzImage('men.png')
                                : const LzImage('women.png'),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'BMI untuk ${controller.jk}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            StatusBMI(controller: controller),
                            Container(
                              height: 200.0,
                              child: SfRadialGauge(
                                  title: GaugeTitle(
                                      text:
                                          '${num.parse(controller.bmi.toStringAsExponential(2))}',
                                      textStyle: const TextStyle(
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.bold)),
                                  axes: <RadialAxis>[
                                    RadialAxis(
                                      startAngle: 180,
                                      endAngle: 360,
                                      canScaleToFit: true,
                                      showLabels: false,
                                      minimum: 0,
                                      maximum: 40,
                                      ranges: <GaugeRange>[
                                        GaugeRange(
                                          startValue: 0,
                                          endValue: 15.9,
                                          color: Colors.red,
                                        ),
                                        GaugeRange(
                                          startValue: 16,
                                          endValue: 24.9,
                                          color: Colors.green,
                                        ),
                                        GaugeRange(
                                          startValue: 25,
                                          endValue: 28,
                                          color: Colors.orange,
                                        ),
                                        GaugeRange(
                                          startValue: 28.1,
                                          endValue: 50,
                                          color: Colors.red,
                                        )
                                      ],
                                      pointers: <GaugePointer>[
                                        NeedlePointer(
                                          value: controller.bmi,
                                          needleLength: 0.6,
                                          needleStartWidth: 2,
                                          needleEndWidth: 6,
                                          knobStyle: KnobStyle(
                                            knobRadius: 0.08,
                                            color: Colors.black,
                                          ),
                                        )
                                      ],
                                    )
                                  ]),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 28.0, right: 28.0, bottom: 15.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Tinggi ${controller.tall} cm'),
                                  Text('Berat ${controller.weight} kg'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Container(
                        width: Get.width,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              const Text(
                                "Kebutuhan Kalori Tubuh",
                                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                ' ${ num.parse(controller.totalKebutuhanKalori.toStringAsFixed(0))}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      controller.data.length == 0 ? SizedBox(height: 1.0,) : Container(
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                children: [
                                  const Text(
                                    "Rekomendasi Diet",
                                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                                  ),
                                   ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: controller.data.length,
                                    itemBuilder: (context, i) {
                                      Time time = controller.data[i];
                                      return Column(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 15, horizontal: 15),
                                            child: Text('${time.title}', style: TextStyle(fontWeight: FontWeight.bold),),
                                          ),
                                          Column(
                                            children: List.generate(
                                                time.food!.length, (x) {
                                              Food food = time.food![x];
                                              return Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      "${food.material!} (${food.unit})",
                                                      style: const TextStyle(
                                                          fontSize: 16.0),
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                   
                                                  Text(
                                                    '${food.menu ?? "-"}',
                                                    style: const TextStyle(
                                                        fontSize: 16.0),
                                                  ),
                                                ],
                                              );
                                            }),
                                          ),
                                          new Divider(
            color: Colors.black26,
          ),
                                        ],
                                      );
                                    },
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )));
    });
  }
}

class StatusBMI extends StatelessWidget {
  const StatusBMI({
    super.key,
    required this.controller,
  });

  final TntController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Text(
        ' ${controller.bmiNote}',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 30.0,
          color: _getColorForBMI(controller.bmiNote),
        ),
      ),
    );
  }

  Color _getColorForBMI(String bmiNote) {
    switch (bmiNote) {
      case 'Obesitas':
        return Colors.red;
      case 'Berat Berlebih':
        return Colors.yellow;
      case 'Berat Ideal':
        return Colors.green;
      default:
        return Colors.red;
    }
  }
}
