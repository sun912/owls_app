import 'package:flutter/material.dart';

class AddRuleLayout extends StatelessWidget {
  const AddRuleLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    final _showDesktop = _size.width >= 1000;
    return Container(
      width: 400,
      decoration: BoxDecoration(
        color: Colors.green,
      ),
      child: Column(),
    );
  }
}
