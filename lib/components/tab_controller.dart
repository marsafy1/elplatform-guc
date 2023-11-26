import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guc_swiss_knife/configs/constants.dart';

import 'tabs_controller/glassy_navbar.dart';
import 'drawer_widget.dart';
import '../pages/home_page.dart';
import '../pages/confessions_page.dart';
import '../pages/questions_page.dart';
import '../pages/lost_and_founds_page.dart';
import '../pages/notifications_page.dart';

class TabsControllerScreen extends StatefulWidget {
  const TabsControllerScreen({super.key});

  @override
  _TabsControllerScreenState createState() => _TabsControllerScreenState();
}

class _TabsControllerScreenState extends State<TabsControllerScreen> {
  final List<Widget> myPages = const [
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
        title: const Text(appName),
        backgroundColor: const Color.fromARGB(255, 9, 5, 5).withOpacity(0.3),
      ),
      drawer: MainDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: myPages[selectedTabIndex],
      ),
      bottomNavigationBar: GlassMorphicBottomNavigationBar(
        selectedIndex: selectedTabIndex,
        onItemSelected: switchPage,
        listItems: const [
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
            label: 'Notifications', // Empty string for label
          ),
          // Add more items as needed
        ],
      ),
    );
  }
}
