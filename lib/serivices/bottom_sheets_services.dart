import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ourtelegrambot/widgets/bottom_sheet.dart';

class OpenBottomSheet {


  static openBottomSheet(
      {required String title,
      required String description,
      required VoidCallback onTap,
      required String imagePath,
        required String price,
      required BuildContext context}) {
    return showBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheetContainer(
            price: price,
              imagePath: imagePath,
              title: title,
              onTap: onTap,
              description: description);
        });
  }
}
