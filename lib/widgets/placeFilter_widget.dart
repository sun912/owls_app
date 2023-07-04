import 'package:flutter/material.dart';
import 'package:owls_app/data/site_data.dart';
import 'package:owls_app/widgets/basicDropdown_widget.dart';
import 'package:owls_app/widgets/placeDropdown_widget.dart';

class PlaceFilterWidget extends StatefulWidget {
  PlaceFilterWidget({Key? key, required this.siteList}) : super(key: key);
  final List<SiteData> siteList;
  late Future<List<dynamic>> placeOption;
  @override
  State<PlaceFilterWidget> createState() => _PlaceFilterWidgetState();
}

class _PlaceFilterWidgetState extends State<PlaceFilterWidget> {
  void _setPlaceOption(Future<List<dynamic>> value) {
    setState(() {
      widget.placeOption = value;
    });
  }
  //TODO: move row into scaffoldBodyStack_widget again

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        PlaceDropdownWidget(
            dropdownList: widget.siteList,
            initValue: "지역 선택",
            setPlaceOption: _setPlaceOption,
            childPath: "/space"),
        FutureBuilder(
          future: widget.placeOption, //TODO: replace right future
          builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.hasData) {
              return PlaceDropdownWidget(
                dropdownList: snapshot.data!,
                initValue: "건물 선택",
                setPlaceOption: _setPlaceOption,
                childPath: "/floor",
              );
            } else if (snapshot.hasError) {
              throw Exception(snapshot.error);
            }
            return BasicDropdownWidget(initValue: "건물 선택");
          },
        ),
        FutureBuilder(
          future: widget.placeOption,
          builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.hasData) {
              return PlaceDropdownWidget(
                dropdownList: snapshot.data!,
                initValue: "상세 공간 선택",
                setPlaceOption: _setPlaceOption,
                childPath: "/map",
              );
            } else if (snapshot.hasError) {
              throw Exception(snapshot.error);
            }
            return BasicDropdownWidget(initValue: "상세 공간 선택");
          },
        ),
      ],
    );
  }
}
