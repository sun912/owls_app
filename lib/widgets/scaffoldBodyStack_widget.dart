import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:owls_app/constants.dart';
import 'package:owls_app/data/floor_data.dart';
import 'package:owls_app/data/requestPlaceProvider.dart';
import 'package:owls_app/data/site_data.dart';
import 'package:owls_app/data/space_data.dart';
import 'package:owls_app/data/warningItem_data.dart';
import 'package:owls_app/widgets/map_widget.dart';
import 'package:owls_app/widgets/placeDropdown_widget.dart';
import 'package:owls_app/widgets/rightSideBar_widget.dart';
import 'package:owls_app/widgets/searchButton_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

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
}

class _ScaffoldBodyStackWidgetState extends State<ScaffoldBodyStackWidget> {
  late Future<List<dynamic>?> futureSite;
  late Future<List<dynamic>>? futurePlaceId;
  SharedPreferences? pref;
  late RequestPlaceProvider provider;
  bool? isChecked;
  List<SiteData>? selectedSiteList;
  List<SpaceData>? selectedSpaceList;
  List<FloorData>? selectedFloorList;
  List<String> cachedPlaceName = [];

  Future initPlace() async {
    pref = await SharedPreferences.getInstance();
    List<String>? prevPlaceName = pref?.getStringList(placePref);

    isChecked = pref?.getBool(isFirstInitPref) ?? false;
    logger.d("isChecked: $isChecked \n prevPlaceName: $prevPlaceName");

    if (isChecked!) {
      cachedPlaceName = [];
      cachedPlaceName.addAll(prevPlaceName!);
      List<String>? siteListString = pref?.getStringList('siteList');
      List<String>? spaceListString = pref?.getStringList('spaceList');
      List<String>? floorListString = pref?.getStringList('floorList');

      selectedSiteList = siteListString
          ?.map((item) => SiteData.fromJsonForPref(json.decode(item)))
          .toList();

      selectedSpaceList = spaceListString
          ?.map((item) => SpaceData.fromJsonForPref(json.decode(item)))
          .toList();

      selectedFloorList = floorListString
          ?.map((item) => FloorData.fromJsonForPref(json.decode(item)))
          .toList();

      // logger.d("selected Space List: ${selectedSpaceList}");
    } else {
      await pref?.setStringList(placePref, ["", "", ""]);
      cachedPlaceName = pref!.getStringList(placePref)!;
    }
    logger.d("cachedPlaces: $cachedPlaceName");
    if (provider.isChanged) {}
  }

  @override
  void initState() {
    initPlace();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    provider = Provider.of<RequestPlaceProvider>(context);
    futureSite = provider.requestNextOption(baseUrl, "/site", {});

    List<String> siteList = provider.getSiteOptionList
        .map((element) => jsonEncode(element.toJson()))
        .toList();
    pref?.setStringList("siteList", siteList);

    // logger.d('siteList: ${pref?.getStringList("siteList")}');
  }

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
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
                          dropdownList: provider.isChanged!
                              ? selectedSiteList!
                              : provider.getSiteOptionList,
                          initValue: isChecked! ? cachedPlaceName[0] : "지역 선택",
                          childPath: "/space",
                        ),
                        PlaceDropdownWidget(
                            dropdownList: provider.isChanged!
                                ? provider.getSpaceOptionList
                                : selectedSpaceList!,
                            initValue:
                                isChecked! ? cachedPlaceName[1] : "공간 선택",
                            childPath: "/floor"),
                        PlaceDropdownWidget(
                            dropdownList: provider.isChanged!
                                ? provider.getFloorOptionList
                                : selectedFloorList!,
                            initValue:
                                isChecked! ? cachedPlaceName[2] : "세부 공간 선택",
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
