


import 'package:flutter/material.dart';
import 'package:ourtelegrambot/const/images_path.dart';

class CustomIndicator extends StatelessWidget {
  const CustomIndicator({super.key,this.height = 0.05,this.width =0.05});
  final double height;
  final double width ;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * height,
      width: MediaQuery.sizeOf(context).width * width,
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage(loading),fit: BoxFit.cover),
      ),
    );
  }
}
