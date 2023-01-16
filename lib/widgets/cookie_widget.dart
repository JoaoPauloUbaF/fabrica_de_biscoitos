import 'package:flutter/material.dart';

class CookieWidget extends StatefulWidget {
  final Color color;
  final String title;
  bool isVisible = false;
  CookieWidget(
      {Key? key,
      this.color = Colors.brown,
      required this.title,
      this.isVisible = true})
      : super(key: key);

  void setVisible() {
    isVisible = !isVisible;
  }

  @override
  State<CookieWidget> createState() => _CookieWidgetState();
}

class _CookieWidgetState extends State<CookieWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.isVisible
        ? Column(
            children: [
              Text(widget.title),
              Icon(
                Icons.cookie,
                color: widget.color,
                size: 40,
              ),
            ],
          )
        : Container();
  }
}
