import 'package:flutter/material.dart';
import 'package:owls_app/constants.dart';
import 'package:owls_app/data/overlay_mixin.dart';
import 'package:owls_app/layouts/addRule_layout.dart';
import 'package:owls_app/widgets/ruleItem_widget.dart';

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

class _RuleListLayoutState extends State<RuleListLayout>
    with OverlayStateMixin {
  void onButtonClick() {
    toggleOverlay(AddRuleLayout(
      removeOverlay: removeOverlay,
      addOverlay: insertOverlay,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
      decoration: const BoxDecoration(
        color: menuBar,
      ),
      height: widget._size.height - 50,
      width: widget._showDesktop ? 400 : 0,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed: onButtonClick,
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
