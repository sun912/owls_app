import 'package:flutter/material.dart';
import 'package:owls_app/constants.dart';
import 'package:owls_app/pages/newRule_page.dart';
import 'package:owls_app/pages/ruleList_page.dart';

class RuleListLayout extends StatefulWidget {
  final Size _size;
  final bool _showDesktop;
  const RuleListLayout({Key? key, required Size size, required showDesktop})
      : _size = size,
        _showDesktop = showDesktop,
        super(key: key);

  @override
  State<RuleListLayout> createState() => _RuleListLayoutState();
}

class _RuleListLayoutState extends State<RuleListLayout> {
  void onButtonClick() {}

  final _navigatorKey = GlobalKey<NavigatorState>();
  final routeRuleList = "/";
  final routeAddRule = "/main/rule/new";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
      decoration: const BoxDecoration(
        color: menuBar,
      ),
      height: widget._size.height - 50,
      width: widget._showDesktop ? 400 : 0,
      child: Navigator(
        key: _navigatorKey,
        initialRoute: routeRuleList,
        onGenerateRoute: _onGenerateRoute,
      ),
    );
  }

  MaterialPageRoute _onGenerateRoute(RouteSettings setting) {
    if (setting.name == routeRuleList) {
      return MaterialPageRoute<dynamic>(
          builder: (context) => RuleListPage(
                onPress: () =>
                    _navigatorKey.currentState?.pushNamed(routeAddRule),
              ),
          settings: setting);
    } else if (setting.name == routeAddRule) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => NewRulePage(
          onPress: () => _navigatorKey.currentState?.pushNamed(routeRuleList),
        ),
      );
    } else {
      throw Exception('Unknown Route: ${setting.name}');
    }
  }
}
