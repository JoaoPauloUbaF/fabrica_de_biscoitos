import 'linha.dart';

class Forno {
  Linha linha1, linha2;
  bool ocupado = false;
  int tempoParaAssar;

  Forno(
      {required this.linha1,
      required this.linha2,
      required this.tempoParaAssar});
}
