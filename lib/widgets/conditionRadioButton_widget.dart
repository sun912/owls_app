import 'package:flutter/material.dart';
import 'package:owls_app/constants.dart';
import 'package:owls_app/data/conditionOptions_data.dart';
import 'package:owls_app/widgets/positionDetail_widget.dart';
import 'package:owls_app/widgets/speedDetail_widget.dart';

class ConditionRadioButtonWidget extends StatefulWidget {
  Options? selectedOption;

  ConditionRadioButtonWidget({Key? key}) : super(key: key);

  @override
  State<ConditionRadioButtonWidget> createState() =>
      _ConditionRadioButtonWidgetState();
}

class _ConditionRadioButtonWidgetState
    extends State<ConditionRadioButtonWidget> {
  void isPosition(Options? value) {
    setState(() {
      widget.selectedOption = value!;
    });
  }

  void isSpeed(Options? value) {
    setState(() {
      widget.selectedOption = value!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: RadioListTile<Options>(
                title: Text(Options.position.value),
                value: Options.position,
                groupValue: widget.selectedOption,
                onChanged: isPosition,
                activeColor: primaryAncient,
              ),
            ),
            Expanded(
              child: RadioListTile<Options>(
                title: Text(Options.speed.value),
                value: Options.speed,
                groupValue: widget.selectedOption,
                onChanged: isSpeed,
                activeColor: primaryAncient,
              ),
            ),
          ],
        ),
        if (widget.selectedOption?.value == 'position')
          PositionDetailWidget()
        else if (widget.selectedOption?.value == 'speed')
          SpeedDetailWidget(),
      ],
    );
  }
}
