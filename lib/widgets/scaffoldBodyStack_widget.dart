import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:owls_app/constants.dart';
import 'package:owls_app/data/requestPlaceProvider.dart';
import 'package:owls_app/data/site_data.dart';
import 'package:owls_app/data/warningItem_data.dart';
import 'package:owls_app/widgets/map_widget.dart';
import 'package:owls_app/widgets/placeDropdown_widget.dart';
import 'package:owls_app/widgets/rightSideBar_widget.dart';
import 'package:owls_app/widgets/searchButton_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScaffoldBodyStackWidget extends StatefulWidget {
  ScaffoldBodyStackWidget({Key? key}) : super(key: key);
  late Future<List<WarningItemData>> futureWarnings;
  @override
  State<ScaffoldBodyStackWidget> createState() =>
      _ScaffoldBodyStackWidgetState();

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

  Future<List<SiteData>> requestSites() async {
    Uri uri = Uri.https(baseUrl, '/site');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      List<dynamic> parsedJson = jsonDecode(utf8.decode(response.bodyBytes));

      List<SiteData> siteList =
          parsedJson.map<SiteData>((json) => SiteData.fromJson(json)).toList();
      return siteList;
    } else {
      throw Exception('failed loading');
    }
  }
}

class _ScaffoldBodyStackWidgetState extends State<ScaffoldBodyStackWidget> {
  late Future<List<dynamic>?> futureSite;
  late Future<List<dynamic>>? futurePlaceId;
  SharedPreferences? pref;
  late RequestPlaceProvider provider;
  bool? isChecked;

  List<String> cachedPlaces = [];

  Future initPlace() async {
    pref = await SharedPreferences.getInstance();
    List<String>? prevPlace = pref?.getStringList(placePref);
    isChecked = pref?.getBool(isFirstInitPref) ?? false;
    // logger.d("isChecked: $isChecked");
    if (isChecked!) {
      cachedPlaces = [];
      cachedPlaces.addAll(prevPlace!);
      // await pref.setStringList(placePref, prevPlace!);
      // cachedPlaces = prevPlace;
    } else {
      await pref?.setStringList(placePref, ["", "", ""]);
      cachedPlaces = pref!.getStringList(placePref)!;
    }
    // logger.d("cachedPlace: $cachedPlaces");
    // logger.d("prevPlace: $prevPlace");
  }

  @override
  void initState() {
    widget.futureWarnings = widget.getWarnings();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    provider = Provider.of<RequestPlaceProvider>(context);
    futureSite = provider.requestNextOption(baseUrl, "/site", {});
  }

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    setState(() {
      // isChecked = pref?.getBool(isFirstInitPref) ?? false;
      initPlace();
    });
    return SafeArea(
      child: SingleChildScrollView(
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: _size.width - rightBarMinWidth,
                  height: _size.height,
                  color: const Color(0xFFFAFAFA),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 10.0),
                        child: MapWidget(),
                      ),
                    ],
                  ),
                ),
                Positioned.directional(
                  textDirection: TextDirection.ltr,
                  start: _size.width / 8,
                  end: 120,
                  top: 30,
                  child: Container(
                    padding: EdgeInsets.zero,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: primaryLight60,
                        width: 3,
                      ),
                    ),
                    child: Row(
                      children: [
                        PlaceDropdownWidget(
                          dropdownList: provider.getSiteOptionList,
                          initValue: isChecked! ? cachedPlaces[0] : "지역 선택",
                          childPath: "/space",
                        ),
                        PlaceDropdownWidget(
                            dropdownList: provider.getSpaceOptionList,
                            initValue: isChecked! ? cachedPlaces[1] : "공간 선택",
                            childPath: "/floor"),
                        PlaceDropdownWidget(
                            dropdownList: provider.getFloorOptionList,
                            initValue:
                                isChecked! ? cachedPlaces[2] : "세부 공간 선택",
                            childPath: ""),
                        SearchButtonWidget(),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    alignment: Alignment.topCenter,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 80,
                      vertical: 30,
                    ),
                    child: SizedBox.fromSize(
                      size: const Size(40, 40),
                      child: ClipOval(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Scaffold.of(context).openDrawer();
                            },
                            child: const Icon(
                              Icons.menu_sharp,
                              color: primaryAncient,
                              size: 36,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            RightSideBarWidget(),
          ],
        ),
      ),
    );
  }
}
