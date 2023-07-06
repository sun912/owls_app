import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:owls_app/constants.dart';
import 'package:owls_app/data/requestPlaceProvider.dart';
import 'package:owls_app/data/site_data.dart';
import 'package:owls_app/widgets/map_widget.dart';
import 'package:owls_app/widgets/placeDropdown_widget.dart';
import 'package:owls_app/widgets/rightSideBar_widget.dart';
import 'package:owls_app/widgets/searchButton_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class ScaffoldBodyStackWidget extends StatefulWidget {
  ScaffoldBodyStackWidget({Key? key}) : super(key: key);

  @override
  State<ScaffoldBodyStackWidget> createState() =>
      _ScaffoldBodyStackWidgetState();

  Future<List<SiteData>> requestSites() async {
    Uri uri = Uri.https(baseUrl, '/site');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      List<dynamic> parsedJson = jsonDecode(utf8.decode(response.bodyBytes));
      // logger.d(parsedJson);
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
  late SharedPreferences pref;
  late RequestPlaceProvider provider;
  bool isInit = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    provider = Provider.of<RequestPlaceProvider>(context);
    futureSite = provider.requestNextOption(baseUrl, "/site", {});
    initPlace();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<RequestPlaceProvider>(context);
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
                          dropdownList: provider.getSiteOptionList,
                          initValue: isInit
                              ? "지역 선택"
                              : provider.getSelectedPlaceName[0],
                          childPath: "/space",
                        ),
                        PlaceDropdownWidget(
                            dropdownList: provider.getSpaceOptionList,
                            initValue: isInit
                                ? "공간 선택"
                                : provider.getSelectedPlaceName[1],
                            childPath: "/floor"),
                        PlaceDropdownWidget(
                            dropdownList: provider.getFloorOptionList,
                            initValue: isInit
                                ? "세부 공간 선택"
                                : provider.getSelectedPlaceName[2],
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
            const RightSideBarWidget(),
          ],
        ),
      ),
    );
  }

  Future initPlace() async {
    pref = await SharedPreferences.getInstance();
    final List<String>? checkedPlace = pref.getStringList(placePref);
    if (checkedPlace!.isNotEmpty) {
      isInit = false;
      for (int i = 0; i < 3; i++) {
        if (checkedPlace.contains(provider.getSelectedPlaceName[i]) == false) {
          logger.d(checkedPlace[i]);
          provider.setSelectedPlaceName(i, checkedPlace[i]);
        }
      }
    } else {
      await pref.setStringList("checkedPlace", ["", "", ""]);
    }
  }
}
