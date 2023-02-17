import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:falcon/login.dart';
import 'package:falcon/screens/lecturer/components/lecHomeBody.dart';
import 'package:falcon/screens/lecturer/inComponenet/Chat/lecChat_Divider.dart';
import 'package:falcon/screens/lecturer/sidebar/navigation_drawer_widget.dart';

class LecHome extends StatefulWidget {
  @override
  State<LecHome> createState() => _LecHomeState();
}

class _LecHomeState extends State<LecHome> {
  int currentIndex = 0;

  final screens = [
    LBody(),
    ChScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          leading: Builder(
              builder: (context) => IconButton(
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    icon: SvgPicture.asset("assets/icons/menu.svg"),
                  )),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {},
            ),
          ]),
      drawer: NavigationDrawerWidget(),
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        //backgroundColor: Colors.white54,
        selectedItemColor: Color(0xff0b3140),
        unselectedItemColor: Color(0xff384c54),
        showUnselectedLabels: false,
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum),
            label: 'Forum',
          ),
        ],
      ),
    );
  }
}
