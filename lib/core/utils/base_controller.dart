import 'package:get/get.dart';
import 'package:flutter/material.dart';

class BaseController extends GetxController {
  final List<TextEditingController> _controllers = [];

  @override
  void onInit() {
    super.onInit();
  }

  TextEditingController createTextController([String? initialText]) {
    final controller = TextEditingController(text: initialText);
    _controllers.add(controller);
    return controller;
  }

  void disposeController(TextEditingController controller) {
    try {
      if (_controllers.contains(controller)) {
        controller.dispose();
        _controllers.remove(controller);
      }
    } catch (e) {
      // Handle any disposal errors
      print('Error disposing controller: $e');
    }
  }

  @override
  void onClose() {
    for (var controller in _controllers) {
      try {
        controller.dispose();
      } catch (e) {
        // Handle any disposal errors
        print('Error disposing controller: $e');
      }
    }
    _controllers.clear();
    super.onClose();
  }
}