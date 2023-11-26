import 'package:flutter/material.dart';
import './drawerWidget.dart';
import './pages/homePage.dart';

class TabsControllerScreen extends StatefulWidget {
  @override
  _TabsControllerScreenState createState() => _TabsControllerScreenState();
}

class _TabsControllerScreenState extends State<TabsControllerScreen> {
  final List<Widget> myPages = [
    HomePage(),
  ];
  var selectedTabIndex = 0;
  void switchPage(int index) {
    setState(() {
      selectedTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('ElMatbakh'),
        ),
        drawer: MainDrawer(),
        body: myPages[selectedTabIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.fastfood_rounded), label: 'Categories'),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite_rounded), label: 'Favorites'),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: 'Settings')
          ],
          currentIndex: selectedTabIndex,
          onTap: switchPage,
        ));
  }
}
