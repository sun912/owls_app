import 'package:flutter/material.dart';
import 'package:owls_app/constants.dart';

class ConditionDetailWidget extends StatefulWidget {
  ConditionDetailWidget(
      {Key? key, required this.labelText, required this.limitOptions})
      : super(key: key);
  final String labelText;
  final List<String> limitOptions;
  String? _selectedOption;

  @override
  State<ConditionDetailWidget> createState() => _ConditionDetailWidgetState();
}

class _ConditionDetailWidgetState extends State<ConditionDetailWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15),
          child: SizedBox(
            width: 300,
            child: TextFormField(
              cursorColor: primaryAncient,
              decoration: InputDecoration(
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: primaryAncient),
                ),
                border: const UnderlineInputBorder(),
                labelText: widget.labelText,
                labelStyle: const TextStyle(
                  color: primaryAncient,
                ),
              ),
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: Text(widget.limitOptions[0]),
                value: widget.limitOptions[0],
                groupValue: widget._selectedOption,
                onChanged: isSelected,
                activeColor: primaryAncient,
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: Text(widget.limitOptions[1]),
                value: widget.limitOptions[1],
                groupValue: widget._selectedOption,
                onChanged: isSelected,
                activeColor: primaryAncient,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void isSelected(String? value) {
    setState(() {
      widget._selectedOption = value;
    });
  }
}
