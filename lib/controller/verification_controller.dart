import 'package:get/get.dart';

class VerificationController extends GetxController {
  // Observable for tracking whether the code is correct or not
  var isCodeCorrect = true.obs;
  var isCodeEntered = false.obs; // Track if the code was entered (button tap)

  // Function to check if the code is correct
  void verifyCode(String enteredCode, String correctCode) {
    isCodeEntered.value = true; // Set to true when button is tapped
    if (enteredCode == correctCode) {
      isCodeCorrect.value = true;
    } else {
      isCodeCorrect.value = false;
    }
  }
}
