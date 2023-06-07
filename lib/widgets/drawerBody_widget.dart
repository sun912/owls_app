import 'package:flutter/material.dart';
import 'package:owls_app/constants.dart';

class DrawerBodyWidget extends StatelessWidget {
  const DrawerBodyWidget({Key? key}) : super(key: key);
  final name = '김엘지';
  final email = 'lg.kim@abc.com';
  final urlImage = 'user1.png';
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      width: 400,
      child: ListView(
        children: [
          buildHeader(urlImage: urlImage, name: name, email: email),
          Container(
            padding: itemPadding,
            child: Column(
              children: [
                buildMenuItem(
                  label: 'Home',
                  icon: Icons.home,
                  context: context,
                  route: '/',
                ),
                buildMenuItem(
                  label: 'Analytics',
                  icon: Icons.analytics_rounded,
                  context: context,
                  route: '/analytics',
                ),
                buildMenuItem(
                  label: 'Configurations',
                  icon: Icons.settings_rounded,
                  context: context,
                  route: '/settings',
                ),
                buildMenuItem(
                  label: 'Q&A',
                  icon: Icons.question_answer_rounded,
                  context: context,
                  route: '/qna',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildHeader(
    {required String urlImage, required String name, required String email}) {
  return InkWell(
    child: Container(
      decoration: const BoxDecoration(
        color: primaryLight60,
      ),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage('assets/${urlImage}'),
          ),
          SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(fontSize: 20, color: primaryAncient),
              ),
              SizedBox(height: 4),
              Text(
                email,
                style: TextStyle(fontSize: 14, color: primaryAncient),
              ),
            ],
          )
        ],
      ),
    ),
  );
}

Widget buildMenuItem({
  required String label,
  required IconData icon,
  required BuildContext context,
  required String route,
}) {
  final color = primaryAncient;

  return ListTile(
    contentPadding: EdgeInsets.all(20.0),
    // minVerticalPadding: 30.0,
    leading: Icon(icon, color: color),
    onTap: () {
      Navigator.pushNamed(context, route);
    },
    title: Text(
      label,
      style: TextStyle(
        color: color,
      ),
    ),
  );
}
