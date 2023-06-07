import 'package:flutter/material.dart';
import 'package:owls_app/constants.dart';
import 'package:owls_app/widgets/ruleItem_widget.dart';

class RuleListLayout extends StatelessWidget {
  final Size _size;
  final bool _showDesktop;
  const RuleListLayout({Key? key, required Size size, required showDesktop})
      : _size = size,
        _showDesktop = showDesktop,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
      decoration: const BoxDecoration(
        color: Color(0xFFE8F5EF),
      ),
      height: _size.height - 50,
      width: _showDesktop ? 400 : 0,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/rules/new');
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
          SizedBox(
            height: 10,
          ),
          RuleItem()
        ],
      ),
    );
  }
}
