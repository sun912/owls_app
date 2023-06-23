import 'package:flutter/material.dart';
import 'package:owls_app/pages/custom_dropdown_page.dart';

class RuleActionWidget extends StatefulWidget {
  const RuleActionWidget({Key? key}) : super(key: key);

  @override
  State<RuleActionWidget> createState() => _RuleActionWidgetState();
}

class _RuleActionWidgetState extends State<RuleActionWidget> {
  @override
  Widget build(BuildContext context) {
    return CustomDropdownPage(
      dropdownList: const [
        "Web Push alarm",
        "SMS Alarm",
      ],
      initValue: "Select Action",
    );
  }
}
