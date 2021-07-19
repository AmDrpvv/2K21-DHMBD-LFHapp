import 'package:flutter/material.dart';
import 'package:lfh_app/util/const.dart';

class NoConn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(Constants.appName),
      ),
      body: Container(
        child: Center(
          child: Text('Oopps!!  No Internet..',
            style: TextStyle(fontSize: 20.0),
          ),
        )
      ),
    );
  }
}