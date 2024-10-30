import 'package:flutter/material.dart';
import '../../const/colors.dart';

class LineIndicator extends StatelessWidget {
  final int itemCount;
  final int currentIndex;

  const LineIndicator({super.key,
    required this.itemCount,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          height: 3,
          width: MediaQuery.sizeOf(context).width * 0.18,
          color: currentIndex == index ? whiteColor : Colors.grey,
        );
      }),
    );
  }
}
