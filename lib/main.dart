import 'dart:async';
import 'package:tuple/tuple.dart';

import 'package:fabrica_de_biscoitos/widgets/my_form.dart';
import 'package:fabrica_de_biscoitos/widgets/oven_widget.dart';
import 'package:flutter/material.dart';

import 'models/line.dart';
import 'models/order.dart';
import 'models/oven.dart';
import 'widgets/lines_widget.dart';

void main() {
  final Oven oven1m = Oven(id: 1, isFree: true);
  final Oven oven2m = Oven(id: 2, isFree: true);
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

void dequeueOrderThread(List<Order> orders, List<Line> lines, Line line) {
  // Se conseguisse implementar a thread
  if (line.isFree) {
    Order order = line.waitLine.first;
    order.inMovement = true;
    orders.add(order);
    order.moveToOven().then((value) => line.waitLine.removeAt(0));
    order.inMovement = false;
  }
}

Future<void> dequeueWaitLineAThread(Tuple3 tuple3) async {
  if (tuple3.item1.waitLine.isNotEmpty &&
      !tuple3.item1.waitLine.first.inMovement) {
    dequeueOrderThread(tuple3.item2, tuple3.item3, tuple3.item1);
  }
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
  final List<Order> _orders = [];
  String report = '';

  @override
  void initState() {
    //quando é iniciado o App
    super.initState();
    _updateScreen();
  }

  void _updateScreen() {
    //Re-Render da tela a cada 1s, tira das filas de espera para as linhas de prod
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {});
      //compute(threadB, void)
      dequeueWaitLineA(widget.lineA);
      dequeueWaitLineB();
      dequeueWaitLineC();
      _updateScreen();
    });
  }

  Future<void> threadB() async {
    // impl thread
    dequeueWaitLineB();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
                        "Pedidos em espera: ${numberOfRequests(widget.lineA)}",
                        style: const TextStyle(color: Colors.white),
                      ),
                      const Spacer(),
                      Text(
                        "Pedidos em espera: ${numberOfRequests(widget.lineB)}",
                        style: const TextStyle(color: Colors.white),
                      ),
                      const Spacer(),
                      Text(
                        "Pedidos em espera: ${numberOfRequests(widget.lineC)}",
                        style: const TextStyle(color: Colors.white),
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
                        left: _orders[i]
                            .positionOfTheRequest
                            .dx, //muda a animação com a posição do pedido
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
                  child: const Text('Relatório'),
                  onPressed: () {
                    printReport();
                    // showAlertDialog(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void printReport() {
    double orderTime = 0.0;
    double totalTimeForAllOrders = 0.0;
    double totalIngredient1 = 0.0;
    double totalIngredient2 = 0.0;
    double totalIngredient3 = 0.0;
    String orderName = '';
    _orders.forEach((element) {
      orderName = 'Pedido ${element.id}';
      orderTime = element.totalTime;
      totalTimeForAllOrders += element.totalTime;
      totalIngredient1 = element.ingredient1;
      totalIngredient2 = element.ingredient2;
      totalIngredient3 = element.ingredient3;
      report +=
          "${orderName}; Tipo de pedido: ${element.isSweet ? 'Recheado' : 'Salgado'}; Qtde Ingrediente 1: ${totalIngredient1} kg ; Qtde Ingrediente 2: ${totalIngredient2} kg ; Qtde Ingrediente 3: ${totalIngredient3} kg ; Tempo do pedido: ${orderTime} s ; Tempo Total: ${totalTimeForAllOrders} s; \n";
    });
    print(report);
  }

  Future<void> dequeueWaitLineA(LineA lineA) async {
    // Retira o primeiro elemento da fila e coloca na linha
    if (lineA.waitLine.isNotEmpty && !lineA.waitLine.first.inMovement) {
      dequeueOrder(_orders, [widget.lineA, widget.lineB, widget.lineC], lineA);
    }
  }

  void dequeueWaitLineB() {
    if (widget.lineB.waitLine.isNotEmpty &&
        !widget.lineB.waitLine.first.inMovement) {
      dequeueOrder(
          _orders, [widget.lineA, widget.lineB, widget.lineC], widget.lineB);
    }
  }

  void dequeueWaitLineC() {
    if (widget.lineC.waitLine.isNotEmpty &&
        !widget.lineC.waitLine.first.inMovement) {
      dequeueOrder(
          _orders, [widget.lineA, widget.lineB, widget.lineC], widget.lineC);
    }
  }

  void dequeueOrder(List<Order> orders, List<Line> lines, Line line) {
    if (line.isFree) {
      Order order = line.waitLine.first;
      order.inMovement = true;
      orders.add(order);
      order.moveToOven().then((value) => line.waitLine.removeAt(0));
      order.inMovement = false;
    }
  }

  int numberOfRequests(Line line) {
    //Número da lista de
    if (line.waitLine.isEmpty) {
      return 0;
    } else
      return line.waitLine.length - 1;
  }

  void _handleNewOrder(Order order) {
    //Att a Ui quando há um novo pedido
    setState(() {});
  }

  void showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = ElevatedButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Relatório"),
      content: Text(''),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
