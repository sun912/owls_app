import 'package:flutter/material.dart';
import 'package:owls_app/layouts/naviRail_layout.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  const MainLayout({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NaviRail();
  }
}
