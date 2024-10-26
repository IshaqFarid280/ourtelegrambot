import 'package:flutter/material.dart';
import 'package:flutter_slot_machine/slot_machine.dart';
import 'package:get/get.dart';
import '../../controller/slot_machine.dart';
import '../../const/firebase_const.dart'; // Ensure you have the necessary imports

class SlotMachineScreen extends StatefulWidget {
  @override
  _SlotMachineScreenState createState() => _SlotMachineScreenState();
}

class _SlotMachineScreenState extends State<SlotMachineScreen> {
  final MySlotMachineController _controller = Get.put(MySlotMachineController());

  @override
  void initState() {
    super.initState();
    final userId = userTelegramId.toString(); // Assuming you have this value
    _controller.fetchUserData(userId); // Fetch user data once when the widget is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Slot Machine'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Obx(() => Text(
              'Remaining Free Plays: ${_controller.remainingPlays}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )),
            Obx(() => Text(
              'Coins: ${_controller.userCoins}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )),
            SizedBox(height: 20),
            SlotMachine(
              rollItems: [
                RollItem(index: 0, child: buildCoinSymbol(1000)),
                RollItem(index: 1, child: buildCoinSymbol(2000)),
                RollItem(index: 2, child: buildCoinSymbol(4000)),
                RollItem(index: 3, child: buildCoinSymbol(6000)),
                RollItem(index: 4, child: buildCoinSymbol(8000)),
                RollItem(index: 5, child: buildCoinSymbol(10000)),
              ],
              onCreated: (controller) {
                _controller.init(controller); // Initialize the controller
              },
              onFinished: (resultIndexes) {
                // This might not be needed since we're handling results in the controller
              },
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) => buildStopButton(i)),
              ),
            ),
            InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => _controller.start(userId: userTelegramId.toString(), context: context),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.green,
                ),
                alignment: Alignment.center,
                height: MediaQuery.sizeOf(context).height * 0.055,
                width: MediaQuery.sizeOf(context).width * 0.15,
                child:  Text('START'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildStopButton(int index) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => _controller.stop(index,context),
      child: Container(
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.orange,
        ),
        alignment: Alignment.center,
        height: MediaQuery.sizeOf(context).height * 0.05,
        width: MediaQuery.sizeOf(context).width * 0.15,
        child:  Text('STOP ${index + 1}'),
      ),
    );
  }

  Widget buildCoinSymbol(int value) {
    return Text('$value', style: TextStyle(fontSize: 20));
  }
}
