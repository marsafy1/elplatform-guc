import 'package:flutter/material.dart';
import './components/tabController.dart';
// importing extra pages that will be placed in the drawer
import './components/pages/extra_pages/aboutUs.dart';
import './components/pages/extra_pages/contacts.dart';
import './components/pages/extra_pages/courses.dart';
import './components/pages/extra_pages/instructors.dart';
import './components/pages/extra_pages/navigation.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      // themeMode: ThemeMode.system,
      themeMode: ThemeMode.dark,
      initialRoute: '/',
      routes: {
        '/': (dummCtx) => TabsControllerScreen(),
        '/contacts': (dummyCtx) => Contacts(),
        '/navigation': (dummyCtx) => Navigation(),
        '/courses': (dummyCtx) => Courses(),
        '/instructors': (dummyCtx) => Instructors(),
        '/aboutUs': (dummyCtx) => AboutUs(),
      },
    );
  }
}
