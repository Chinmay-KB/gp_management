import 'package:flutter/material.dart';

class SideDrawer extends StatelessWidget {
  SideDrawer({
    required this.isSuperUser,
    required this.onLogout,
    required this.onAbout,
    this.onRequestAccess,
    Key? key,
  }) : super(key: key);
  bool isSuperUser;
  VoidCallback? onRequestAccess;
  VoidCallback onLogout;
  VoidCallback onAbout;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          if (!isSuperUser)
            ListTile(
              onTap: onRequestAccess,
              title: Text('Request Jurisdiction Access'),
            ),
          Divider(),
          ListTile(
            onTap: onAbout,
            title: Text('About the app'),
          ),
          Divider(),
          ListTile(
            onTap: onLogout,
            title: Text('Logout'),
          )
        ],
      ),
    );
  }
}
