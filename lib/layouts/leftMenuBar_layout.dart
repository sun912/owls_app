import 'package:flutter/material.dart';

class LeftMenuBarLayout extends StatelessWidget {
  const LeftMenuBarLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Drawer(
      backgroundColor: Colors.grey,
      width: 400,
    );
  }
}
