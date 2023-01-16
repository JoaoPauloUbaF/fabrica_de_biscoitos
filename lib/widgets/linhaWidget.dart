import 'package:flutter/material.dart';

class LinhaWidget extends StatelessWidget {
  final String _lineName = "";
  const LinhaWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * .2,
      height: size.height * .5,
      color: Colors.black,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(children: [
          Container(
            alignment: Alignment.center,
            width: size.width * .2 * .8,
            height: size.height * .5 * .32,
            color: Color.fromARGB(255, 255, 7, 7),
            child: const Text("1"),
          ),
          Container(
            alignment: Alignment.center,
            width: size.width * .2 * .8,
            height: size.height * .5 * .32,
            color: Color.fromARGB(255, 255, 204, 0),
            child: const Text("2"),
          ),
          Container(
            alignment: Alignment.center,
            width: size.width * .2 * .8,
            height: size.height * .5 * .32,
            color: Colors.green,
            child: const Text("3"),
          )
        ]),
      ),
    );
  }
}
