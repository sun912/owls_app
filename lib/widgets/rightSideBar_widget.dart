import 'package:flutter/material.dart';
import 'package:owls_app/constants.dart';
import 'package:owls_app/layouts/notification_layout.dart';
import 'package:owls_app/layouts/ruleList_layout.dart';

class RightSideBarWidget extends StatefulWidget {
  RightSideBarWidget({Key? key}) : super(key: key);

  @override
  State<RightSideBarWidget> createState() => _RightSideBarWidgetState();
}

class _RightSideBarWidgetState extends State<RightSideBarWidget> {
  bool ruleListClicked = false;
  bool notificationClicked = true;

  onClicked() {}

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    final _showDesktop = _size.width >= 1300;

    return Column(
      children: [
        SizedBox(
          width: _showDesktop ? 400 : 0,
          height: _size.height,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() {
                        ruleListClicked = false;
                        notificationClicked = true;
                      }),
                      child: Column(
                        children: [
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: notificationClicked
                                  ? primaryLight.withAlpha(100)
                                  : backgroundColor,
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(25),
                                topLeft: Radius.circular(25),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Notification',
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
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          ruleListClicked = true;
                          notificationClicked = false;
                        });
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: ruleListClicked
                              ? primaryLight.withAlpha(100)
                              : backgroundColor,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(25),
                            topLeft: Radius.circular(25),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Rule List',
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
                ],
              ),
              Container(
                child: ruleListClicked
                    ? RuleListLayout(size: _size, showDesktop: _showDesktop)
                    : NotificationLayout(
                        size: _size, showDesktop: _showDesktop),
              )
            ],
          ),
        ),
      ],
    );
  }
}
