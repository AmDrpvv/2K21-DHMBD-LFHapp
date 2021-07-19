import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:lfh_app/screens/NoConn.dart';
import 'package:lfh_app/screens/main_screen.dart';

class CheckConn extends StatefulWidget {
  @override
  _CheckConnState createState() => _CheckConnState();
}

class _CheckConnState extends State<CheckConn> {

  bool isConn;
  StreamSubscription subscription;

  void updateConn(ConnectivityResult result){
    if(result == ConnectivityResult.none) isConn = false;
    else isConn = true;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    isConn = false;
    subscription = Connectivity().onConnectivityChanged.listen(updateConn);
  }

  @override
  void dispose() {
    super.dispose();

    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {

    if(isConn) return MainScreen();
    else return NoConn();
  }
}