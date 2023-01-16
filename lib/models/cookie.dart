import 'package:fabrica_de_biscoitos/widgets/cookie_widget.dart';

class Cookie {
  late double cookingTime;
  CookieWidget cookieWidget;

  Cookie({
    required this.cookieWidget,
  });
}

class SweetCookie extends Cookie {
  double timeFactor = 1.2;
  SweetCookie({required super.cookieWidget});
}

class SaltCookie extends Cookie {
  double timeFactor = 1;
  SaltCookie({required super.cookieWidget});
}
