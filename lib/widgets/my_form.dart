import 'package:fabrica_de_biscoitos/widgets/cookie_widget.dart';
import 'package:fabrica_de_biscoitos/widgets/lines_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/line.dart';
import '../models/order.dart';
import 'package:uuid/uuid.dart';

class MyForm extends StatefulWidget {
  // Representa o Formulário para inserção do pedido na UI
  final List<Line> lines;
  final ValueChanged<CookieOrder> onOrderAdded;
  final String? userCredentialEmail;

  MyForm({
    super.key,
    required this.onOrderAdded,
    required this.lines,
    required this.userCredentialEmail,
  });
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  double _ingredient1 = 0;
  double _ingredient2 = 0;
  double _ingredient3 = 0;
  String _lastId = '';
  bool _isSweet = false;
  var uuid = const Uuid();
  int numOrders = 1;
  CookieWidget cookieWidget = CookieWidget(title: "");

  double _timeConstant = 0.0;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'T:',
                    hintStyle: TextStyle(color: Colors.white.withAlpha(100)),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) {
                    setState(() {
                      if (value == "") value = "0.0";
                      _timeConstant = double.parse(value);
                    });
                  },
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Ingrediente 1 (kg)',
                    hintStyle: TextStyle(color: Colors.white.withAlpha(100)),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) {
                    setState(() {
                      if (value == "") value = "0.0";
                      _ingredient1 = double.parse(value);
                    });
                  },
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Ingrediente 2 (kg)',
                    hintStyle: TextStyle(color: Colors.white.withAlpha(100)),
                  ),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    if (value == "") value = "0.0";
                    setState(() {
                      _ingredient2 = double.parse(value);
                    });
                  },
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Ingrediente 3 (kg)',
                    hintStyle: TextStyle(color: Colors.white.withAlpha(100)),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) {
                    if (value == "") value = "0.0";
                    setState(() {
                      _ingredient3 = double.parse(value);
                    });
                  },
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black, width: 1)),
                  child: SwitchListTile(
                    activeColor: Colors.pink,
                    title: const Text(
                      'Recheado?',
                      style: TextStyle(
                        color: Colors.pink,
                        backgroundColor: Colors.white,
                      ),
                    ),
                    value: _isSweet,
                    onChanged: (value) {
                      setState(() {
                        _isSweet = value;
                      });
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: ElevatedButton(
                  child: const Text('Order'),
                  onPressed: () {
                    setState(() {
                      _lastId = uuid.v4();
                      final order = CookieOrder(
                        timeConstant: _timeConstant,
                        ingredient1: _ingredient1,
                        ingredient2: _ingredient2,
                        ingredient3: _ingredient3,
                        isSweet: _isSweet,
                        cookieWidget: _isSweet
                            ? CookieWidget(
                                title: '${numOrders}º Order',
                                color: Colors.pink,
                              )
                            : CookieWidget(
                                title: '${numOrders}º Order',
                              ),
                        id: _lastId,
                        userEmail: widget.userCredentialEmail!,
                        isDone: false,
                      );
                      order.assignLine(widget.lines);
                      widget.onOrderAdded(order);
                      numOrders += 1;
                    });
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
                // handle order here
