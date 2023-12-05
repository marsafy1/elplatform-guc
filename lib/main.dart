import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:guc_swiss_knife/configs/constants.dart';
import 'package:guc_swiss_knife/pages/extra_pages/course_details.dart';
import 'components/tab_controller.dart';
import 'pages/extra_pages/about_us.dart';
import 'pages/extra_pages/contacts.dart';
import 'pages/extra_pages/courses.dart';
import 'pages/extra_pages/instructors.dart';
import 'pages/extra_pages/navigation.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      // themeMode: ThemeMode.system,
      themeMode: ThemeMode.dark,
      initialRoute: '/',
      routes: {
        '/': (dummyCtx) => const TabsControllerScreen(),
        '/contacts': (dummyCtx) => const Contacts(),
        '/navigation': (dummyCtx) => const Navigation(),
        '/courses': (dummyCtx) => Courses(),
        '/courseDetails': (dummyCtx) => CourseDetails(),
        '/instructors': (dummyCtx) => const Instructors(),
        '/aboutUs': (dummyCtx) => const AboutUs(),
      },
    );
  }
}
