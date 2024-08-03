import 'package:get/get.dart';
import 'package:lazyui/lazyui.dart';
import 'package:simanis/app/core/utils/fetch.dart';
import 'package:simanis/app/data/models/education_category_model.dart';
import 'package:simanis/app/data/services/api/api.dart';

class PhysicalTrainingController extends GetxController {
    final api = EducationApi();
    List<Map> categories = [];
  RxList<Education> data = RxList([]);
  bool hasInit = false;

    @override
    void onInit() {
      super.onInit();
      getCategory();
    }
    
      Future getData() async {
    try {
      if (!hasInit) {
        await getCategory();
        hasInit = true;
      }

    
    } catch (e, s) {
      Errors.check(e, s);
    }
  }

    Future getCategory() async {
    try {
      ResHandler res = await api.getPhysicalTraining();
      List data = res.data ?? [];

      this.data.value = [...data.map((e) => Education.fromJson(e))];
        
    } catch (e, s) {
           Errors.check(e, s);

    }
  }
}
