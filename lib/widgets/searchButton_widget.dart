import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:owls_app/constants.dart';
import 'package:owls_app/data/requestPlaceProvider.dart';
import 'package:owls_app/data/warningItem_data.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchButtonWidget extends StatefulWidget {
  const SearchButtonWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<SearchButtonWidget> createState() => _SearchButtonWidgetState();
}

class _SearchButtonWidgetState extends State<SearchButtonWidget> {
  late RequestPlaceProvider provider;
  SharedPreferences? prefs;

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

  void onSearch() async {
    var futureWarnings = getWarnings();
    futureWarnings.then((warningList) {
      provider.setWarningItemList = warningList;
      // logger.d(provider.getWarningItemList!.length);
    });
    prefs = await SharedPreferences.getInstance();
    var placeNameList = prefs?.getStringList(placePref);
    // logger.d("placeNameList: $placeNameList");

    for (int i = 0; i < 3; i++) {
      if (!placeNameList!.contains(provider.getSelectedPlaceName[i])) {
        placeNameList[i] = provider.getSelectedPlaceName[i];
      }
    }
    await prefs?.setStringList(placePref, placeNameList!);
    await prefs?.setBool(isFirstInitPref, true);
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<RequestPlaceProvider>(context);
    return ElevatedButton.icon(
        onPressed: onSearch,
        icon: Icon(Icons.search_rounded),
        label: Text("검색"),
        style: ElevatedButton.styleFrom(
            backgroundColor: primaryAncient,
            textStyle: TextStyle(color: Colors.white),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            padding: EdgeInsets.symmetric(horizontal: 26, vertical: 15)));
  }

  @override
  void didChangeDependencies() {
    // provider = Provider.of<RequestPlaceProvider>(context, listen: false);
  }
}
