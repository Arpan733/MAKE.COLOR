import 'package:flutter/material.dart';

import 'Home.dart';
import 'Generate.dart';
import 'Save.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _ci = 1;
  Color c = Colors.white;

  @override
  Widget build(BuildContext context) {
    final List<Widget> f = [Generate(), Home(), Save()];

    return Scaffold(
      body: SingleChildScrollView(
        child: f[_ci],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.change_circle_sharp,
            ),
            label: 'Generate'
          ),
          BottomNavigationBarItem(
             icon: Icon(
              Icons.home_filled
            ),
            label: 'Home'
          ),
          BottomNavigationBarItem(
             icon: Icon(
              Icons.save
            ),
            label: 'Save'
          ),
        ],
        currentIndex: _ci,
        onTap: (int i) {
          setState(() {
            _ci = i;
          });
        },
        backgroundColor: _ci == 1 ? Colors.black : Colors.grey,
        selectedItemColor: Colors.white,
        selectedIconTheme: IconThemeData(
          size: 32
        ),
        selectedLabelStyle: TextStyle(
          fontSize: 18,
          fontFamily: 'Degular',
        ),
        unselectedItemColor: Colors.black54,
        unselectedIconTheme: IconThemeData(
          size: 28
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 14,
          fontFamily: 'Degular',
        ),
      ),
    );
  }
}
