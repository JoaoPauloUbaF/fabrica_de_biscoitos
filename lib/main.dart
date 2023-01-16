import 'dart:async';
import 'dart:developer';
import 'dart:isolate';

import 'package:fabrica_de_biscoitos/widgets/my_form.dart';
import 'package:fabrica_de_biscoitos/widgets/oven_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'models/line.dart';
import 'models/order.dart';
import 'models/oven.dart';
import 'widgets/cookie_widget.dart';
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
  List<Order> orders = [];
  // should print LineA class with oven1 assigned
  final _MyAppState state = _MyAppState();
  runApp(MyApp(
    lineA: lineAm,
    lineB: lineBm,
    lineC: lineCm,
    oven1: oven1m,
    oven2: oven2m,
    orders: orders,
  ));
}

Future<ComputeArgumentsA> _handleLineA(ComputeArgumentsA args) async {
  LineA lineA = args.line;
  List<Order> orders = args.orders;
  if (lineA.waitLine.isNotEmpty && lineA.isFree) {
    Order order = lineA.waitLine.removeAt(0);
    orders.add(order);
    order.cookieWidget.isVisible = true;
    // order.moveToOven();
    lineA.isFree = false;
  }
  return ComputeArgumentsA(lineA, orders);
}

Future<ComputeArgumentsB> _handleLineB(ComputeArgumentsB args) async {
  LineB lineB = args.line;
  List<Order> orders = args.orders;
  if (lineB.waitLine.isNotEmpty && lineB.isFree) {
    Order order = lineB.waitLine.removeAt(0);
    orders.add(order);
    order.cookieWidget.isVisible = true;
    // order.moveToOven();
    lineB.isFree = false;
  }
  return ComputeArgumentsB(lineB, orders);
}

Future<ComputeArgumentsC> _handleLineC(ComputeArgumentsC args) async {
  LineC lineC = args.line;
  List<Order> orders = args.orders;
  if (lineC.waitLine.isNotEmpty && lineC.isFree) {
    Order order = lineC.waitLine.removeAt(0);
    orders.add(order);
    order.cookieWidget.isVisible = true;
    // order.moveToOven();
    lineC.isFree = false;
  }
  return ComputeArgumentsC(lineC, orders);
}

class ComputeArgumentsA {
  final LineA line;
  final List<Order> orders;
  ComputeArgumentsA(this.line, this.orders);
}

class ComputeArgumentsB {
  final LineB line;
  final List<Order> orders;
  ComputeArgumentsB(this.line, this.orders);
}

class ComputeArgumentsC {
  final LineC line;
  final List<Order> orders;
  ComputeArgumentsC(this.line, this.orders);
}

class MyApp extends StatefulWidget {
  final LineA lineA;
  final LineB lineB;
  final LineC lineC;
  final Oven oven1;
  final Oven oven2;
  final List<Order> orders;
  const MyApp({
    super.key,
    required this.lineA,
    required this.lineB,
    required this.lineC,
    required this.oven1,
    required this.oven2,
    required this.orders,
  });

  static const String _title = 'Fabrica de biscoitos';

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _ingredient1 = 0;
  int _ingredient2 = 0;
  int _ingredient3 = 0;
  Offset _cookiePosition = const Offset(55, 25);
  late LineA _lineA;
  late LineB _lineB;
  late LineC _lineC;
  late Oven _oven1;
  late Oven _oven2;
  List<Order> _orders = [];

  @override
  void initState() {
    super.initState();
    _lineA = widget.lineA;
    _lineB = widget.lineB;
    _lineC = widget.lineC;
    _orders = widget.orders;
    _oven1 = widget.oven1;
    _oven2 = widget.oven2;
    _spawnComputeA();
    _updateScreen();
  }

  Future<void> _spawnComputeA() async {
    var computeArgs = ComputeArgumentsA(_lineA, _orders);
    ComputeArgumentsA computedA =
        await compute<ComputeArgumentsA, ComputeArgumentsA>(
            _handleLineA, computeArgs);

    setState(() {
      _lineA = computedA.line;
      _orders = computedA.orders;
    });
  }

  Future<void> _spawnComputeB() async {
    var computeArgs = ComputeArgumentsB(_lineB, _orders);
    ComputeArgumentsB computedB =
        await compute<ComputeArgumentsB, ComputeArgumentsB>(
            _handleLineB, computeArgs);

    setState(() {
      _lineB = computedB.line;
      _orders = computedB.orders;
    });
  }

  Future<void> _spawnComputeC() async {
    var computeArgs = ComputeArgumentsC(_lineC, _orders);
    ComputeArgumentsC computedC =
        await compute<ComputeArgumentsC, ComputeArgumentsC>(
            _handleLineC, computeArgs);

    setState(() {
      _lineC = computedC.line;
      _orders = computedC.orders;
    });
  }

  void _updateScreen() async {
    Future.delayed(Duration(seconds: 1), () {
      if (_lineA.waitLine.isNotEmpty && _lineA.isFree) _spawnComputeA();
      if (_lineB.waitLine.isNotEmpty && _lineB.isFree) _spawnComputeB();
      if (_lineC.waitLine.isNotEmpty && _lineC.isFree) _spawnComputeC();
      // _orders.firstWhere((element) => element == firstA).assignLine([widget.lineA]);
      setState(() {
        // print(_orders.last.positionOfTheRequest);
      });
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
                        "Pedidos em espera: ${_lineA.waitLine.length}",
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
                          isOn: !_oven1.isFree,
                        )),
                    Positioned(
                      left: 230,
                      top: 220,
                      child: OvenWidget(isOn: !_oven2.isFree),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 4,
                child: MyForm(
                  orders: _orders,
                  onOrderAdded: _handleNewOrder,
                  lines: [_lineA, widget.lineB, widget.lineC],
                ),
              ),
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  child: const Text('Gerar Relatório'),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleNewOrder() {
    setState(() {});
    // print(_lineA.waitLine.length);
  }
}
