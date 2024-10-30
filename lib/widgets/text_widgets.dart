import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../const/colors.dart';


Widget largeText({
  required String title,
  context,
  double fontSize = 20,
  fontWeight = FontWeight.w900,
  color = whiteColor,
}) {
  return Text(
    title,
    style: GoogleFonts.sansita(
        textStyle: TextStyle(
          color: color,
          fontWeight: fontWeight,
          fontSize: fontSize.toDouble(),
        )),
  );
}

Widget mediumText({
  required String title,
  context,
  double fontSize = 18,
  fontWeight = FontWeight.w700,
  Color color = whiteColor,
}) {
  return Text(
    title,
    style: GoogleFonts.sansita(
        textStyle: TextStyle(
          color: color,
          fontWeight: fontWeight,
          fontSize: fontSize.toDouble(),
        )),
  );
}

Widget smallText({
  required String title,
  context,
  double fontSize = 12,
  fontWeight = FontWeight.w900,
  color = whiteColor,
}) {
  return Text(
    title,
    style: GoogleFonts.sansita(
        textStyle: TextStyle(
          color: color,
          fontWeight: fontWeight,
          fontSize: fontSize.toDouble(),
        )),
    softWrap: true,
    maxLines: 10,
    overflow: TextOverflow.ellipsis,
  );
}

class TextWidgets {


  static TextStyle customSmallTextStyle({
    double fontSize = 12.0,
    Color color = whiteColor,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    return TextStyle(
      height: 1.7,
      color: color,
      fontWeight: fontWeight,
      fontSize: fontSize.toDouble(),
    );
  }

  static TextStyle customProfileTextStyle({
    double fontSize = 12.0,
    Color color = whiteColor,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    return GoogleFonts.sansita(
        textStyle: TextStyle(
          color: color,
          fontWeight: fontWeight,
          fontSize: fontSize.toDouble(),
        ));
  }


}
