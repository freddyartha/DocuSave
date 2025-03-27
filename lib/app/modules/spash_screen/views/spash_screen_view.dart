import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/spash_screen_controller.dart';

class SpashScreenView extends GetView<SpashScreenController> {
  const SpashScreenView({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Image.asset(
          'assets/images/loading.gif',
          width: Get.width * 0.4,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
