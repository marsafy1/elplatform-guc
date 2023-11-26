import 'package:flutter/material.dart';
import './components/tabController.dart';

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
      },
    );
  }
}
