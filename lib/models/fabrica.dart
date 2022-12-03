import 'dart:ffi';
import 'dart:isolate';

import 'package:fabrica_de_biscoitos/models/forno.dart';

import 'linha.dart';

class Fabrica {
  Forno fornoUm;
  Forno fornoDois;
  Linha linhaA, linhaB, linhaC;

  Fabrica({
    required this.fornoUm,
    required this.fornoDois,
    required this.linhaA,
    required this.linhaB,
    required this.linhaC,
  });
}
