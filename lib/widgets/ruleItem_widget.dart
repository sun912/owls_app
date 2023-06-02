import 'package:flutter/material.dart';
import 'package:owls_app/constants.dart';

class RuleItem extends StatelessWidget {
  const RuleItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    final _showDesktop = _size.width >= 1000;
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExpansionTile(
          title: Text('Rule 1'),
          subtitle: Text('See Details'),
          tilePadding: EdgeInsets.all(20),
          childrenPadding: EdgeInsets.only(left: 10, right: 10),
          textColor: primaryAncient,
          iconColor: primaryAncient,
          backgroundColor: primaryLight,
          children: [ListTile(title: Text('This is Rule Number1'))],
        ),
        ExpansionTile(
          title: Text('Rule 2'),
          subtitle: Text('See Details'),
          tilePadding: EdgeInsets.all(20),
          childrenPadding: EdgeInsets.only(left: 10, right: 10),
          textColor: primaryAncient,
          iconColor: primaryAncient,
          backgroundColor: primaryLight,
          children: [ListTile(title: Text('This is Rule Number2'))],
        ),
        ExpansionTile(
          title: Text('Rule 3'),
          subtitle: Text('See Details'),
          tilePadding: EdgeInsets.all(20),
          childrenPadding: EdgeInsets.only(left: 10, right: 10),
          textColor: primaryAncient,
          iconColor: primaryAncient,
          backgroundColor: primaryLight,
          children: [ListTile(title: Text('This is Rule Number3'))],
        ),
      ],
    );
  }
}
