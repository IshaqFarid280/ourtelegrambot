import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerificationController extends GetxController {
  final TextEditingController verificationInputController = TextEditingController();
  final RxBool isCodeCorrect = false.obs;
  final String correctCode;

  VerificationController(this.correctCode) {
    // Add listener to the text controller to validate the code
    verificationInputController.addListener(() {
      // Update `isCodeCorrect` based on whether the entered code matches the correct code
      isCodeCorrect.value = verificationInputController.text == correctCode;
    });
  }

  @override
  void onClose() {
    verificationInputController.dispose(); // Dispose controller when no longer needed
    super.onClose();
  }
}
