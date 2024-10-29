import 'package:flutter/material.dart';
import 'package:ourtelegrambot/const/colors.dart';
import 'package:ourtelegrambot/widgets/CustomSized.dart';


class CustomButton extends StatelessWidget {
  const CustomButton({required this.title,this.height =  0.05,this.width = 0.4,this.color = secondaryTextColor,this.imagePath,required this.onTap});
  final double height ;
  final double width ;
  final Color color ;
  final String title ;
  final String ? imagePath ;
  final VoidCallback onTap ;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation:30,
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          height: MediaQuery.sizeOf(context).height  * height,
          width: MediaQuery.sizeOf(context).width * width,
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: color,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(title),
              CustomSized(width: 0.02,),
              imagePath == null ? Container(height: 0,width: 0,): Image.asset(imagePath.toString(),height: 20,width: 20,),
            ],
          ),
        ),
      ),
    );
  }
}
