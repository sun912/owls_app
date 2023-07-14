import 'dart:convert';
import 'dart:js_interop';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:owls_app/data/floor_data.dart';
import 'package:owls_app/data/site_data.dart';
import 'package:owls_app/data/space_data.dart';
import 'package:owls_app/data/warningItem_data.dart';

class RequestPlaceProvider with ChangeNotifier {
  List<SiteData> _siteOptionList = [SiteData(id: "None", name: "없음")];
  List<SpaceData> _spaceOptionList = [SpaceData(id: "None", name: "없음")];
  List<FloorData> _floorOptionList = [FloorData(id: "None", name: "없음")];
  List<String> _selectedPlaceName = List.filled(3, "");
  List<WarningItemData>? _warningItemList;

  late SiteData _selectedSite;
  late SpaceData _selectedSpace;
  late FloorData _selectedFloor;
  bool _isSearched = false;
  bool _isChanged = false;
  String _siteId = "";
  String _spaceId = "";
  String _floorImageUrl = "";
  List<String>? _siteNameList;
  List<String>? _spaceNameList;
  List<String>? _floorNameList;

  List<SiteData> get getSiteOptionList => _siteOptionList;
  List<SpaceData> get getSpaceOptionList => _spaceOptionList;
  List<FloorData> get getFloorOptionList => _floorOptionList;
  List<WarningItemData>? get getWarningItemList => _warningItemList;
  List<String>? get getSiteNameList => _siteNameList;
  List<String>? get getSpaceNameList => _spaceNameList;
  List<String>? get getFloorNameList => _floorNameList;

  String get getFloorImageUrl => _floorImageUrl;
  String get getSelectedSiteId => _siteId;
  String get getSelectedSpaceId => _spaceId;

  SiteData get selectedSite => _selectedSite;
  SpaceData get selectedSpace => _selectedSpace;
  FloorData get selectedFloor => _selectedFloor;

  bool get isSearched => _isSearched;
  bool get isChanged => _isChanged;
  List<String> get getSelectedPlaceName => _selectedPlaceName;

  set setIsChanged(bool value) {
    _isChanged = value;
    notifyListeners();
  }

  set setSiteNameList(List<String> siteNames) {
    _siteNameList = siteNames;
    notifyListeners();
  }

  set setSpaceNameList(List<String> spaceNames) {
    _spaceNameList = spaceNames;
    notifyListeners();
  }

  set setFloorNameList(List<String> floorNames) {
    _floorNameList = floorNames;
    notifyListeners();
  }

  set setWarningItemList(List<WarningItemData> warnings) {
    _warningItemList = warnings;
    notifyListeners();
  }

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

  set setSiteOptionList(List<SiteData> value) {
    _siteOptionList = value;
    notifyListeners();
  }

  set setSpaceOptionList(List<SpaceData> value) {
    _spaceOptionList = value;
    notifyListeners();
  }

  set setFloorOptionList(List<FloorData> value) {
    _floorOptionList = value;
    notifyListeners();
  }

  set setSelectedSiteId(String? value) {
    _siteId = value!;
    notifyListeners();
  }

  set setSelectedSpaceId(String value) {
    _spaceId = value;
    notifyListeners();
  }

  Future<List?> requestNextOption(
      String baseUrl, String childPath, Map<String, dynamic>? param) async {
    Uri uri = Uri.https(baseUrl, childPath, param);
    var response = await http.get(uri);

    if (response.statusCode == 200 &&
        response.contentLength.isDefinedAndNotNull) {
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
      throw Exception("400 Error, $uri");
    } else if (response.statusCode >= 500) {
      throw Exception("500 Error");
    }
  }
}
