class Biscoito {
  int tempoDePreparo;
  bool ehRecheado = false;
  List<Ingrediente> ingredientes = [];

  Biscoito({
    required this.ingredientes,
    required this.tempoDePreparo,
  });
}

class Ingrediente {}
