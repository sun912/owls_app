import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:owls_app/constants.dart';
import 'package:owls_app/data/requestPlaceProvider.dart';
import 'package:owls_app/data/site_data.dart';
import 'package:owls_app/widgets/map_widget.dart';
import 'package:owls_app/widgets/placeDropdown_widget.dart';
import 'package:owls_app/widgets/rightSideBar_widget.dart';
import 'package:provider/provider.dart';

class ScaffoldBodyStackWidget extends StatefulWidget {
  ScaffoldBodyStackWidget({Key? key}) : super(key: key);
  late String placeId;

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
  late String placeId;

  @override
  void initState() {
    super.initState();

    // futureSite = widget.requestSites();
    placeId = "";
  }

  @override
  void didChangeDependencies() {
    var provider = Provider.of<RequestPlaceProvider>(context);
    futureSite = provider.requestNextOption(baseUrl, "/site", {});
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
                  start: _size.width / 9,
                  end: 50,
                  top: 35,
                  child: Row(
                    children: [
                      PlaceDropdownWidget(
                        dropdownList: provider.siteOptionList,
                        initValue: "지역 선택",
                        childPath: "/space",
                      ),
                      PlaceDropdownWidget(
                          dropdownList: provider.spaceOptionList,
                          initValue: "공간 선택",
                          childPath: "/floor"),
                      PlaceDropdownWidget(
                          dropdownList: provider.floorOptionList,
                          initValue: "세부 공간 선택",
                          childPath: ""),
                    ],
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
}
