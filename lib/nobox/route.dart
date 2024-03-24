import 'dart:math';

import 'package:get/get.dart';
import 'package:pelanggaran/nobox/login.dart';
import 'package:pelanggaran/nobox/sendmessage.dart';

class AppRoutes {
  static const String login = '/';
  static const String sendmessage = '/sendmessage';

  static List<GetPage> routes = [
    GetPage(
        name: login,
        page: () => const LoginScreen(),
        transition: Transition.zoom,
        transitionDuration: const Duration(milliseconds: 500)),
    GetPage(
        name: sendmessage,
        page: () => Sendmessage(),
        transition: Transition.zoom,
        transitionDuration: const Duration(milliseconds: 500)),
  ];
}
