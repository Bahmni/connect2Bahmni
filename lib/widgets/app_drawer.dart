import 'package:flutter/material.dart';
import '../utils/app_routes.dart';
import '../utils/shared_preference.dart';

Drawer appDrawer(BuildContext context) {
  return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const SizedBox(
            height: 80.0,
            child: DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue,),
                margin: EdgeInsets.all(0.0),
                padding: EdgeInsets.all(0.0),
                child: Text('', style: TextStyle(color: Colors.white,fontSize: 24,),)
            ),
          ),
          ListTile(leading: const Icon(Icons.message),
            title: const Text('Messages'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Not yet Implemented")),
              );
              Navigator.pop(context);
            },
          ),
          ListTile(leading: const Icon(Icons.account_circle),
            title: const Text('Profile'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Not yet Implemented")),
              );
              Navigator.pop(context);
            },
          ),
          ListTile(leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Not yet Implemented")),
              );
              Navigator.pop(context);
            },
          ),
          ListTile(leading: const Icon(Icons.info),
            title: const Text('About'),
            onTap: () async {
              Navigator.pop(context);
              displayAbout(context);
            },
          ),
          ListTile(leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                UserPreferences().removeSession();
                Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (r) => false);
              }),
        ],
      )
  );
}

void displayAbout(BuildContext context) {
  showAboutDialog(
    context: context,
    applicationVersion: '1.0.0+1',
    applicationIcon: const FlutterLogo(),
    children: <Widget>[
      const Text.rich(TextSpan(
        text: 'Bahmni App for clinicians',
        style: TextStyle(color: Colors.black),
        children: <TextSpan>[
          TextSpan(text: '\nWe believe health is human right.',
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12))
        ],
      ))
    ]
  );
}
