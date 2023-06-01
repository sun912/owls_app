import 'package:flutter/material.dart';
import 'package:owls_app/constants.dart';

class RightSideBarWidget extends StatefulWidget {
  const RightSideBarWidget({Key? key}) : super(key: key);

  @override
  State<RightSideBarWidget> createState() => _RightSideBarWidgetState();
}

class _RightSideBarWidgetState extends State<RightSideBarWidget> {
  bool ruleListClicked = false;
  bool notificationClicked = true;

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    final _showDesktop = _size.width >= 1400;

    return Column(
      children: [
        Container(
          width: _showDesktop ? 400 : 0,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() {
                        ruleListClicked = true;
                        notificationClicked = false;
                      }),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: ruleListClicked
                              ? const Color(0xFFCCECDF).withOpacity(0.5)
                              : Colors.white,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(25),
                            topLeft: Radius.circular(25),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Notification',
                            style: TextStyle(
                              color: ruleListClicked
                                  ? primaryAncient
                                  : Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() {
                        ruleListClicked = false;
                        notificationClicked = true;
                        // Container(
                        //   decoration: BoxDecoration(
                        //     color: const Color(0xFFCCECDF).withOpacity(0.5),
                        //   ),
                        //   height: _size.height - 50,
                        //   width: _showDesktop ? 400 : 0,
                        //   child: const Text(
                        //     'Rule list',
                        //     style: TextStyle(
                        //       fontSize: 48,
                        //     ),
                        //   ),
                        // );
                      }),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: notificationClicked
                              ? const Color(0xFFCCECDF).withOpacity(0.5)
                              : Colors.white,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(25),
                            topLeft: Radius.circular(25),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Rule List',
                            style: TextStyle(
                              color: notificationClicked
                                  ? primaryAncient
                                  : Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFCCECDF).withOpacity(0.5),
                ),
                height: _size.height - 50,
                width: _showDesktop ? 400 : 0,
                child: Text('null'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
