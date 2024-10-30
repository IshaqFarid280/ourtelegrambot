import 'package:flutter/material.dart';
import 'package:ourtelegrambot/const/colors.dart';
import 'package:ourtelegrambot/widgets/CustomSized.dart';
import 'package:ourtelegrambot/widgets/text_widgets.dart';

import '../const/images_path.dart';



class BottomSheetContainer extends StatelessWidget {
  const BottomSheetContainer({required this.imagePath,required this.title,required this.onTap,required this.description,required this.price});
  final String imagePath ;
  final VoidCallback onTap ;
  final String title ;
  final String description ;
  final String price ;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const  BoxDecoration(
        color: primaryTextColor,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomSized(),
          mediumText(title: title),
          CustomSized(),
          Image.asset(imagePath,height: MediaQuery.sizeOf(context).height * 0.2,width: MediaQuery.sizeOf(context).width * 0.4),
          CustomSized(),
          Text(description,style: TextWidgets.customSmallTextStyle(),textAlign: TextAlign.center,),
          CustomSized(),
          InkWell(
            onTap: onTap,
            splashColor: coinColors,
            highlightColor: coinColors,
            borderRadius: BorderRadius.circular(32),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
              decoration: BoxDecoration(
                color: secondaryTextColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const  CircleAvatar(backgroundImage: AssetImage(coin),backgroundColor: Colors.transparent,radius: 20,),
                  CustomSized(width: 0.01),
                  smallText(title:price,fontWeight: FontWeight.w400,fontSize: 15,color: coinColors),
                ],
              ),
            ),
          ),
          CustomSized(),
        ],
      ),
    );
  }
}





