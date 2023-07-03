import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:owls_app/constants.dart';
import 'package:owls_app/data/floor_data.dart';
import 'package:owls_app/data/space_data.dart';
import 'package:owls_app/main.dart';

class PlaceDropdownWidget extends StatefulWidget {
  final List<dynamic> dropdownList;
  final String initValue;
  final Function setPlaceOption;
  final String childPath;

  const PlaceDropdownWidget({
    Key? key,
    required this.dropdownList,
    required this.initValue,
    required this.setPlaceOption,
    required this.childPath,
  }) : super(key: key);

  @override
  State<PlaceDropdownWidget> createState() => _PlaceDropdownWidget();
}

class _PlaceDropdownWidget extends State<PlaceDropdownWidget> {
  late String _dropdownValue;

  Future<List<dynamic>> requestNextOption(
      String baseUrl, String childPath, Map<String, dynamic> param) async {
    late List<dynamic> nextOptionList;
    Uri uri = Uri.https(baseUrl, childPath, param);
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      List<dynamic> parsedJson = jsonDecode(utf8.decode(response.bodyBytes));
      logger.d(parsedJson);
      if (childPath == "/space") {
        nextOptionList =
            parsedJson.map((json) => SpaceData.fromJson(json)).toList();
      } else {
        nextOptionList =
            parsedJson.map((json) => FloorData.fromJson(json)).toList();
      }

      return nextOptionList;
    } else {
      throw Exception();
    }
  }

  @override
  void initState() {
    _dropdownValue = widget.initValue;
  }

  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  static const double _dropdownWidth = 180;

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
  Widget build(BuildContext context) {
    // _dropdownValue = widget.initValue;
    return GestureDetector(
      onTap: () {
        _overlayEntry?.remove();
      },
      child: InkWell(
        onTap: () {
          _overlayEntry == null ? _createOverlay() : _removeOverlay();
        },
        child: CompositedTransformTarget(
          link: _layerLink,
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 10,
            ),
            margin: const EdgeInsets.symmetric(
              horizontal: 30,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: primaryLight60,
                width: 2.0,
              ),
              color: backgroundColor,
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
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 20,
                )
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
              height: (22.0 * widget.dropdownList.length) +
                  (21 * (widget.dropdownList.length - 1)) +
                  20,
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
                      minSize: 0,
                      onPressed: () {
                        setState(() {
                          _dropdownValue =
                              widget.dropdownList.elementAt(index).name;
                        });
                        if (widget.childPath == "/space") {
                          var futureNextOption = requestNextOption(
                              baseUrl, widget.childPath, {
                            "space_id":
                                "${widget.dropdownList.elementAt(index).id}"
                          });
                          widget.setPlaceOption(futureNextOption);
                        } else {
                          var futureNextOption = requestNextOption(
                              baseUrl, widget.childPath, {
                            "floor_id":
                                "${widget.dropdownList.elementAt(index).id}"
                          });
                          widget.setPlaceOption(futureNextOption);
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
