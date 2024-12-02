import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ourtelegrambot/const/colors.dart';
import 'package:ourtelegrambot/const/firebase_const.dart';
import 'package:ourtelegrambot/controller/tasks_controller.dart';
import 'package:ourtelegrambot/controller/telegram_controller.dart';
import 'package:ourtelegrambot/widgets/Custom_button.dart';
import 'package:ourtelegrambot/widgets/text_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class VerificationScreen extends StatefulWidget {
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
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {

  final TasksController tasksController = Get.put(TasksController());

  @override
  void initState() {
    super.initState();
    tasksController.initializeTelegramBackButton();
  }

  @override
  void dispose() {
    tasksController.hideoutallButton();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController verificationInputController = TextEditingController();
    ValueNotifier<bool> isCodeCorrect = ValueNotifier<bool>(true);

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
              title: mediumText(title: widget.title),
              trailing: InkWell(
                onTap: () async {
                  final Uri taskUrl = Uri.parse(widget.url);
                  if (await canLaunchUrl(taskUrl)) {
                    await launchUrl(taskUrl, mode: LaunchMode.externalApplication);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Could not open ${widget.url}')),
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
            ValueListenableBuilder(
              valueListenable: isCodeCorrect,
              builder: (context, value, child) {
                return Column(
                  children: [
                    TextFormField(
                      controller: verificationInputController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            width: 2.0,
                            color: value
                                ? whiteColor.withOpacity(0.3)
                                : redColor, // Red if incorrect
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            width: 2.0,
                            color: value
                                ? whiteColor.withOpacity(0.3)
                                : redColor, // Red if incorrect
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            width: 2.0,
                            color: value
                                ? whiteColor.withOpacity(0.3)
                                : redColor, // Red if incorrect
                          ),
                        ),
                        suffixIcon: value
                            ? null
                            : Icon(Icons.error, color: redColor), // Error icon if incorrect
                      ),
                    ),
                    smallText(
                      title: 'Verify to Claim Your Reward',
                      color: value
                          ? whiteColor.withOpacity(0.3)
                          : redColor, // Change text color based on validation
                    ),
                  ],
                );
              },
            ),
            Spacer(),
            CustomButton(
              titleColor: primaryTextColor,
              onTap: () {
                // Check if the entered code matches the correct code when the button is tapped
                if (widget.code == verificationInputController.text) {
                  isCodeCorrect.value = true; // Correct code, validation passes
                  tasksController.markTasksCompletedwithpopNavigation(
                    collection: academicTasks,
                    userId: userTelegramId!,
                    context: context,
                    docId: widget.docid,
                    coinprice: widget.coinprice,
                  );
                  verificationInputController.clear();
                } else {
                  isCodeCorrect.value = false; // Incorrect code, show error
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
