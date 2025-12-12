part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const HOME = _Paths.HOME;
  static const SPLASH = _Paths.SPLASH;
  static const LOGIN = _Paths.LOGIN;
  static const REGISTER = _Paths.REGISTER;
  static const ADD_REPORT = _Paths.ADD_REPORT;
  static const ITEM_DETAIL = _Paths.ITEM_DETAIL;
  static const MY_CLAIMS = _Paths.MY_CLAIMS;
  static const CHAT = _Paths.CHAT;
  static const PROFILE = _Paths.PROFILE;
  static const MY_REPORTS = _Paths.MY_REPORTS;
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/home';
  static const SPLASH = '/splash';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const ADD_REPORT = '/add-report';
  static const ITEM_DETAIL = '/item-detail';
  static const MY_CLAIMS = '/my-claims';
  static const CHAT = '/chat';
  static const PROFILE = '/profile';
  static const MY_REPORTS = '/my-reports';
}
