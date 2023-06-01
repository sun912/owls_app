import 'package:flutter/material.dart';
import 'package:owls_app/constants.dart';
import 'package:owls_app/widgets/rightSideBar_widget.dart';

class ScaffoldBodyWidget extends StatelessWidget {
  const ScaffoldBodyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        children: [
          // NavigationRail(
          //   useIndicator: true,
          //   indicatorColor: Colors.white,
          //   minWidth: 80,
          //   indicatorShape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(90),
          //   ),
          //   backgroundColor: primary,
          //   selectedIndex: _selectedIndex,
          //   labelType: NavigationRailLabelType.all,
          //   selectedIconTheme: const IconThemeData(
          //     color: primaryAncient,
          //   ),
          //   unselectedLabelTextStyle: TextStyle(
          //     color: Colors.white,
          //   ),
          //   selectedLabelTextStyle: const TextStyle(
          //     color: primaryAncient,
          //   ),
          //   onDestinationSelected: (int index) {
          //     setState(() {
          //       _selectedIndex = index;
          //     });
          //   },
          //   destinations: const <NavigationRailDestination>[
          //     NavigationRailDestination(
          //       icon: Icon(
          //         Icons.home_outlined,
          //         color: Colors.white,
          //       ),
          //       selectedIcon: Icon(
          //         Icons.home,
          //         color: primaryAncient,
          //       ),
          //       label: Text('Home'),
          //     ),
          //     NavigationRailDestination(
          //       icon: Icon(
          //         Icons.analytics_outlined,
          //         color: Colors.white,
          //       ),
          //       selectedIcon: Icon(
          //         Icons.analytics_rounded,
          //         color: primaryAncient,
          //       ),
          //       label: Text('Analytics'),
          //     ),
          //     NavigationRailDestination(
          //       icon: Icon(
          //         Icons.account_circle_outlined,
          //         color: Colors.white,
          //       ),
          //       selectedIcon: Icon(
          //         Icons.account_circle_rounded,
          //         color: primaryAncient,
          //       ),
          //       label: Text('User'),
          //     ),
          //     NavigationRailDestination(
          //       icon: Icon(
          //         Icons.settings_outlined,
          //         color: Colors.white,
          //       ),
          //       selectedIcon: Icon(
          //         Icons.settings_rounded,
          //         color: primaryAncient,
          //       ),
          //       label: Text('Settings'),
          //     ),
          //   ],
          // ),
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
                  Center(
                    child: Text(
                      'Map',
                      style: TextStyle(
                        fontSize: 48,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const RightSideBarWidget(),
        ],
      ),
    );
  }
}
