import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';


class TwoFingerTapDetector extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTwoFingerTap;

  const TwoFingerTapDetector({
    Key? key,
    required this.child,
    this.onTwoFingerTap,
  }) : super(key: key);

  @override
  _TwoFingerTapDetectorState createState() => _TwoFingerTapDetectorState();
}

class _TwoFingerTapDetectorState extends State<TwoFingerTapDetector> {
  final Set<int> _activePointers = <int>{};

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (PointerDownEvent event) {
        _activePointers.add(event.pointer);
        if (_activePointers.length == 2) {
          widget.onTwoFingerTap?.call();
        }
      },
      onPointerUp: (PointerUpEvent event) {
        _activePointers.remove(event.pointer);
      },
      onPointerCancel: (PointerCancelEvent event) {
        _activePointers.remove(event.pointer);
      },
      child: widget.child,
    );
  }
}

class ThreeFingerTapDetector extends StatefulWidget {
  final Widget child;
  final VoidCallback? onThreeFingerTap;

  const ThreeFingerTapDetector({
    Key? key,
    required this.child,
    this.onThreeFingerTap,
  }) : super(key: key);

  @override
  _ThreeFingerTapDetectorState createState() => _ThreeFingerTapDetectorState();
}

class _ThreeFingerTapDetectorState extends State<ThreeFingerTapDetector> {
  final Set<int> _activePointers = <int>{};

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (PointerDownEvent event) {
        _activePointers.add(event.pointer);
        if (_activePointers.length == 3) {
          widget.onThreeFingerTap?.call();
        }
      },
      onPointerUp: (PointerUpEvent event) {
        _activePointers.remove(event.pointer);
      },
      onPointerCancel: (PointerCancelEvent event) {
        _activePointers.remove(event.pointer);
      },
      child: widget.child,
    );
  }
}

