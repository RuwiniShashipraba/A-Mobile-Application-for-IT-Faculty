import 'package:flutter/material.dart';
import 'package:falcon/screens/students/stu_screen/chat_Divider.dart';
import 'package:falcon/login.dart';
import 'package:falcon/screens/students/components/stHomeBody.dart';
import 'package:flutter_svg/svg.dart';
import 'package:falcon/screens/students/sidebar/navigation_drawer_widget.dart';
import 'package:falcon/screens/students/stu_screen/CalenderScreen.dart';
import 'package:falcon/screens/students/stu_screen/news.dart';

class StuHome extends StatefulWidget {
  @override
  State<StuHome> createState() => _StuHomeState();
}

class _StuHomeState extends State<StuHome> {
  int currentIndex = 0;

  final screens = [
    Body(),
    Calender_Screen(),
    ChScreen(),
    News(),
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
                    icon: Icon(Icons.menu),
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
            icon: Icon(Icons.calendar_today),
            label: 'Calender',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum),
            label: 'Forum',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'News',
          ),
        ],
      ),
    );
  }
}
