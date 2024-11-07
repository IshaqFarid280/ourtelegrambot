import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ourtelegrambot/const/colors.dart';
import 'package:ourtelegrambot/const/firebase_const.dart';
import 'package:ourtelegrambot/controller/tasks_controller.dart';
import 'package:ourtelegrambot/controller/telegram_controller.dart';
import 'package:ourtelegrambot/widgets/Custom_button.dart';
import 'package:ourtelegrambot/widgets/text_widgets.dart';
import 'package:ourtelegrambot/controller/verification_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class VerificationScreen extends StatelessWidget {
  final String title;
  final int coinprice;
  final String url;
  final String docid;
  final String code;

  const VerificationScreen({
    super.key,
    required this.title,
    required this.code,
    required this.docid,
    required this.coinprice,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    var tasksController = Get.put(TasksController());
    var controller = Get.put(TelegramController());
    var verificationController = Get.put(VerificationController());
    TextEditingController verificationInputController = TextEditingController();

    return Scaffold(
      backgroundColor: primaryTextColor,
      appBar: AppBar(
        backgroundColor: primaryTextColor,
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              tileColor: yellowColor.withOpacity(0.05),
              minVerticalPadding: 70,
              leading: Container(
                width: MediaQuery.of(context).size.width * 0.08,
                height: MediaQuery.of(context).size.height * 0.06,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/youtube.png'),
                  ),
                ),
              ),
              title: mediumText(title: title),
              trailing: InkWell(
                onTap: () async {
                  final Uri taskUrl = Uri.parse(url);
                  if (await canLaunchUrl(taskUrl)) {
                    await launchUrl(taskUrl, mode: LaunchMode.externalApplication);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Could not open $url')),
                    );
                  }
                },
                child: CircleAvatar(
                  backgroundColor: whiteColor.withOpacity(0.1),
                  child: Icon(Icons.launch, color: whiteColor, size: 25),
                ),
              ),
            ),
            mediumText(title: 'Verification'),
            Obx(() {
              return TextFormField(
                controller: verificationInputController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      width: 2.0,
                      color: verificationController.isCodeEntered.value
                          ? (verificationController.isCodeCorrect.value
                          ? greenColor
                          : redColor)
                          : whiteColor.withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      width: 2.0,
                      color: verificationController.isCodeEntered.value
                          ? (verificationController.isCodeCorrect.value
                          ? greenColor
                          : redColor)
                          : whiteColor.withOpacity(0.3),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      width: 2.0,
                      color: verificationController.isCodeEntered.value
                          ? (verificationController.isCodeCorrect.value
                          ? greenColor
                          : redColor)
                          : whiteColor.withOpacity(0.3),
                    ),
                  ),
                  suffixIcon: verificationController.isCodeEntered.value
                      ? Icon(
                    verificationController.isCodeCorrect.value
                        ? Icons.check
                        : Icons.error,
                    color: verificationController.isCodeCorrect.value
                        ? greenColor
                        : redColor,
                  )
                      : null,
                ),
              );
            }),
            smallText(
              title: 'Verify to Claim Your Reward',
              color: verificationController.isCodeEntered.value
                  ? (verificationController.isCodeCorrect.value
                  ? greenColor
                  : redColor)
                  : whiteColor.withOpacity(0.3),
            ),
            Spacer(),
            CustomButton(
              titleColor: primaryTextColor,
              onTap: () {
                verificationController.verifyCode(
                  verificationInputController.text,
                  code,
                );
                if (verificationController.isCodeCorrect.value) {
                  tasksController.markTasksCompletedwithpopNavigation(
                    collection: academyTasks,
                    userId: controller.userId.value,
                    context: context,
                    docId: docid,
                    coinprice: coinprice,
                  );
                }
              },
              title: 'Verify',
              width: 0.9,
              height: 0.08,
              color: whiteColor,
            ),
          ],
        ),
      ),
    );
  }
}
