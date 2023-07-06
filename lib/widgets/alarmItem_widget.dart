import 'dart:async';

import 'package:flutter/material.dart';
import 'package:owls_app/constants.dart';
import 'package:owls_app/data/alarmItem_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlarmItemWidget extends StatefulWidget {
  final bool _showDesktop;
  const AlarmItemWidget({Key? key, required showDesktop})
      : _showDesktop = showDesktop,
        super(key: key);

  @override
  State<AlarmItemWidget> createState() => _AlarmItemWidgetState();
}

class _AlarmItemWidgetState extends State<AlarmItemWidget> {
  late SharedPreferences prefs;
  bool _isStart = false;

  final List<AlarmItemData> itemList = [
    AlarmItemData.origin(
      itemId: "1",
      occurrenceTime: DateTime.now(),
      contents: "tag010",
    ),
    AlarmItemData.origin(
      itemId: "2",
      occurrenceTime: DateTime.now(),
      contents: "tag012",
    ),
    AlarmItemData.origin(
      itemId: "3",
      occurrenceTime: DateTime.now(),
      contents: "tag014",
    ),
    AlarmItemData.origin(
      itemId: "4",
      occurrenceTime: DateTime.now(),
      contents: "tag15",
    ),
    AlarmItemData.origin(
      itemId: "5",
      occurrenceTime: DateTime.now(),
      contents: "tag15",
    ),
    AlarmItemData.origin(
      itemId: "6",
      occurrenceTime: DateTime.now(),
      contents: "tag15",
    ),
    AlarmItemData.origin(
      itemId: "7",
      occurrenceTime: DateTime.now(),
      contents: "tag15",
    ),
    AlarmItemData.origin(
      itemId: "8",
      occurrenceTime: DateTime.now(),
      contents: "tag15",
    ),
    AlarmItemData.origin(
      itemId: "9",
      occurrenceTime: DateTime.now(),
      contents: "tag15",
    ),
    AlarmItemData.origin(
      itemId: "10",
      occurrenceTime: DateTime.now(),
      contents: "tag15",
    ),
    AlarmItemData.origin(
      itemId: "11",
      occurrenceTime: DateTime.now(),
      contents: "tag15",
    ),
  ];

  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final checkedAlarms = prefs.getStringList('checkedAlarms');
    if (checkedAlarms != null) {
      for (int i = 0; i < itemList.length; i++) {
        if (checkedAlarms.contains(itemList[i].itemId) == true) {
          setState(() {
            itemList[i].isChecked = true;
          });
        }
      }
    } else {
      await prefs.setStringList('checkedAlarms', []);
    }
  }

  @override
  void initState() {
    initPrefs();
  }

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  setState(() {
                    for (int i = 0; i < itemList.length; i++) {
                      itemList[i].isChecked = true;
                    }
                  });
                  final checkedAlarms = prefs.getStringList('checkedAlarms');
                  for (int i = 0; i < itemList.length; i++) {
                    if (checkedAlarms != null) {
                      if (checkedAlarms.contains(itemList[i]) == false) {
                        checkedAlarms.add(itemList[i].itemId);
                      }
                    }
                  }
                  await prefs.setStringList('checkedAlarms', checkedAlarms!);
                }, // TODO : make all msg to read status
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
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: _size.height - 150,
            child: ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                return ItemTile(
                  widget: widget,
                  itemData: itemList[index],
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
              itemCount: itemList.length,
            ),
          ),
        ],
      ),
    );
  }
}

class ItemTile extends StatelessWidget {
  const ItemTile({
    super.key,
    required this.widget,
    required this.itemData,
  });
  final AlarmItemData itemData;
  final AlarmItemWidget widget;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        width: widget._showDesktop ? 350 : 0,
        height: 110,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: itemData.isChecked ? primaryLight : Colors.amber,
        ),
        child: Column(
          children: [
            const Text(
              '[Caution]',
              style: TextStyle(
                  fontSize: 18, height: 3, fontWeight: FontWeight.w600),
              textAlign: TextAlign.start,
              textHeightBehavior: TextHeightBehavior(
                applyHeightToFirstAscent: true,
                applyHeightToLastDescent: true,
              ),
            ),
            Text(
              itemData.contents,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            Text(
              itemData.occurrenceTime.toString(),
              style: TextStyle(fontSize: 15),
            ),
          ],
        ));
  }
}
