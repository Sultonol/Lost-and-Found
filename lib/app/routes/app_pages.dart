import 'package:get/get.dart';
import 'package:lost_and_found/app/modules/add_report/add_report_binding.dart';
import 'package:lost_and_found/app/modules/add_report/add_report_view.dart';
import 'package:lost_and_found/app/modules/auth/login/login_binding.dart';
import 'package:lost_and_found/app/modules/auth/login/login_view.dart';
import 'package:lost_and_found/app/modules/auth/register/register_binding.dart';
import 'package:lost_and_found/app/modules/auth/register/register_view.dart';
import 'package:lost_and_found/app/modules/auth/splash/splash_binding.dart';
import 'package:lost_and_found/app/modules/auth/splash/splash_view.dart';
import 'package:lost_and_found/app/modules/chat/chat_view.dart';
import 'package:lost_and_found/app/modules/home/home_binding.dart';
import 'package:lost_and_found/app/modules/home/home_view.dart';
import 'package:lost_and_found/app/modules/item_detail/item_detail_binding.dart';
import 'package:lost_and_found/app/modules/item_detail/item_detail_view.dart';
import 'package:lost_and_found/app/modules/my_claims/my_claims_view.dart';
import 'package:lost_and_found/app/modules/my_reports/my_reports_binding.dart';
import 'package:lost_and_found/app/modules/my_reports/my_reports_view.dart';
import 'package:lost_and_found/app/modules/profile/profile_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH; // Halaman pertama kali dibuka

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.ADD_REPORT,
      page: () => const AddReportView(),
      binding: AddReportBinding(),
    ),
    GetPage(
      name: _Paths.ITEM_DETAIL,
      page: () => const ItemDetailView(),
      binding: ItemDetailBinding(),
    ),
    // GetPage(
    //   name: _Paths.MY_CLAIMS,
    //   page: () => const MyClaimsView(),
    //   binding: MyClaimsBinding(),
    // ),
    GetPage(name: _Paths.CHAT, page: () => const ChatView()),
    GetPage(name: _Paths.PROFILE, page: () => const ProfileView()),
    GetPage(
      name: _Paths.MY_REPORTS,
      page: () => const MyReportsView(),
      binding: MyReportsBinding(),
    ),
  ];
}
