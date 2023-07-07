import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:owls_app/constants.dart';
import 'package:owls_app/data/owlsTheme_data.dart';
import 'package:owls_app/data/requestPlaceProvider.dart';
import 'package:owls_app/main.dart';
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
  late SharedPreferences pref;
  late RequestPlaceProvider provider;

  bool isHovered = false;
  @override
  void initState() {}

  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  static const double _dropdownWidth = 200;

  // static const double _dropdownHeight = 50;

  void _createOverlay(RequestPlaceProvider provider) {
    if (_overlayEntry == null) {
      _overlayEntry = _customDropdown(provider);
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
    provider = Provider.of<RequestPlaceProvider>(context, listen: false);
    _dropdownValue = widget.initValue;
    pref = await SharedPreferences.getInstance();
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
          _overlayEntry == null ? _createOverlay(provider) : _removeOverlay();
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

  OverlayEntry _customDropdown(RequestPlaceProvider provider) {
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
                      onPressed: () {
                        setState(() {
                          _dropdownValue =
                              widget.dropdownList.elementAt(index).name;
                        });

                        final checkedPlace = pref.getStringList(placePref);

                        if (widget.childPath == "/space") {
                          var site = widget.dropdownList.elementAt(index);
                          logger.d(
                              "childPath: ${widget.childPath}  site_id: ${site.id}");
                          provider.siteId(site.id);
                          provider.requestNextOption(baseUrl,
                              widget.childPath ?? "", {"site_id": site.id});
                          provider.selectedSite = site;
                          provider.setSelectedPlaceName(0, site.name);

                          if (checkedPlace!.isNotEmpty &&
                              site.name.isDefinedAndNotNull) {
                            if (checkedPlace.contains(site.name) == false) {
                              checkedPlace?[0] = site.name;
                            }
                          }
                        } else if (widget.childPath == "/floor") {
                          var space = widget.dropdownList.elementAt(index);
                          logger.d("childPath: ${widget.childPath}\n"
                              "space_id: ${space.id} \n"
                              "site_id: ${provider.getSelectedSiteId}");

                          provider.spaceId(space.id);
                          provider.requestNextOption(
                              baseUrl, widget.childPath ?? "", {
                            "site_id": provider.getSelectedSiteId,
                            "space_id": provider.getSelectedSpaceId,
                          });
                          provider.selectedSpace = space;
                          provider.setSelectedPlaceName(1, space.name);

                          if (checkedPlace!.isNotEmpty) {
                            if (checkedPlace.contains(space.name) == false) {
                              checkedPlace?[1] = space.name;
                            }
                          }
                        } else {
                          var floor = widget.dropdownList.elementAt(index);
                          if (provider.getFloorImageUrl !=
                                  floor.floorImageUrl &&
                              floor.floorImageUrl != null) {
                            provider.floorImageUrl = floor.floorImageUrl;

                            provider.selectedFloor = floor;
                            provider.setSelectedPlaceName(2, floor.name);
                          }

                          if (checkedPlace!.isNotEmpty) {
                            if (checkedPlace.contains(floor.name) == false) {
                              checkedPlace?[2] = floor.name;
                            }
                          }
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
