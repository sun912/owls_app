import 'dart:async';

import 'package:flutter/material.dart';
import 'package:owls_app/constants.dart';

class NotificationItemWidget extends StatefulWidget {
  final bool _showDesktop;
  const NotificationItemWidget({Key? key, required showDesktop})
      : _showDesktop = showDesktop,
        super(key: key);

  @override
  State<NotificationItemWidget> createState() => _NotificationItemWidgetState();
}

class _NotificationItemWidgetState extends State<NotificationItemWidget> {
  late Timer _timer;
  bool _isStart = false;

  @override
  Widget build(BuildContext context) {
    var isChecked = false;
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed: () {}, // TODO : make all msg to read status
                icon: Icon(Icons.mark_email_read_rounded),
                label: const Text(
                  '모두 읽은 상태로 변경',
                  style: TextStyle(color: backgroundColor),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: primaryAncient,
                    padding: const EdgeInsets.all(12),
                    shape: const StadiumBorder()),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          isChecked
              ? CheckedItem(widget: widget)
              : Container(
                  padding: EdgeInsets.all(15),
                  width: widget._showDesktop ? 350 : 0,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.deepOrange,
                  ),
                  child: const Text(
                    'not read alarm',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
          const SizedBox(
            height: 15,
          ),
          CheckedItem(widget: widget),
        ],
      ),
    );
  }

  void _startTimer() {
    if (_isStart == false) {
      _timer = Timer.periodic(Duration(seconds: 5), (timer) {
        setState(() {});
      });
      _isStart = true;
    }
  }
}

class CheckedItem extends StatelessWidget {
  const CheckedItem({
    super.key,
    required this.widget,
  });

  final NotificationItemWidget widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      width: widget._showDesktop ? 350 : 0,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: primaryLight,
      ),
      child: const Text(
        'read alarm',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
