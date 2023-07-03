import 'package:flutter/material.dart';
import 'package:owls_app/constants.dart';
import 'package:owls_app/pages/custom_dropdown_page.dart';
import 'package:owls_app/widgets/ConditionRadioButton_widget.dart';
import 'package:owls_app/widgets/ruleAction_widget.dart';

class NewRulePage extends StatefulWidget {
  NewRulePage({Key? key, required this.navigatorKey}) : super(key: key);

  final navigatorKey;

  @override
  State<NewRulePage> createState() => _NewRulePageState();
}

class _NewRulePageState extends State<NewRulePage> {
  @override
  Widget build(BuildContext context) {
    final List<String> items = ['tag001', 'tag002', 'tag003', 'tag004'];
    var _size = MediaQuery.of(context).size;
    final _showDesktop = _size.width >= 1000;
    return Column(
      children: [
        Container(
          width: 400,
          // height: _size.height - 215,
          decoration: const BoxDecoration(
            color: menuBar,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.topRight,
                margin: const EdgeInsets.only(
                  right: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    const Text(
                      'Target Object',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                    ),
                    SizedBox.fromSize(
                      size: const Size(40, 40),
                      child: ClipOval(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              widget.navigatorKey.currentState
                                  ?.pushNamed(routeRuleList);
                            },
                            child: Container(
                              child: const Icon(
                                Icons.close_rounded,
                                color: primaryAncient,
                                size: 36,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              CustomDropdownPage(
                dropdownList: items,
                initValue: 'Select rule target',
              ),
              const SizedBox(
                height: 25,
              ),
              const Text(
                'Conditions',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                margin: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: primaryAncient,
                    width: 3.0,
                  ),
                  color: backgroundColor,
                ),
                child: ConditionRadioButtonWidget(),
              ),
              const SizedBox(
                height: 25,
              ),
              const Text(
                'Action',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 15,
              ),
              const RuleActionWidget(),
              const SizedBox(
                height: 50,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  /*
                  TODO: request server to save new rule
                   */
                  widget.navigatorKey.currentState?.pushNamed(routeRuleList);
                },
                icon: Icon(Icons.create_rounded),
                label: const Text(
                  'Create Rule',
                  style: TextStyle(color: backgroundColor, fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(365, 50),
                    backgroundColor: primaryAncient,
                    padding: const EdgeInsets.all(12),
                    shape: const StadiumBorder()),
              )
            ],
          ),
        )
      ],
    );
  }
}
