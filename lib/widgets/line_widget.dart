import 'package:flutter/material.dart';

class LineWidget extends StatelessWidget {
  // representa Uma linha de prod
  final String lineName;
  LineWidget({required this.lineName});

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    var lineWidth = screenWidth / 3;
    var lineHeight = screenHeight / 2;
    var squareWidth = lineWidth * .8;
    var squareHeight = lineWidth * 1.6;
    return Container(
      width: lineWidth,
      height: lineHeight,
      decoration: BoxDecoration(
          color: Colors.grey,
          border: Border.all(color: Colors.black, width: 8)),
      child: Column(
        children: [
          Text(lineName),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: squareWidth,
                    height: squareHeight,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: Color.fromARGB(255, 172, 175, 76), width: 4),
                    ),
                    child: const Center(child: Text("Ingrediente 1")),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: squareWidth,
                    height: squareHeight,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: Color.fromARGB(255, 144, 175, 76), width: 4),
                    ),
                    child: const Center(child: Text("Ingrediente 2")),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: squareWidth,
                    height: squareHeight,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: Color.fromARGB(255, 102, 175, 76), width: 4),
                    ),
                    child: const Center(child: Text("Ingrediente 3")),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
