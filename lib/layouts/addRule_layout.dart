import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:owls_app/constants.dart';

class AddRuleLayout extends StatelessWidget {
  var removeOverlay;

  AddRuleLayout({Key? key, Function? this.removeOverlay}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final List<String> tags = ['tag001', 'tag002', 'tag003', 'tag004'];

    var _size = MediaQuery.of(context).size;
    final _showDesktop = _size.width >= 1000;
    return Container(
      width: 400,
      // height: _size.height - 215,
      decoration: const BoxDecoration(
        color: menuBar,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
                      onTap: removeOverlay,
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
            Container(
              height: 1000,
              child: DropdownButtonFormField2(
                decoration: InputDecoration(),
                items: [],
              ),
            )
          ],
        ),
      ),
    );
  }
}
