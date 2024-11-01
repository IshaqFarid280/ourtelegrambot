import 'package:flutter/material.dart';



class EarnScreen extends StatelessWidget {
  const EarnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),

      body: Column(
        children: [

          ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.payment, color: Colors.black,),
            ),
            title: Text('Connect to '),
          )

        ],
      ),
    );
  }
}
