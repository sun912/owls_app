import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:owls_app/constants.dart';

class BasicDropdownWidget extends StatefulWidget {
  final String initValue;

  const BasicDropdownWidget({
    Key? key,
    required this.initValue,
  }) : super(key: key);

  @override
  State<BasicDropdownWidget> createState() => _BasicDropdownWidget();
}

class _BasicDropdownWidget extends State<BasicDropdownWidget> {
  late String _dropdownValue;
  late List<dynamic> dropdownList;
  @override
  void initState() {
    _dropdownValue = widget.initValue;
    dropdownList = [];
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
              height: 10,
              child: SingleChildScrollView(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemCount: dropdownList.length,
                  itemBuilder: (context, index) {
                    return CupertinoButton(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      pressedOpacity: 0.5,
                      minSize: 0,
                      onPressed: () {
                        setState(() {
                          _dropdownValue = dropdownList.elementAt(index).name;
                        });
                        _removeOverlay();
                      },
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          dropdownList.elementAt(index).name,
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
