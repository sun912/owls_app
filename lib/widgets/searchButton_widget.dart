import 'package:flutter/material.dart';
import 'package:owls_app/constants.dart';
import 'package:owls_app/data/requestPlaceProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class SearchButtonWidget extends StatefulWidget {
  const SearchButtonWidget({Key? key}) : super(key: key);

  @override
  State<SearchButtonWidget> createState() => _SearchButtonWidgetState();
}

class _SearchButtonWidgetState extends State<SearchButtonWidget> {
  late RequestPlaceProvider provider;

  Future<void> onSearch() async {
    provider.setIsSearched(true);

    var pref = await SharedPreferences.getInstance();
    var placeList = pref.getStringList(placePref);

    for (int i = 0; i < 3; i++) {
      if (placeList!.contains(provider.getSelectedPlaceName[i]) == false) {
        logger.d(provider.getSelectedPlaceName);

        placeList[i] = provider.getSelectedPlaceName[i];
      }
    }
    logger.d(placeList!);
    pref.setStringList(placePref, placeList!);
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<RequestPlaceProvider>(context, listen: false);
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
    provider = Provider.of<RequestPlaceProvider>(context, listen: false);
  }
}
