import 'package:demo_2/Gujrat.dart';
import 'package:demo_2/Home.dart';

import 'package:demo_2/Famous_place.dart';
import 'package:demo_2/Account.dart';

import 'package:flutter/material.dart';
import 'package:flutter/src/material/bottom_navigation_bar.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class A1 extends StatefulWidget {
  const A1({Key? key}) : super(key: key);

  @override
  State<A1> createState() => _A1State();
}

class _A1State extends State<A1> {
  int _currentIndex = 0;
  late SharedPreferences pref;
  var user_id;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  init() async {
    pref = await SharedPreferences.getInstance();
    user_id = pref.getString('id');
  }

  final screens = [
    Home(),
    Famous_place(),
    Account(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color.fromRGBO(55, 91, 70, 1),
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ("Home")),
          BottomNavigationBarItem(
            icon: Icon(Icons.place),
            label: ("Famous"),
          ),
          // BottomNavigationBarItem(
          //     icon: Icon(Icons.list_alt_outlined), label: ("Add Place")),
          // BottomNavigationBarItem(icon: Icon(Icons.public), label: ("Public")),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_rounded),
            label: ("Account"),
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
