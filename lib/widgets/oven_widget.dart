import 'package:flutter/material.dart';

class OvenWidget extends StatelessWidget {
  // Representa o Forno na UI
  final bool isOn;
  const OvenWidget({super.key, required this.isOn});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 70),
      child: Icon(
        Icons.microwave,
        size: 150,
        color: isOn ? Colors.red : Colors.white,
      ),
    );
  }
}
