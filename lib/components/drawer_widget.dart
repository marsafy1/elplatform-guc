import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guc_swiss_knife/configs/constants.dart';
import 'package:guc_swiss_knife/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({super.key});

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  late final AuthProvider _authProvider;

  @override
  void initState() {
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Container(
                height: 100,
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                alignment: Alignment.centerLeft,
                child: const Text(
                  appName,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 30,
                      color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ListTile(
                leading: const FaIcon(FontAwesomeIcons.phone),
                title: const Text("GUC Contacts"),
                onTap: () {
                  Navigator.of(context).pushNamed('/contacts');
                },
              ),
              ListTile(
                leading: const FaIcon(FontAwesomeIcons.mapLocation),
                title: const Text("Navigation"),
                onTap: () {
                  Navigator.of(context).pushNamed('/navigation');
                },
              ),
              ListTile(
                leading: const FaIcon(FontAwesomeIcons.book),
                title: const Text("Courses"),
                onTap: () {
                  Navigator.of(context).pushNamed('/courses');
                },
              ),
              ListTile(
                leading: const FaIcon(FontAwesomeIcons.chalkboardUser),
                title: const Text("Instructors"),
                onTap: () {
                  Navigator.of(context).pushNamed('/instructors');
                },
              ),
            ],
          ),
          Column(
            children: [
              ListTile(
                leading:
                    const CircleAvatar(), // TODO: add current user profile image
                title: const Text("Profile"),
                onTap: () {
                  Navigator.of(context).pushNamed('/profile');
                },
              ),
              ListTile(
                leading: const FaIcon(FontAwesomeIcons.rightFromBracket),
                title: const Text("Logout"),
                onTap: () {
                  _authProvider.logout();
                },
              ),
              ListTile(
                leading: const FaIcon(FontAwesomeIcons.info),
                title: const Text("About Us"),
                onTap: () {
                  Navigator.of(context).pushNamed('/aboutUs');
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
