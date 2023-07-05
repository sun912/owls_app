import 'package:flutter/material.dart';
import 'package:owls_app/data/requestPlaceProvider.dart';
import 'package:owls_app/widgets/drawerBody_widget.dart';
import 'package:owls_app/widgets/scaffoldBodyStack_widget.dart';
import 'package:provider/provider.dart';

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
    return Scaffold(
      drawer: DrawerBodyWidget(),
      // body: ScaffoldBodyWidget(),
      body: ChangeNotifierProvider(
          create: (BuildContext context) => RequestPlaceProvider(),
          child: ScaffoldBodyStackWidget()),
    );
  }
}
