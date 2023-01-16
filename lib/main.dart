import 'dart:async';
import 'dart:developer';

import 'package:fabrica_de_biscoitos/widgets/biscoitoWidget.dart';
import 'package:fabrica_de_biscoitos/widgets/cookie_widget.dart';
import 'package:fabrica_de_biscoitos/widgets/line_widget.dart';
import 'package:fabrica_de_biscoitos/widgets/linhaWidget.dart';
import 'package:fabrica_de_biscoitos/widgets/my_form.dart';
import 'package:fabrica_de_biscoitos/widgets/oven_widget.dart';
import 'package:flutter/material.dart';

import 'models/line.dart';
import 'models/order.dart';
import 'models/oven.dart';
import 'widgets/lines_widget.dart';

void main() {
  final Oven oven1m = Oven(id: 1, isFree: true, line: "");
  final Oven oven2m = Oven(id: 2, isFree: true, line: "");
  LineA lineAm = LineA(name: "LineA", oven: oven1m, waitLine: []);
  LineB lineBm = LineB(
    name: "LineB",
    oven1: oven1m,
    oven2: oven2m,
    waitLine: [],
    oven: oven1m,
  );
  LineC lineCm = LineC(name: "LineC", oven: oven2m, waitLine: []);
  // should print LineA class with oven1 assigned
  runApp(MyApp(
    lineA: lineAm,
    lineB: lineBm,
    lineC: lineCm,
    oven1: oven1m,
    oven2: oven2m,
  ));
}

class MyApp extends StatefulWidget {
  final LineA lineA;
  final LineB lineB;
  final LineC lineC;
  final Oven oven1;
  final Oven oven2;
  const MyApp({
    super.key,
    required this.lineA,
    required this.lineB,
    required this.lineC,
    required this.oven1,
    required this.oven2,
  });

  static const String _title = 'Fabrica de biscoitos';

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _selectedCookieType = "Salt";
  int _ingredient1 = 0;
  int _ingredient2 = 0;
  int _ingredient3 = 0;
  Offset _cookiePosition = const Offset(55, 25);
  List<Order> _orders = [];

  @override
  void initState() {
    super.initState();
    _updateScreen();
  }

  void _updateScreen() {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {});
      _updateScreen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: MyApp._title,
      home: Scaffold(
        backgroundColor: Colors.grey.shade600,
        appBar: AppBar(
          title: const Text(MyApp._title),
          backgroundColor: Colors.black,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                  flex: 1,
                  child: Row(
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      Text(
                        "Pedidos em espera: ${widget.lineA.waitLine.length}",
                        style: TextStyle(color: Colors.white),
                      ),
                      const Spacer(),
                      Text(
                        "Pedidos em espera: ${widget.lineB.waitLine.length}",
                        style: TextStyle(color: Colors.white),
                      ),
                      const Spacer(),
                      Text(
                        "Pedidos em espera: ${widget.lineC.waitLine.length}",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  )),
              Expanded(
                flex: 8,
                child: Stack(
                  children: [
                    const LinesWidget(),
                    for (int i = 0; i < _orders.length; i++)
                      AnimatedPositioned(
                        duration: const Duration(seconds: 2),
                        curve: Curves.fastOutSlowIn,
                        left: _orders[i].positionOfTheRequest.dx,
                        top: _orders[i].positionOfTheRequest.dy,
                        child: _orders[i].cookieWidget,
                      ),
                    Positioned(
                        left: 30,
                        top: 220,
                        child: OvenWidget(
                          isOn: !widget.oven1.isFree,
                        )),
                    Positioned(
                      left: 230,
                      top: 220,
                      child: OvenWidget(isOn: !widget.oven2.isFree),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 4,
                child: MyForm(
                  orders: _orders,
                  onOrderAdded: _handleNewOrder,
                  lines: [widget.lineA, widget.lineB, widget.lineC],
                ),
              ),
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  child: const Text('Change Square'),
                  onPressed: () {
                    setState(() {
                      _cookiePosition =
                          Offset(_cookiePosition.dx, _cookiePosition.dy + 60);
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleNewOrder(Order order) {
    setState(() {
      _orders.add(order);
    });
  }
}
