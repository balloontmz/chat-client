import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeBottomNavigationBar extends StatefulWidget {
  final Function clickButton;

  HomeBottomNavigationBar(this.clickButton);

  @override
  _HomeBottomNavigationBarState createState() =>
      _HomeBottomNavigationBarState();
}

class _HomeBottomNavigationBarState extends State<HomeBottomNavigationBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      widget.clickButton(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('首页')),
        BottomNavigationBarItem(icon: Icon(Icons.business), title: Text('发现')),
        BottomNavigationBarItem(icon: Icon(Icons.person), title: Text('个人中心')),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Color(0xFF8c77ec),
      onTap: _onItemTapped,
    );
  }
}
