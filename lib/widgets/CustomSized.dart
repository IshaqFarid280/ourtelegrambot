import 'package:flutter/material.dart';


class CustomSized extends StatelessWidget {
  final double height ;
  final double width ;
  const CustomSized({this.height = 0.05,this.width = 0.05});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * height,
      width: MediaQuery.sizeOf(context).width * width,
    );
  }
}
