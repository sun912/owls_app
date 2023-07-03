import 'package:flutter/material.dart';
import 'package:owls_app/widgets/alarmItem_widget.dart';

class NotificationLayout extends StatelessWidget {
  final Size _size;
  final bool _showDesktop;
  const NotificationLayout({Key? key, required size, required showDesktop})
      : _size = size,
        _showDesktop = showDesktop,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      decoration: const BoxDecoration(
        color: Color(0xFFE8F5EF),
      ),
      height: _size.height - 50,
      width: _showDesktop ? 400 : 0,
      child: Column(
        children: [AlarmItemWidget(key: key, showDesktop: _showDesktop)],
      ),
    );
  }
}
