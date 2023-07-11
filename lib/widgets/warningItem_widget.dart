import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:owls_app/constants.dart';
import 'package:owls_app/data/requestPlaceProvider.dart';
import 'package:owls_app/data/warningItem_data.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class WarningItemWidget extends StatefulWidget {
  WarningItemWidget({
    Key? key,
  }) : super(key: key);

  List<WarningItemData>? warningList;
  late bool _showDesktop;

  @override
  State<WarningItemWidget> createState() => _WarningItemWidgetState();
}

class _WarningItemWidgetState extends State<WarningItemWidget> {
  late SharedPreferences prefs;
  late Future<List<WarningItemData>> futureWarningList;
  bool isStart = false;
  RequestPlaceProvider? provider;

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

  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final checkedAlarms = prefs.getStringList(isCheckedWarning);
    logger.d("checkedAlarms: ${checkedAlarms?.length}");
    if (checkedAlarms != null && widget.warningList != null) {
      for (int i = 0; i < widget.warningList!.length; i++) {
        if (checkedAlarms.contains(widget.warningList![i].createDateTime) ==
            true) {
          setState(() {
            widget.warningList![i].isChecked = true;
          });
        }
      }
    } else {
      await prefs.setStringList(isCheckedWarning, []);
    }
  }

  @override
  void initState() {
    futureWarningList = getWarnings();
    initPrefs();
    // futureWarningList.then((value) => widget.warningList = value);
  }

  @override
  void didChangeDependencies() {
    provider = Provider.of<RequestPlaceProvider>(context);
  }

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    widget._showDesktop = _size.width > 1300;
    // logger.d("provider.siteId: ${provider?.getSelectedSiteId}");

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
                    for (int i = 0; i < widget.warningList!.length; i++) {
                      widget.warningList![i].isChecked = true;
                    }
                  });
                  final checkedAlarms = prefs.getStringList(isCheckedWarning);
                  for (int i = 0; i < widget.warningList!.length; i++) {
                    if (checkedAlarms != null) {
                      if (checkedAlarms!.contains(
                              widget.warningList![i].createDateTime) ==
                          false) {
                        checkedAlarms!
                            .add(widget.warningList![i].createDateTime);
                      }
                    }
                  }
                  prefs.setStringList(isCheckedWarning, checkedAlarms!);
                },
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
              future: futureWarningList,
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  widget.warningList = snapshot.data!;
                  final checkedAlarms = prefs.getStringList(isCheckedWarning);

                  if (checkedAlarms != null && widget.warningList != null) {
                    for (int i = 0; i < widget.warningList!.length; i++) {
                      if (checkedAlarms
                          .contains(widget.warningList![i].createDateTime)) {
                        widget.warningList![i].isChecked = true;
                      }
                    }
                  }
                  widget.warningList!.retainWhere((element) =>
                      element.siteId == provider?.getSelectedSiteId);
                  return ListView.separated(
                    itemBuilder: (BuildContext context, int index) {
                      return ItemTile(
                        widget: widget,
                        itemData: widget.warningList![index],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                    itemCount: snapshot.data!.length,
                  );
                } else if (snapshot.hasError) {
                  throw Exception();
                } else {
                  const Center(
                    child: Text("No warnings"),
                  );
                }
                return const CircularProgressIndicator(
                  semanticsLabel: "Loading...",
                  semanticsValue: "Loading...",
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
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: itemData.isChecked
              ? Border.all(color: primaryAncient, width: 3)
              : Border.all(color: Colors.amberAccent, width: 3),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              " \u{1F6A8} 발생 구역: ${itemData.siteName}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const Spacer(
              flex: 1,
            ),
            Text(
              " \u{1F4CD} 발생 대상: ${itemData.tagName} \n ",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  itemData.createDateTime,
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
          ],
        ));
  }
}
