import 'package:flutter/material.dart';
import 'package:ourtelegrambot/widgets/CustomSized.dart';
import 'package:ourtelegrambot/widgets/text_widgets.dart';
import '../../const/colors.dart';

class OnboardingPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final String description;

  const OnboardingPage({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath, height: MediaQuery.sizeOf(context).height * 0.3, fit: BoxFit.contain),
          CustomSized(),
          Text(
            title,
            style: TextWidgets.customSmallTextStyle(fontSize: 18,fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          CustomSized(),
          Text(
            subtitle,
            style: TextWidgets.customSmallTextStyle(fontSize: 16,fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          CustomSized(height: 0.01,),
          Text(
            description,
            style: TextWidgets.customSmallTextStyle(),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}