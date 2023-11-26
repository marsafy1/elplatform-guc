import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainDrawer extends StatelessWidget {
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
                padding: EdgeInsets.all(20),
                alignment: Alignment.centerLeft,
                child: Text(
                  'elPlatform',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 30,
                      color: Colors.white),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ListTile(
                leading: FaIcon(FontAwesomeIcons.phone),
                title: Text("GUC Contacts"),
                onTap: () {
                  Navigator.of(context).pushNamed('/');
                },
              ),
              ListTile(
                leading: FaIcon(FontAwesomeIcons.mapLocation),
                title: Text("Navigation"),
                onTap: () {
                  Navigator.of(context).pushNamed('/');
                },
              ),
              ListTile(
                leading: FaIcon(FontAwesomeIcons.book),
                title: Text("Courses"),
                onTap: () {
                  Navigator.of(context).pushNamed('/');
                },
              ),
              ListTile(
                leading: FaIcon(FontAwesomeIcons.chalkboardUser),
                title: Text("Instructors"),
                onTap: () {
                  Navigator.of(context).pushNamed('/');
                },
              ),
            ],
          ),
          Column(
            children: [
              ListTile(
                leading: FaIcon(FontAwesomeIcons.rightFromBracket),
                title: Text("Logout"),
                onTap: () {
                  Navigator.of(context).pushNamed('/');
                },
              ),
              ListTile(
                leading: FaIcon(FontAwesomeIcons.info),
                title: Text("About Us"),
                onTap: () {
                  Navigator.of(context).pushNamed('/');
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
