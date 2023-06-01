import 'package:flutter/material.dart';
import 'package:owls_app/widgets/drawerBody_widget.dart';
import 'package:owls_app/widgets/scaffoldBody_widget.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 0;
    NavigationRailLabelType labelType = NavigationRailLabelType.all;
    return const Scaffold(
      drawer: DrawerBodyWidget(),
      body: ScaffoldBodyWidget(),
    );
  }
}
