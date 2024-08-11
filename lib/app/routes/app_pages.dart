import 'package:get/get.dart';
import 'package:simanis/app/modules/tnt/views/check_tnm_view.dart';

import '../modules/account/bindings/account_binding.dart';
import '../modules/account/views/account_view.dart';
import '../modules/app_intro/bindings/app_intro_binding.dart';
import '../modules/app_intro/views/app_intro_view.dart';
import '../modules/blood_sugar/bindings/blood_sugar_binding.dart';
import '../modules/blood_sugar/views/blood_sugar_view.dart';
import '../modules/blood_sugar/views/gdp_view.dart';
import '../modules/blood_sugar/views/gds_view.dart';
import '../modules/education/bindings/education_binding.dart';
import '../modules/education/views/education_view.dart';
import '../modules/education_detail/bindings/education_detail_binding.dart';
import '../modules/education_detail/views/education_detail_view.dart';
import '../modules/farmakologi/bindings/farmakologi_binding.dart';
import '../modules/farmakologi/views/farmakologi_view.dart';
import '../modules/foot_care/bindings/foot_care_binding.dart';
import '../modules/foot_care/views/foot_care_view.dart';
import '../modules/foot_screening/bindings/foot_screening_binding.dart';
import '../modules/foot_screening/views/foot_screening_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/initial/bindings/initial_binding.dart';
import '../modules/initial/views/initial_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/physical_training/bindings/physical_training_binding.dart';
import '../modules/physical_training/views/physical_training_view.dart';
import '../modules/registration/bindings/registration_binding.dart';
import '../modules/registration/views/registration_view.dart';
import '../modules/tnt/bindings/tnt_binding.dart';
import '../modules/tnt/views/tnt_view.dart';
import '../modules/webview/bindings/webview_binding.dart';
import '../modules/webview/views/webview_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.INITIAL;
  static const LOGIN = Routes.LOGIN;
  static const APPINTRO = Routes.APPINTRO;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.APP_INTRO,
      page: () => const AppIntroView(),
      binding: AppIntroBinding(),
    ),
    GetPage(
      name: _Paths.ACCOUNT,
      page: () => const AccountView(),
      binding: AccountBinding(),
    ),
    GetPage(
      name: _Paths.WEBVIEW,
      page: () => const WebviewView(),
      binding: WebviewBinding(),
    ),
    GetPage(
      name: _Paths.EDUCATION,
      page: () => const EducationView(),
      binding: EducationBinding(),
    ),
    GetPage(
      name: _Paths.EDUCATION_DETAIL,
      page: () => const EducationDetailView(),
      binding: EducationDetailBinding(),
    ),
    GetPage(
      name: _Paths.REGISTRATION,
      page: () => const RegistrationView(),
      binding: RegistrationBinding(),
    ),
    GetPage(
      name: _Paths.INITIAL,
      page: () => const InitialView(),
      binding: InitialBinding(),
    ),
    GetPage(
      name: _Paths.PHYSICAL_TRAINING,
      page: () => const PhysicalTrainingView(),
      binding: PhysicalTrainingBinding(),
    ),
    GetPage(
      name: _Paths.FOOT_CARE,
      page: () => const FootCareView(),
      binding: FootCareBinding(),
    ),
    GetPage(
      name: _Paths.GDP,
      page: () => const GdpView(),
      binding: BloodSugarBinding(),
    ),
    GetPage(
      name: _Paths.GDS,
      page: () => const GdsView(),
      binding: BloodSugarBinding(),
    ),
    GetPage(
      name: _Paths.BLOOD_SUGAR,
      page: () => const BloodSugarView(),
      binding: BloodSugarBinding(),
    ),
    GetPage(
      name: _Paths.FOOT_SCREENING,
      page: () => const FootScreeningView(),
      binding: FootScreeningBinding(),
    ),
    GetPage(
      name: _Paths.FARMAKOLOGI,
      page: () => const FarmakologiView(),
      binding: FarmakologiBinding(),
    ),
    GetPage(
      name: _Paths.TNT,
      page: () => const TntView(),
      binding: TntBinding(),
    ),
      GetPage(
      name: _Paths.CHECK_TNM,
      page: () => const CheckTNMView(),
      binding: TntBinding(),
    ),
  ];
}
