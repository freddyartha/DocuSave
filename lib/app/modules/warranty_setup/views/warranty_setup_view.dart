import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/warranty_setup_controller.dart';

class WarrantySetupView extends GetView<WarrantySetupController> {
  const WarrantySetupView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WarrantySetupView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'WarrantySetupView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
