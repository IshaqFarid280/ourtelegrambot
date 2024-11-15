


import 'package:flutter/material.dart';
import 'package:ourtelegrambot/const/colors.dart';

class FlyingNumber extends StatefulWidget {
  final int number;
  final Offset startPosition; // New parameter
  final VoidCallback onAnimationComplete;

  const FlyingNumber({
    Key? key,
    required this.number,
    required this.startPosition,
    required this.onAnimationComplete,
  }) : super(key: key);

  @override
  _FlyingNumberState createState() => _FlyingNumberState();
}

class _FlyingNumberState extends State<FlyingNumber> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    // Adjust the end value here for higher flight
    _animation = Tween<double>(begin: 0, end: -200).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward().whenComplete(() {
      widget.onAnimationComplete();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Positioned(
          left: widget.startPosition.dx - 20, // Center the number horizontally
          top: widget.startPosition.dy + _animation.value, // Move upwards
          child: Opacity(
            opacity: 1 - (_controller.value), // Fade out
            child: Text(
              '+${widget.number}', // Display the number
              style: const TextStyle(fontSize: 30, color: coinColors, fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }
}