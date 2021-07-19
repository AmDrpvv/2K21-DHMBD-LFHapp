import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Image.asset(
            'assets/logo.png',
            width: MediaQuery.of(context).size.width*0.2,
            height: MediaQuery.of(context).size.width*0.2,
          ),
        )
      ),
    );
  }
}