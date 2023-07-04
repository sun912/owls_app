import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:owls_app/constants.dart';
import 'package:owls_app/data/site_data.dart';
import 'package:owls_app/widgets/basicDropdown_widget.dart';
import 'package:owls_app/widgets/map_widget.dart';
import 'package:owls_app/widgets/placeDropdown_widget.dart';
import 'package:owls_app/widgets/rightSideBar_widget.dart';

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
  late Future<List<SiteData>>? futureSite;
  late Future<List<dynamic>> futurePlaceOption;
  @override
  void initState() {
    super.initState();
    futureSite = widget.requestSites();
  }

  void _setPlaceOption(Future<List<dynamic>> value) {
    setState(() {
      futurePlaceOption = value;
    });
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
                  start: _size.width / 9,
                  end: 50,
                  top: 35,
                  child: FutureBuilder(
                    future: futureSite,
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasData) {
                        return Row(
                          children: [
                            PlaceDropdownWidget(
                              dropdownList: snapshot.data,
                              initValue: "지역 선택",
                              setPlaceOption: _setPlaceOption,
                              childPath: "/space",
                            ),
                            BasicDropdownWidget(initValue: "건물 선택"),

                            // BasicDropdownWidget(initValue: "층수 선택"),
                            // FutureBuilder(
                            //   future: futurePlaceOption,
                            //   builder: (BuildContext context,
                            //       AsyncSnapshot<List<dynamic>> snapshot) {
                            //     if (snapshot.hasData) {
                            //       return PlaceDropdownWidget(
                            //         dropdownList: snapshot.data!,
                            //         initValue: "건물 선택",
                            //         setPlaceOption: _setPlaceOption,
                            //         childPath: "/floor",
                            //       );
                            //     } else if (snapshot.hasError) {
                            //       throw Exception(snapshot.error);
                            //     }
                            //     return BasicDropdownWidget(initValue: "건물 선택");
                            //   },
                            // ),
                            // FutureBuilder(
                            //   future: futurePlaceOption,
                            //   builder: (BuildContext context,
                            //       AsyncSnapshot<List<dynamic>> snapshot) {
                            //     if (snapshot.hasData) {
                            //       return PlaceDropdownWidget(
                            //         dropdownList: snapshot.data!,
                            //         initValue: "상세 공간 선택",
                            //         setPlaceOption: _setPlaceOption,
                            //         childPath: '',
                            //       );
                            //     } else if (snapshot.hasError) {
                            //       throw Exception(snapshot.error);
                            //     }
                            //     return BasicDropdownWidget(
                            //         initValue: "상세 공간 선택");
                            //   },
                            // ),
                          ],
                        );
                      } else if (snapshot.hasError) {
                        throw Exception(snapshot.error);
                      }

                      return CircularProgressIndicator();
                    },
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
