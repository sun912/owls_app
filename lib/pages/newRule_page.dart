import 'package:flutter/material.dart';
import 'package:owls_app/constants.dart';
import 'package:owls_app/pages/custom_dropdown_page.dart';

class NewRulePage extends StatelessWidget {
  NewRulePage({Key? key, required this.onPress}) : super(key: key);

  final onPress;

  String? selectedValue;

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
                child: SizedBox.fromSize(
                  size: const Size(40, 40),
                  child: ClipOval(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: onPress,
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
              ),
              const SizedBox(
                height: 15,
              ),
              CustomDropdownPage(dropdownList: items),
            ],
          ),
        )
      ],
    );
  }
}
