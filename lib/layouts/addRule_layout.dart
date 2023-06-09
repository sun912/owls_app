import 'package:flutter/material.dart';
import 'package:owls_app/constants.dart';
import 'package:owls_app/data/overlay_mixin.dart';

class AddRuleLayout extends StatefulWidget {
  var removeOverlay;
  var addOverlay;

  AddRuleLayout(
      {Key? key, Function? this.addOverlay, Function? this.removeOverlay})
      : super(key: key);

  @override
  State<AddRuleLayout> createState() => _AddRuleLayoutState();
}

class _AddRuleLayoutState extends State<AddRuleLayout> with OverlayStateMixin {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    final List<String> items = ['tag001', 'tag002', 'tag003', 'tag004'];
    var _size = MediaQuery.of(context).size;
    final _showDesktop = _size.width >= 1000;
    return Drawer(
      width: 400,
      child: Container(
        width: 400,
        // height: _size.height - 215,
        decoration: const BoxDecoration(
          color: menuBar,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.topRight,
                margin: const EdgeInsets.only(
                  right: 25,
                  top: 20,
                ),
                child: SizedBox.fromSize(
                  size: const Size(40, 40),
                  child: ClipOval(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: widget.removeOverlay,
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
              DropdownButtonFormField(
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryAncient, width: 3),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryAncient, width: 3),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  filled: true,
                  fillColor: backgroundColor,
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                ),
                isExpanded: true,
                items: items
                    .map((String item) => DropdownMenuItem<String>(
                          onTap: () {},
                          value: item,
                          child: Text(
                            item,
                            style: TextStyle(fontSize: 20),
                          ),
                        ))
                    .toList(),
                hint: const Row(
                  children: [
                    Icon(
                      Icons.ads_click_rounded,
                      size: 20,
                      color: primaryAncient,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Select targets of rule',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                onSaved: (value) {
                  selectedValue = value.toString();
                },
                onChanged: (String? newValue) {
                  setState(() {});
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
