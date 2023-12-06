import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:guc_swiss_knife/configs/constants.dart';
import 'package:guc_swiss_knife/firebase_options.dart';
import 'package:guc_swiss_knife/pages/auth/login_page.dart';
import 'package:guc_swiss_knife/pages/auth/register_page.dart';
import 'package:guc_swiss_knife/pages/profile/edit_profile_page.dart';
import 'package:guc_swiss_knife/pages/profile/profile_page.dart';
import 'package:guc_swiss_knife/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'components/tab_controller.dart';
import 'pages/extra_pages/about_us.dart';
import 'pages/extra_pages/contacts.dart';
import 'pages/extra_pages/courses.dart';
import 'pages/extra_pages/instructors.dart';
import 'pages/extra_pages/navigation.dart';

Future<void> main() async {
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
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (ctx) => AuthProvider())],
      child: MaterialApp(
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            if (authProvider.isAuthenticated) {
              return const TabsControllerScreen();
            } else {
              return const LoginPage();
            }
          },
        ),
        title: appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        darkTheme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        themeMode: ThemeMode.system,
        // themeMode: ThemeMode.dark,
        // initialRoute: '/',
        routes: {
          '/home': (dummyCtx) => const TabsControllerScreen(),
          '/contacts': (dummyCtx) => const Contacts(),
          '/navigation': (dummyCtx) => const Navigation(),
          '/courses': (dummyCtx) => const Courses(),
          '/instructors': (dummyCtx) => const Instructors(),
          '/aboutUs': (dummyCtx) => const AboutUs(),
          '/profile': (dummyCtx) => const Profile(),
          '/editProfile': (dummyCtx) => const EditProfile(),
          '/login': (dummyCtx) => const LoginPage(),
          '/register': (dummyCtx) => const RegisterPage(),
        },
      ),
    );
  }
}
