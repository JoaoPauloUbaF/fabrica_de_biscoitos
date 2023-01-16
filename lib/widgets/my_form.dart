import 'package:fabrica_de_biscoitos/widgets/cookie_widget.dart';
import 'package:fabrica_de_biscoitos/widgets/lines_widget.dart';
import 'package:flutter/material.dart';

import '../models/line.dart';
import '../models/order.dart';

class MyForm extends StatefulWidget {
  final List<Order> orders;
  final List<Line> lines;
  final ValueChanged<Order> onOrderAdded;
  const MyForm(
      {super.key,
      required this.orders,
      required this.onOrderAdded,
      required this.lines});
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  double _ingredient1 = 0;
  double _ingredient2 = 0;
  double _ingredient3 = 0;
  int ids = 0;
  bool _isSweet = false;
  CookieWidget cookieWidget = CookieWidget(title: "");

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Ingrediente 1 (kg)',
                  hintStyle: TextStyle(color: Colors.white.withAlpha(100)),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    if (value == "") value = "0.0";
                    _ingredient1 = double.parse(value);
                  });
                },
              ),
            ),
            Expanded(
              flex: 2,
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Ingrediente 2 (kg)',
                  hintStyle: TextStyle(color: Colors.white.withAlpha(100)),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (value == "") value = "0.0";
                  setState(() {
                    _ingredient2 = double.parse(value);
                  });
                },
              ),
            ),
            Expanded(
              flex: 2,
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Ingrediente 3 (kg)',
                  hintStyle: TextStyle(color: Colors.white.withAlpha(100)),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (value == "") value = "0.0";
                  setState(() {
                    _ingredient3 = double.parse(value);
                  });
                },
              ),
            ),
            Expanded(
              flex: 2,
              child: SwitchListTile(
                title: const Text(
                  'Recheado?',
                  style: TextStyle(color: Colors.pink),
                ),
                value: _isSweet,
                onChanged: (value) {
                  setState(() {
                    _isSweet = value;
                  });
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: ElevatedButton(
                  child: const Text('Order'),
                  onPressed: () {
                    setState(() {
                      final order = Order(
                        ingredient1: _ingredient1,
                        ingredient2: _ingredient2,
                        ingredient3: _ingredient3,
                        isSweet: _isSweet,
                        cookieWidget: _isSweet
                            ? CookieWidget(
                                title: 'Order $ids',
                                color: Colors.pink,
                              )
                            : CookieWidget(
                                title: 'Order $ids',
                              ),
                        id: ids,
                      );
                      order.assignLine(widget.lines);
                      widget.onOrderAdded(order);
                    });
                    ids = ids + 1;
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
                // handle order here
