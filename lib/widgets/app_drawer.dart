import 'package:flutter/material.dart';

Drawer appDrawer() {
  return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: const <Widget>[
          SizedBox(
            height: 80.0,
            child: DrawerHeader(
                child: Text('', style: TextStyle(color: Colors.white,fontSize: 24,),),
                decoration: BoxDecoration(color: Colors.blue,),
                margin: EdgeInsets.all(0.0),
                padding: EdgeInsets.all(0.0)
            ),
          ),
          ListTile(leading: Icon(Icons.message),title: Text('Messages'),),
          ListTile(leading: Icon(Icons.account_circle),title: Text('Profile'),),
          ListTile(leading: Icon(Icons.settings),title: Text('Settings'),),
          ListTile(leading: Icon(Icons.logout),title: Text('Logout'),),
        ],
      )
  );
}