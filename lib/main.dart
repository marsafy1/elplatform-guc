import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:guc_swiss_knife/configs/constants.dart';
import 'package:guc_swiss_knife/firebase_options.dart';
import 'package:guc_swiss_knife/models/user.dart';
import 'package:guc_swiss_knife/pages/admin/add_contact.dart';
import 'package:guc_swiss_knife/pages/auth/login_page.dart';
import 'package:guc_swiss_knife/pages/auth/register_page.dart';
import 'package:guc_swiss_knife/pages/profile/change_password.dart';
import 'package:guc_swiss_knife/pages/profile/edit_profile_page.dart';
import 'package:guc_swiss_knife/pages/profile/profile_page.dart';
import 'package:guc_swiss_knife/pages/utils/loading_page.dart';
import 'package:guc_swiss_knife/providers/auth_provider.dart';
import 'package:guc_swiss_knife/services/analytics_service.dart';
import 'package:guc_swiss_knife/services/route_observer_service.dart';
import 'package:provider/provider.dart';
import 'package:guc_swiss_knife/pages/admin/instructor_details.dart';
import 'package:guc_swiss_knife/pages/admin/admin_publish_requests_page.dart';
import 'package:guc_swiss_knife/pages/admin/publish_request_details.dart';
import 'package:guc_swiss_knife/pages/extra_pages/course_details.dart';
import 'components/tab_controller.dart';
import 'pages/extra_pages/about_us.dart';
import 'pages/extra_pages/contacts.dart';
import 'pages/extra_pages/courses.dart';
import 'pages/extra_pages/instructors.dart';
import 'pages/extra_pages/navigation.dart';
import 'themes/dark_theme.dart';

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
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (ctx) => AuthProvider())],
      child: MaterialApp(
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            if (!authProvider.isAuthenticated) {
              return const LoginPage();
            }
            if (authProvider.user == null) {
              return const LoadingPage();
            }
            switch (authProvider.user!.userType) {
              case UserType.admin:
                return const AdminPublishRequests();
              case UserType.instructor || UserType.student:
                return const TabsControllerScreen();
            }
          },
        ),
        title: appName,
        debugShowCheckedModeBanner: false,
        theme: darkTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        // themeMode: ThemeMode.dark,
        navigatorObservers: [
          AnalyticsService.getAnalyticsObserver(),
          RouteObserverService()
        ],
        routes: {
          '/home': (dummyCtx) => const TabsControllerScreen(),
          '/contacts': (dummyCtx) => const Contacts(),
          '/navigation': (dummyCtx) => const Navigation(),
          '/courses': (dummyCtx) => const Courses(),
          '/courseDetails': (dummyCtx) => const CourseDetails(),
          '/instructors': (dummyCtx) => const Instructors(),
          '/aboutUs': (dummyCtx) => const AboutUs(),
          '/instructorDetails': (dummyCtx) => const InstructorDetails(),
          '/publishRequests': (dummyCtx) => const AdminPublishRequests(),
          '/publishRequestDetails': (dummyCtx) =>
              const PublishRequestsDetails(),
          '/profile': (dummyCtx) => const Profile(),
          '/editProfile': (dummyCtx) => const EditProfile(),
          '/changePassword': (dummyCtx) => const ChangePassword(),
          '/login': (dummyCtx) => const LoginPage(),
          '/register': (dummyCtx) => const RegisterPage(),
          '/addContact': (dummyCtx) => const AddContact(),
        },
      ),
    );
  }
}
