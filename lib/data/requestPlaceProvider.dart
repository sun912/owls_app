import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:owls_app/data/floor_data.dart';
import 'package:owls_app/data/site_data.dart';
import 'package:owls_app/data/space_data.dart';

class RequestPlaceProvider with ChangeNotifier {
  List<SiteData> _siteOptionList = [];
  List<SpaceData> _spaceOptionList = [];
  List<FloorData> _floorOptionList = [];
  List<String> _selectedPlaceName = List.filled(3, "");

  late SiteData _selectedSite;
  late SpaceData _selectedSpace;
  late FloorData _selectedFloor;

  String _siteId = "";
  String _spaceId = "";
  String _floorId = "";
  String _floorImageUrl = "";
  bool _isSearched = false;

  List<SiteData> get getSiteOptionList => _siteOptionList;
  List<SpaceData> get getSpaceOptionList => _spaceOptionList;
  List<FloorData> get getFloorOptionList => _floorOptionList;
  String get getFloorImageUrl => _floorImageUrl;

  String get getSelectedSiteId => _siteId;
  String get getSelectedSpaceId => _spaceId;
  String get getSelectedFloorId => _floorId;

  SiteData get selectedSite => _selectedSite;
  SpaceData get selectedSpace => _selectedSpace;
  FloorData get selectedFloor => _selectedFloor;

  bool get isSearched => _isSearched;
  List<String> get getSelectedPlaceName => _selectedPlaceName;

  set selectedSite(SiteData value) {
    _selectedSite = value;
    notifyListeners();
  }

  set selectedSpace(SpaceData value) {
    _selectedSpace = value;
    notifyListeners();
  }

  set selectedFloor(FloorData value) {
    _selectedFloor = value;
    notifyListeners();
  }

  set floorImageUrl(String value) {
    _floorImageUrl = value;
    notifyListeners();
  }

  void setSelectedPlaceName(int index, String value) {
    _selectedPlaceName[index] = value;
    notifyListeners();
  }

  void setIsSearched(bool value) {
    _isSearched = value;
    notifyListeners();
  }

  void siteId(String value) {
    _siteId = value;
    notifyListeners();
  }

  void spaceId(String value) {
    _spaceId = value;
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

  void floorId(String value) {
    _floorId = value;
    notifyListeners();
  }
}
