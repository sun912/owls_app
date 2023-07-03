import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:owls_app/constants.dart';

class CustomDropdownPage extends StatefulWidget {
  final List<String> dropdownList;
  final String initValue;
  const CustomDropdownPage(
      {Key? key, required this.dropdownList, required this.initValue})
      : super(key: key);

  @override
  State<CustomDropdownPage> createState() => _CustomDropdownPageState();
}

class _CustomDropdownPageState extends State<CustomDropdownPage> {
  late String _dropdownValue;

  @override
  void initState() {
    _dropdownValue = widget.initValue;
  }

  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  static const double _dropdownWidth = 300;

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
          child: ClipRRect(
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 0,
              ),
              margin: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: primaryAncient,
                  width: 3.0,
                ),
                color: backgroundColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    _dropdownValue,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 22 / 16,
                      color: Colors.black,
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
          offset: const Offset(0, 0),
          child: Material(
            color: backgroundColor,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
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
                                widget.dropdownList.elementAt(index);
                          });
                          _removeOverlay();
                        },
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            widget.dropdownList.elementAt(index),
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
      ),
    );
  }
}
