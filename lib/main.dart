import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fabrica_de_biscoitos/pages/login_page.dart';
import 'package:fabrica_de_biscoitos/widgets/cookie_widget.dart';
import 'package:fabrica_de_biscoitos/widgets/my_form.dart';
import 'package:fabrica_de_biscoitos/widgets/oven_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'models/line.dart';
import 'models/order.dart';
import 'models/oven.dart';
import 'pages/report_page.dart';
import 'widgets/lines_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final Oven oven1m = Oven(id: 1, isFree: true);
  final Oven oven2m = Oven(id: 2, isFree: true);
  LineA lineAm = LineA(
    name: "LineA",
    oven: oven1m,
    waitLine: [],
  );
  LineB lineBm = LineB(
    name: "LineB",
    oven1: oven1m,
    oven2: oven2m,
    waitLine: [],
    oven: oven1m,
  );
  LineC lineCm = LineC(name: "LineC", oven: oven2m, waitLine: []);

  runApp(MaterialApp(
    home: LoginPage(
      lineA: lineAm,
      lineB: lineBm,
      lineC: lineCm,
      oven1: oven1m,
      oven2: oven2m,
    ),
  ));
}

class MyApp extends StatefulWidget {
  final LineA lineA;
  final LineB lineB;
  final LineC lineC;
  final Oven oven1;
  final Oven oven2;
  final User userCredential;

  const MyApp({
    Key? key,
    required this.lineA,
    required this.lineB,
    required this.lineC,
    required this.oven1,
    required this.oven2,
    required this.userCredential,
  }) : super(key: key);

  static const String _title = 'Fabrica de biscoitos';

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<CookieOrder> _orders = [];
  String report = '';
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  int lastId = 0;
  @override
  void initState() {
    //quando é iniciado o App
    super.initState();
    //getOrders();
    _updateScreen();
    //count();
  }

  Future<void> count() async {
    for (int i = 0; i < 1000000; i++) {
      await Future.delayed(const Duration(seconds: 1), () async {
        print(i);
      });
    }
  }

  void _updateScreen() {
    //Re-Render da tela a cada 1s, tira das filas de espera para as linhas de prod
    Future.delayed(const Duration(seconds: 1), () async {
      setState(() {});
      await dequeueWaitLine(widget.lineA);
      await dequeueWaitLine(widget.lineB);
      await dequeueWaitLine(widget.lineC);

      _updateScreen();
    });
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scrollBehavior: MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown
        },
      ),
      title: MyApp._title,
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text(MyApp._title),
          backgroundColor: Colors.grey,
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
                        left: 150,
                        top: 220,
                        child: OvenWidget(
                          isOn: !widget.oven1.isFree,
                        )),
                    Positioned(
                      left: 500,
                      top: 220,
                      child: OvenWidget(isOn: !widget.oven2.isFree),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 4,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('orders')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }

                    // getOrders();

                    return MyForm(
                      userCredentialEmail: widget.userCredential.email ?? '',
                      onOrderAdded: _handleNewOrder,
                      lines: [widget.lineA, widget.lineB, widget.lineC],
                    );
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  child: const Text('Relatório'),
                  onPressed: () {
                    printReport(context);
                    // showAlertDialog(context);
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  child: Text('Sign Out'),
                  onPressed: () async {
                    await _auth.signOut();
                    // ignore: use_build_context_synchronously
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(
                            lineA: widget.lineA,
                            lineB: widget.lineB,
                            lineC: widget.lineC,
                            oven1: widget.oven1,
                            oven2: widget.oven2,
                          ),
                        ));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void printReport(BuildContext context) async {
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
          "${orderName}; ${element.isSweet ? 'Recheado' : 'Salgado'};  ${totalIngredient1} kg ; ${totalIngredient2} kg ;  ${totalIngredient3} kg ;  ${orderTime} s ;  ${totalTimeForAllOrders} s; \n";
    });

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReportPage(report: report),
      ),
    );
  }

  Future<void> dequeueWaitLine(Line line) async {
    // Retira o primeiro elemento da fila e coloca na linha
    if (line.waitLine.isNotEmpty && !line.waitLine.first.inMovement) {
      dequeueOrder(_orders, [widget.lineA, widget.lineB, widget.lineC], line);
    }
  }

  Future<void> getOrders() async {
    await firestore.collection("orders").get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        final orderData = doc.data();
        final order = CookieOrder.fromJson(orderData);
        order.isDone
            ? order.assignLineToDoneOrders(
                [widget.lineA, widget.lineB, widget.lineC], doc.get('line'))
            : order.assignLine([widget.lineA, widget.lineB, widget.lineC]);
        order.inMovement = false;
        addOrUpdateOrder(order);
      });
    });
  }

  void addOrUpdateOrder(CookieOrder order) {
    int index = _orders.indexWhere((o) => o.id == order.id);
    if (index == -1) {
      // If order with same id does not exist, add to list
      _orders.add(order);
    } else {
      // If order with same id exists, update existing order
      _orders[index] = order;
    }
  }

  Future<void> dequeueWaitLineC() async {
    if (widget.lineC.waitLine.isNotEmpty &&
        !widget.lineC.waitLine.first.inMovement) {
      dequeueOrder(
          _orders, [widget.lineA, widget.lineB, widget.lineC], widget.lineC);
    }
  }

  Future<void> dequeueOrder(
      List<CookieOrder> orders, List<Line> lines, Line line) async {
    if (line.isFree) {
      CookieOrder order = line.waitLine.first;

      if (!order.isDone) {
        order.inMovement = true;
      }

      addOrUpdateOrder(order);
      order
          .moveToOven()
          .then((value) => line.waitLine.removeAt(0))
          .then((value) async => await sendOrderToServer());
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

  Future<void> _handleNewOrder(CookieOrder order) async {
    //Att a Ui quando há um novo pedido
    setState(() {});
  }

  Future<void> sendOrderToServer() async {
    for (int i = 0; i < _orders.length; i++) {
      CookieOrder order = _orders[i];
      try {
        await firestore
            .collection('orders')
            .doc(order.id.toString())
            .set(order.toJson());
      } catch (error) {
        // Handle the error here
        print('Error sending order: $error');
      }
    }
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
