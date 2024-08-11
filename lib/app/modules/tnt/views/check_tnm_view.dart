import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lazyui/lazyui.dart';

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
                child: ListView(
                  children: [
                    Container(
                      color: Colors.white,
                      height: Get.height /3.5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          controller.jk == 'Laki-laki' ? const LzImage('men.png') : const LzImage('women.png'),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('BMI untuk ${controller.jk}', style: const TextStyle(fontWeight: FontWeight.bold),),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(' ${num.parse(controller.bmi.toStringAsExponential(2))}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),),
                          ),
                          StatusBMI(controller: controller),
                          Padding(
                            padding: const EdgeInsets.only(left: 28.0, right: 28.0),
                            child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                            
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Tinggi ${controller.tall} cm'),
                                Text('Berat ${controller.weight} kg'),
                              ],
                            ),
                          ) ,
                        ],
                      ),
                    ),
                    const SizedBox(height: 10.0,),
                    Container(
                      color: Colors.white,
                      height: Get.height /3.5,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding:  EdgeInsets.all(8.0),
                            child: Text('Kalori ', style: TextStyle(fontWeight: FontWeight.bold),),
                          ),
                            // Padding(
                            //   padding: const EdgeInsets.all(2.0),
                            //   child: Text(' ${num.parse(controller.kalori.toStringAsExponential(2))}', style:  TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
                            //   ),
                            // ),
                        ],
                      ),
                    ),
                  ],
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
    if(controller.bmiNote == 'Obesitas'){
      return Padding(
        padding: const EdgeInsets.all(2.0),
        child: Text(' ${controller.bmiNote  }', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0, color: Colors.red),),
      );
    } else if(controller.bmiNote == 'Berat Berlebih'){
        return Padding(
        padding: const EdgeInsets.all(2.0),
        child: Text(' ${controller.bmiNote  }', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0, color: Colors.yellow),),
      );
    }else if(controller.bmiNote == 'Berat Ideal'){
        return Padding(
        padding: const EdgeInsets.all(2.0),
        child: Text(' ${controller.bmiNote  }', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0, color: Colors.green),),
      );
    }else {
        return Padding(
        padding: const EdgeInsets.all(2.0),
        child: Text(' ${controller.bmiNote  }', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0, color: Colors.red),),
      );
    }
  
  }
}
