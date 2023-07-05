import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:owls_app/data/floor_data.dart';
import 'package:owls_app/data/site_data.dart';
import 'package:owls_app/data/space_data.dart';
import 'package:owls_app/main.dart';

class RequestPlaceProvider with ChangeNotifier {
  List<SiteData> _siteOptionList = [];
  List<SpaceData> _spaceOptionList = [];
  List<FloorData> _floorOptionList = [];
  String _siteId = "";
  String _spaceId = "";
  String _floorId = "";

  List<SiteData> get siteOptionList => _siteOptionList;
  List<SpaceData> get spaceOptionList => _spaceOptionList;
  List<FloorData> get floorOptionList => _floorOptionList;
  String get getSelectedSiteId => _siteId;
  String get getSelectedSpaceId => _spaceId;
  String get getSelectedFloorId => _floorId;

  void siteId(String value) {
    _siteId = value;
    notifyListeners();
  }

  void spaceId(String value) {
    _spaceId = value;
    notifyListeners();
  }

  void floorId(String value) {
    _floorId = value;
    notifyListeners();
  }

  Future<List?> requestNextOption(
      String baseUrl, String childPath, Map<String, dynamic>? param) async {
    Uri uri = Uri.https(baseUrl, childPath, param);
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      List<dynamic> parsedJson = jsonDecode(utf8.decode(response.bodyBytes));

      if (childPath == "/site") {
        _siteOptionList =
            parsedJson.map((json) => SiteData.fromJson(json)).toList();
        notifyListeners();
        return _siteOptionList;
      } else if (childPath == "/space") {
        _spaceOptionList =
            parsedJson.map((json) => SpaceData.fromJson(json)).toList();
        notifyListeners();
        return _spaceOptionList;
      } else if (childPath == "/floor") {
        logger.d(uri);

        _floorOptionList =
            parsedJson.map((json) => FloorData.fromJson(json)).toList();
        notifyListeners();

        return _floorOptionList;
      }
    } else if (response.statusCode >= 400) {
      throw Exception("400 Error");
    } else if (response.statusCode >= 500) {
      throw Exception("500 Error");
    }
  }
}
