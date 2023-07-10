import 'package:flutter/material.dart';
import 'package:owls_app/constants.dart';
import 'package:owls_app/widgets/map_widget.dart';

class ScaffoldBodyWidget extends StatelessWidget {
  const ScaffoldBodyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        children: [
          Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.symmetric(
              horizontal: 80,
              vertical: 50,
            ),
            child: SizedBox.fromSize(
              size: const Size(40, 40),
              child: ClipOval(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Scaffold.of(context).openDrawer();
                    },
                    child: Container(
                      child: const Icon(
                        Icons.menu_sharp,
                        color: primaryAncient,
                        size: 36,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Expanded(
            flex: 3,
            child: ColoredBox(
              color: Color(0xFFFAFAFA),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: MapWidget(),
                  ),
                  // Center(
                  //   child: Text(
                  //     'Map',
                  //     style: TextStyle(
                  //       fontSize: 48,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          // const RightSideBarWidget(),
        ],
      ),
    );
  }
}
