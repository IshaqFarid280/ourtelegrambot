import 'package:flutter/material.dart';
import 'package:flutter_slot_machine/slot_machine.dart';
import 'package:get/get.dart';
import 'package:ourtelegrambot/widgets/CustomSized.dart';
import 'package:ourtelegrambot/widgets/text_widgets.dart';
import 'package:confetti/confetti.dart';
import '../../const/colors.dart';
import '../../controller/slot_machine.dart';
import '../../const/firebase_const.dart';

class SlotMachineScreen extends StatefulWidget {
  @override
  _SlotMachineScreenState createState() => _SlotMachineScreenState();
}

class _SlotMachineScreenState extends State<SlotMachineScreen> {
  final MySlotMachineController _controller = Get.put(MySlotMachineController());
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    final userId = userTelegramId.toString();
    _controller.fetchUserData(userId);
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Obx(() => mediumText(title: 'Coins: ${_controller.userCoins}')),
                const CustomSized(),
                Obx(() => smallText(title: 'Free Plays: ${_controller.remainingPlays}')),
                const CustomSized(),
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
                    _controller.init(controller);
                  },
                  onFinished: (resultIndexes) {
                    if (_controller.isWinningCombination(resultIndexes)) {
                      _confettiController.play(); // Play confetti if winning combination
                    }
                  },
                ),
                const CustomSized(),
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
                      color: splashColor,
                    ),
                    alignment: Alignment.center,
                    height: screenSize.height * 0.05,
                    width: screenSize.width * 0.17,
                    child: smallText(title: 'START'),
                  ),
                ),
              ],
            ),
          ),
          // Confetti widget at the center of the screen
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple],
            numberOfParticles: 20,
            gravity: 0.2,
          ),
        ],
      ),
    );
  }

  Widget buildStopButton(int index) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => _controller.stop(index, context),
      child: Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: secondaryTextColor,
        ),
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height * 0.05,
        width: MediaQuery.of(context).size.width * 0.21,
        child: smallText(title: 'STOP ${index + 1}'),
      ),
    );
  }

  Widget buildCoinSymbol(int value) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(5),
      color: splashColor,
      child: mediumText(title: '$value', color: coinColors),
    );
  }
}
