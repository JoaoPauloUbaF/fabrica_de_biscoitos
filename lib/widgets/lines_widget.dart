import 'package:flutter/material.dart';
import 'line_widget.dart';

class LinesWidget extends StatelessWidget {
  const LinesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.45,
      child: Row(
        children: [
          Expanded(child: LineWidget(lineName: 'Line A')),
          Expanded(child: LineWidget(lineName: 'Line B')),
          Expanded(child: LineWidget(lineName: 'Line C')),
        ],
      ),
    );
  }
}
