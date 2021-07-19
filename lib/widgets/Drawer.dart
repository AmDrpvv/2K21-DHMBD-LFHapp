import 'package:flutter/material.dart';
import 'package:lfh_app/util/AppEntity.dart';
import 'package:lfh_app/util/ThemeData.dart';
import 'package:lfh_app/util/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Center(
                child: Text(
                  Constants.appName,
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
            ),
            ListTile(
              leading: Text(
                "Dark Mode",
              ),
              trailing: Switch(
                value: ThemeBuilder.of(context).getTheme(),
                activeColor: Colors.black,
                onChanged: (bool value)async {
                  ThemeBuilder.of(context).changeTheme();
                  var prefs = await SharedPreferences.getInstance();
                  prefs.setBool(sharedPrefDarkTheme, ThemeBuilder.of(context).getTheme());
                },
              ),
            )
          ],
      );
  }

}