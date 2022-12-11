import 'package:fabrica_de_biscoitos/widgets/biscoitoWidget.dart';
import 'package:fabrica_de_biscoitos/widgets/linha.dart';
import 'package:fabrica_de_biscoitos/widgets/linhaWidget.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'Fabrica de biscoitos';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: Row(
          children: [
            MyStatefulWidget(),
            MyStatefulWidget(),
            MyStatefulWidget(),
          ],
        ),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  @override
  double pad = 0;
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.all(20),
      child: Stack(
        children: [
          const LinhaWidget(),
          BiscoitoWidget(color: Colors.brown, pos: pad),
          Positioned(
            bottom: 30,
            right: 0,
            child: IconButton(
                onPressed: incrementPad, icon: const Icon(Icons.volume_up)),
          ),
          const Positioned(
            bottom: 150,
            child: Icon(
              Icons.microwave,
              color: Colors.grey,
              size: 80,
            ),
          )
        ],
      ),
    );
  }

  incrementPad() {
    setState(() {
      pad += 145;
    });
  }
}
