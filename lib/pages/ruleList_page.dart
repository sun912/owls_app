import 'package:flutter/material.dart';
import 'package:owls_app/constants.dart';
import 'package:owls_app/widgets/ruleItem_widget.dart';

class RuleListPage extends StatelessWidget {
  const RuleListPage({Key? key, required this.navigatorKey}) : super(key: key);

  final navigatorKey;

  get onButtonClick => null;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                navigatorKey.currentState?.pushNamed(routeAddRule);
              },
              icon: Icon(Icons.add_circle_outline_outlined),
              label: const Text(
                'Add Rule',
                style: TextStyle(color: backgroundColor),
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: primaryAncient,
                  padding: const EdgeInsets.all(12),
                  shape: const StadiumBorder()),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Expanded(child: RuleItemWidget()),
      ],
    );
  }
}
