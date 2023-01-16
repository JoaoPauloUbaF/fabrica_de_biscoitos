import 'package:flutter/material.dart';

class BiscoitoWidget extends StatelessWidget {
  final Color color;
  final Offset pos;
  const BiscoitoWidget({Key? key, required this.color, required this.pos})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      top: pos.dy,
      left: pos.dx,
      duration: const Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
      child: Icon(
        Icons.cookie,
        color: color,
        size: 60.0,
      ),
    );
  }
}
