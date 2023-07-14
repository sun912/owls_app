import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:owls_app/constants.dart';
import 'package:owls_app/data/floor_data.dart';
import 'package:owls_app/data/owlsTheme_data.dart';
import 'package:owls_app/data/requestPlaceProvider.dart';
import 'package:owls_app/data/space_data.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlaceDropdownWidget extends StatefulWidget {
  final List<dynamic> dropdownList;
  final String initValue;
  final String? childPath;

  PlaceDropdownWidget({
    Key? key,
    required this.dropdownList,
    required this.initValue,
    this.childPath,
  }) : super(key: key);

  @override
  State<PlaceDropdownWidget> createState() => _PlaceDropdownWidget();
}

class _PlaceDropdownWidget extends State<PlaceDropdownWidget> {
  late String _dropdownValue;
  late SharedPreferences prefs;
  late RequestPlaceProvider provider;

  bool isHovered = false;

  @override
  void initState() {
    _dropdownValue = widget.initValue;
  }

  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  static const double _dropdownWidth = 200;

  // static const double _dropdownHeight = 50;

  void _createOverlay() {
    if (_overlayEntry == null) {
      _overlayEntry = _customDropdown();
      Overlay.of(context)!.insert(_overlayEntry!);
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _overlayEntry?.dispose();
    super.dispose();
  }

  @override
  Future<void> didChangeDependencies() async {
    provider = Provider.of<RequestPlaceProvider>(context);

    prefs = await SharedPreferences.getInstance();
    // pref = await initPlace();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _overlayEntry?.remove();
      },
      child: InkWell(
        onTap: () {
          _overlayEntry == null ? _createOverlay() : _removeOverlay();
        },
        onHover: (value) {
          setState(() {
            isHovered = value;
          });
        },
        hoverColor: OwlsThemeData.color.hoverColor,
        child: CompositedTransformTarget(
          link: _layerLink,
          child: Container(
            padding: EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(
              horizontal: 30,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color:
                  isHovered ? OwlsThemeData.color.hoverColor : backgroundColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: _dropdownWidth,
                  child: Text(
                    _dropdownValue,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 22 / 16,
                      color: Colors.black,
                    ),
                  ),
                ),
                _overlayEntry == null
                    ? const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 24,
                      )
                    : const Icon(
                        Icons.keyboard_arrow_up_rounded,
                        size: 24,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  OverlayEntry _customDropdown() {
    return OverlayEntry(
      maintainState: true,
      builder: (context) => Positioned(
        width: _dropdownWidth,
        child: CompositedTransformFollower(
          targetAnchor: Alignment.bottomCenter,
          followerAnchor: Alignment.topCenter,
          link: _layerLink,
          offset: const Offset(0, 7),
          child: Material(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 2,
            color: backgroundColor,
            child: Container(
              alignment: Alignment.center,
              height: widget.dropdownList.length > 0
                  ? (22.0 * widget.dropdownList.length) +
                      (21 * (widget.dropdownList.length - 1)) +
                      20
                  : 1,
              child: SingleChildScrollView(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemCount: widget.dropdownList.length,
                  itemBuilder: (context, index) {
                    return CupertinoButton(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      pressedOpacity: 0.5,
                      minSize: 1,
                      onPressed: () async {
                        // setState(() {
                        //   _dropdownValue =
                        //       widget.dropdownList.elementAt(index).name;
                        // });
                        _dropdownValue =
                            widget.dropdownList.elementAt(index).name;

                        final checkedPlaceListPrefs =
                            prefs.getStringList(placePref);

                        if (widget.childPath == "/space") {
                          var site = widget.dropdownList.elementAt(index);
                          provider.setSiteNameList = widget.dropdownList
                              .map<String>((value) => value.name)
                              .toList();

                          provider.setSelectedSiteId = site.id;
                          var responseNextOption = provider.requestNextOption(
                              baseUrl,
                              widget.childPath ?? "",
                              {"site_id": site.id});
                          responseNextOption.then((spaceList) {
                            if (spaceList != null) {
                              provider.setSpaceOptionList =
                                  spaceList as List<SpaceData>;
                            } else {
                              provider.setSpaceOptionList = [
                                SpaceData(id: "none", name: "없음")
                              ];
                            }
                          });
                          provider.setSelectedPlaceName(0, site.name);

                          if (checkedPlaceListPrefs!.isNotEmpty &&
                              site.name != null) {
                            checkedPlaceListPrefs?[0] = site.name;
                          }
                          if (prefs?.getString("selectedSiteId") == null ||
                              prefs?.getString("selectedSiteId") != site.id) {
                            provider.setIsChanged = true;
                            // await prefs?.setString("selectedSiteId", site.id);
                          }
                          await prefs?.setString("selectedSiteId", site.id);
                        } else if (widget.childPath == "/floor") {
                          var space = widget.dropdownList.elementAt(index);

                          provider.setSpaceNameList = widget.dropdownList
                              .map<String>((value) => value.name)
                              .toList();
                          provider.setSelectedSpaceId = space.id;

                          var responseNextOption = provider.requestNextOption(
                              baseUrl, widget.childPath ?? "", {
                            "site_id": prefs?.getString("selectedSiteId"),
                            "space_id": space.id,
                          });
                          responseNextOption.then((floorList) {
                            if (floorList != null) {
                              provider.setFloorOptionList =
                                  floorList as List<FloorData>;
                            } else {
                              provider.setFloorOptionList = [
                                FloorData(name: "없음", id: "none")
                              ];
                            }
                          });
                          // provider.selectedSpace = space;
                          provider.setSelectedPlaceName(1, space.name);

                          if (checkedPlaceListPrefs!.isNotEmpty) {
                            if (checkedPlaceListPrefs.contains(space.name) ==
                                false) {
                              checkedPlaceListPrefs?[1] = space.name;
                            }
                          }

                          List<String> spaceList = provider.getSpaceOptionList
                              .map((element) => jsonEncode(element.toJson()))
                              .toList();
                          if (spaceList.isNotEmpty) {
                            prefs?.setStringList("spaceList", spaceList);
                          }
                          prefs?.setString("selectedSpaceId", space.id);

                          if (prefs?.getString("selectedSpaceId") == null ||
                              prefs?.getString("selectedSpaceId") != space.id) {
                            provider.setIsChanged = true;
                          }
                          await prefs?.setString("selectedSpaceId", space.id);
                        } else {
                          var floor = widget.dropdownList.elementAt(index);
                          provider.setFloorNameList = widget.dropdownList
                              .map<String>((value) => value.name)
                              .toList();
                          if (provider.getFloorImageUrl !=
                                  floor.floorImageUrl &&
                              floor.floorImageUrl != null) {
                            provider.floorImageUrl = floor.floorImageUrl;
                          } else {
                            provider.floorImageUrl = "";
                          }
                          provider.setSelectedPlaceName(2, floor.name);

                          if (prefs?.getString("selectedFloorId") == null ||
                              prefs?.getString("selectedFloorId") != floor.id) {
                            provider.setIsChanged = true;
                          }

                          if (checkedPlaceListPrefs!.isNotEmpty) {
                            if (checkedPlaceListPrefs.contains(floor.name) ==
                                false) {
                              checkedPlaceListPrefs?[2] = floor.name;
                            }
                          }
                          List<String> floorList = provider.getFloorOptionList
                              .map((element) => jsonEncode(element.toJson()))
                              .toList();
                          if (floorList.isNotEmpty) {
                            prefs?.setStringList("floorList", floorList);
                          }
                          await prefs?.setString("selectedFloorId", floor.id);
                        }

                        _removeOverlay();
                      },
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          widget.dropdownList.elementAt(index).name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            height: 22 / 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Divider(
                        color: primaryAncient,
                        height: 20,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
