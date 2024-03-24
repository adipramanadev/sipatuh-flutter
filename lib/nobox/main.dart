import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pelanggaran/nobox/route.dart';

class nobox extends StatefulWidget {
  const nobox({super.key});

  @override
  State<nobox> createState() => _noboxState();
}

class _noboxState extends State<nobox> {
  @override
   @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.login,
      getPages: AppRoutes.routes,
    );
  }
}