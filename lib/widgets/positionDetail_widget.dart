import 'package:flutter/material.dart';
import 'package:owls_app/constants.dart';

class PositionDetailWidget extends StatefulWidget {
  PositionDetailWidget({Key? key}) : super(key: key);

  String? _selectedOption;
  @override
  State<PositionDetailWidget> createState() => _PositionDetailWidgetState();
}

class _PositionDetailWidgetState extends State<PositionDetailWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Row(
        //   children: [
        //     RadioListTile<String>(
        //       title: Text('초과'),
        //       value: '초과',
        //       groupValue: widget._selectedOption,
        //       onChanged: isUp,
        //       activeColor: primaryAncient,
        //     ),
        //     RadioListTile<String>(
        //       title: Text('미만'),
        //       value: '미만',
        //       groupValue: widget._selectedOption,
        //       onChanged: isDown,
        //       activeColor: primaryAncient,
        //     ),
        //   ],
        // ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15),
          child: SizedBox(
            width: 200,
            child: TextFormField(
              cursorColor: primaryAncient,
              decoration: const InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: primaryAncient),
                ),
                border: UnderlineInputBorder(),
                labelText: '반경을 입력하세요.(단위: m)',
                labelStyle: TextStyle(
                  color: primaryAncient,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void isUp(String? value) {
    setState(() {
      widget._selectedOption = value;
    });
  }

  void isDown(String? value) {
    widget._selectedOption = value;
  }
}
