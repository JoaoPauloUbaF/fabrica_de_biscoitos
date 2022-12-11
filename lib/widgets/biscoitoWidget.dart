import 'package:flutter/material.dart';

class BiscoitoWidget extends StatelessWidget {
  final Color color;
  final double pos;
  const BiscoitoWidget({Key? key, required this.color, required this.pos})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      top: pos,
      duration: const Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 40),
        child: Icon(
          Icons.cookie,
          color: color,
          size: 60.0,
        ),
      ),
    );
  }
}
