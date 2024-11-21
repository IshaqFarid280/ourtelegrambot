import 'package:flutter/material.dart';
import 'package:ourtelegrambot/widgets/custom_sizedBox.dart';

class HudView extends StatelessWidget {
  const HudView({super.key, required this.label, required this.icon, this.fontsize = 12.0, this.width = 0.27, this.height = 0.1, this.issizedbox = false});

  final Widget icon;
  final String label;
  final double fontsize;
  final double height;
  final double width;
  final bool issizedbox;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width*width,
        height: MediaQuery.of(context).size.height*height,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          icon,
         issizedbox == false ? SizedBox(height: 8) : SizedBox(height: 0,),
         issizedbox == false ?
          Text(label,
              style:
                   TextStyle(fontSize: fontsize, fontWeight: FontWeight.bold)) : SizedBox(
           height: 0, width: 0,
         )
        ],
      ),
    );
  }
}
class HudViewSmall extends StatelessWidget {
  const HudViewSmall({super.key, required this.label, required this.onTap, required this.icon, this.fontsize = 12.0, this.width = 0.27, this.height = 0.1, this.issizedbox = false});

  final Widget icon;
  final String  ? label;
  final double fontsize;
  final double height;
  final double width;
  final bool issizedbox;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
         width: MediaQuery.of(context).size.width*width,
          height: MediaQuery.of(context).size.height*height,
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        decoration: BoxDecoration(
            // color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
           issizedbox == false ? SizedBox(height: 4) : SizedBox(height: 0,),
           issizedbox == false ?
           label == null ? Sized(): Text(label.toString(), style:
                     TextStyle(fontSize: fontsize, fontWeight: FontWeight.bold)) : SizedBox(
             height: 0, width: 0,
           )
          ],
        ),
      ),
    );
  }
}
