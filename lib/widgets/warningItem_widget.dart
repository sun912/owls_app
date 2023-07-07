import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:owls_app/constants.dart';
import 'package:owls_app/data/warningItem_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WarningItemWidget extends StatefulWidget {
  final bool _showDesktop;
  WarningItemWidget({Key? key, required showDesktop})
      : _showDesktop = showDesktop,
        super(key: key);
  late Future<List<WarningItemData>> futureWarningList;
  late List<WarningItemData> warningList;
  @override
  State<WarningItemWidget> createState() => _WarningItemWidgetState();

  Future<List<WarningItemData>> getWarnings() async {
    Uri uri = Uri.https(baseUrl, "/warning", {});
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      List<dynamic> alarmItemData = jsonDecode(utf8.decode(response.bodyBytes));
      List<WarningItemData> alarmList = alarmItemData
          .map<WarningItemData>((json) => WarningItemData.fromJson(json))
          .toList();
      return alarmList;
    } else {
      throw Exception("Failed getting alarms");
    }
  }
}

class _WarningItemWidgetState extends State<WarningItemWidget> {
  late SharedPreferences prefs;
  bool _isStart = false;

  // TODO: not work state caching....
  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final checkedAlarms = prefs.getStringList('checkedAlarms');
    if (checkedAlarms != null) {
      for (int i = 0; i < widget.warningList.length; i++) {
        if (checkedAlarms.contains(widget.warningList[i].createDateTime) ==
            true) {
          setState(() {
            widget.warningList[i].isChecked = true;
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
    widget.futureWarningList = widget.getWarnings();
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
                    for (int i = 0; i < widget.warningList.length; i++) {
                      widget.warningList[i].isChecked = true;
                    }
                  });
                  final checkedAlarms = prefs.getStringList('checkedAlarms');
                  for (int i = 0; i < widget.warningList.length; i++) {
                    if (checkedAlarms != null) {
                      if (checkedAlarms.contains(widget.warningList[i]) ==
                          false) {
                        checkedAlarms.add(widget.warningList[i].createDateTime);
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
            child: FutureBuilder(
              future: widget.futureWarningList,
              builder: ((BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  widget.warningList = snapshot.data;
                  return ListView.separated(
                    itemBuilder: (BuildContext context, int index) {
                      return ItemTile(
                        widget: widget,
                        itemData: snapshot.data[index],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                    itemCount: snapshot.data.length,
                  );
                } else if (snapshot.hasError) {
                  const Center(
                    child: Text("No warnings"),
                  );
                  throw Exception();
                }
                return CircularProgressIndicator(
                  color: primaryAncient,
                );
              }),
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
  final WarningItemData itemData;
  final WarningItemWidget widget;

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
            Text(
              "발생 구역: ${itemData.siteName}   발생 대상: ${itemData.tagName} \n ",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            Text(
              itemData.createDateTime,
              style: TextStyle(fontSize: 15),
            ),
          ],
        ));
  }
}
