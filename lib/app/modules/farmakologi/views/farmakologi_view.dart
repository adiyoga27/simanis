import 'package:alarm/alarm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lazyui/lazyui.dart';
import 'package:simanis/app/core/utils/toast.dart';
import 'package:simanis/app/modules/farmakologi/views/shortcut_button.dart';
import 'package:simanis/app/routes/app_pages.dart';
import 'package:simanis/app/widgets/widget.dart';

import '../controllers/farmakologi_controller.dart';

class FarmakologiView extends StatelessWidget {
  const FarmakologiView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Farmakologi')),
      body:
         Flexible(
          child: ListView(
                      shrinkWrap: true,
          
            children: [
            const  Center(child: Padding(
                padding:  EdgeInsets.all(8.0),
                child: Text('NOTE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
              )),
          
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                        color: Colors.white, // Latar belakang putih
                        padding: const EdgeInsets.all(16.0),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                Text(
                  '1) Obat Tablet (oral)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Padding(
                  padding:  EdgeInsets.only(left: 20.0, right: 10.0),
                  child: Text('Dosis 3 x 1 (jarak minum obat 8 jam dari jam pertama minum obat)'),
                ),
                SizedBox(height: 4),
                Padding(
                  padding:  EdgeInsets.only(left: 20.0, right: 10.0),
                  child: Text('Dosis 2 x 1 (jarak minum obat 12 jam dari jam pertama minum obat)'),
                ),
                SizedBox(height: 4),
                Padding(
                 padding:  EdgeInsets.only(left: 20.0, right: 10.0),
                  child: Text('Dosis 1 x 1 (jarak minum obat 24 jam dari jam pertama minum obat)'),
                ),
                SizedBox(height: 16),
                Text(
                  '2) Obat Suntik Insulin (injeksi)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Padding(
                 padding:  EdgeInsets.only(left: 20.0, right: 10.0),
                  child: Text('Untuk pemberian obat suntik insulin, dianjurkan makan terlebih dahulu sebelum menyuntikan obat'),
                ),
                SizedBox(height: 8),
                Padding(
                  padding:  EdgeInsets.only(left: 20.0, right: 10.0),
                  child: Text('Dosis 3 x 1 iu (jam yang dianjurkan 07.00, 13.00, 19.00)'),
                ),
                SizedBox(height: 4),
                Padding(
                  padding:  EdgeInsets.only(left: 20.0, right: 10.0),
                  child: Text('Dosis 1 x 1 iu (jam yang dianjurkan 22.00)'),
                ),
                          ],
                        ),
                      ),
              ),
             
            ],
          ),
        )
        //\ return StreamBuilder(stream: stream, builder: builder)
    ,
bottomNavigationBar: LzButton(
        text: 'Check Jadwal Obat',
        onTap: (control) =>Get.toNamed(Routes.CHECK_JADWAL),
      ).dark().style(LzButtonStyle.shadow, spacing: 20),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
