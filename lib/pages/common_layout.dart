import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'garden_page.dart';
import 'home_page.dart';
import 'map_page.dart';
import 'profile_page.dart';
import 'quiz_page.dart';

class CommonLayout extends StatefulWidget {
  final Widget child;
  final int selectedIndex;

  CommonLayout({required this.child, required this.selectedIndex});

  @override
  _CommonLayoutState createState() => _CommonLayoutState();
}

class _CommonLayoutState extends State<CommonLayout> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    } else if (index == 1) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => QuizPage()));
    } else if (index == 2) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GardenPage()));
    } else if (index == 3) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MapPage()));
    } else if (index == 4) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfilePage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: '미션'),
          BottomNavigationBarItem(icon: Icon(Icons.quiz), label: '퀴즈'),
          BottomNavigationBarItem(icon: Icon(Icons.local_florist), label: '가상 정원'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: '지도'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '프로필'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
    );
  }
}