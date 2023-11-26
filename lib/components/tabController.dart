import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// importing tabs controller
import './tabsController/glassyNavbar.dart';
// importing the drawer
import './drawerWidget.dart';
// importing the main pages
import './pages/homePage.dart';
import './pages/confessionsPage.dart';
import './pages/questionsPage.dart';
import './pages/lostAndFoundsPage.dart';
import './pages/notificationsPage.dart';

class TabsControllerScreen extends StatefulWidget {
  @override
  _TabsControllerScreenState createState() => _TabsControllerScreenState();
}

class _TabsControllerScreenState extends State<TabsControllerScreen> {
  final List<Widget> myPages = [
    HomePage(),
    ConfessionsPage(),
    QuestionsPage(),
    LostAndFoundsPage(),
    NotificationsPage()
    // Add other page widgets here
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
        title: Text('elPlatform'),
        backgroundColor: Color.fromARGB(255, 9, 5, 5).withOpacity(0.3),
      ),
      drawer: MainDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: myPages[selectedTabIndex],
      ),
      bottomNavigationBar: GlassMorphicBottomNavigationBar(
        selectedIndex: selectedTabIndex,
        onItemSelected: switchPage,
        listItems: [
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.house),
            label: 'Home', // Empty string for label
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.solidHeart),
            label: 'Confessions', // Empty string for label
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.fileCircleQuestion),
            label: 'Q/A', // Empty string for label
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.suitcase),
            label: 'Lost & Founds', // Empty string for label
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.solidBell),
            label: 'Noitifications', // Empty string for label
          ),
          // Add more items as needed
        ],
      ),
    );
  }
}
