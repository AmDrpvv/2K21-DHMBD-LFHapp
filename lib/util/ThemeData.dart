import 'package:flutter/material.dart';

class ThemeBuilder extends StatefulWidget {
  final Widget Function(BuildContext context, bool darkThme) builder;
  final bool darktheme;
  ThemeBuilder({@required this.builder, this.darktheme});

  @override
  _ThemeBuilderState createState() => _ThemeBuilderState();

  static _ThemeBuilderState of(BuildContext context)
  {
    return context.findAncestorStateOfType<_ThemeBuilderState>();
  }
}

class _ThemeBuilderState extends State<ThemeBuilder> {
  bool darkTheme;
  @override
    void initState() {
      darkTheme = widget.darktheme;
      // TODO: implement initState
      if(mounted)
        setState(() {});
      super.initState();
    }
  @override
  Widget build(BuildContext context) {
    return widget.builder(context, darkTheme);
  }

  getTheme(){
    return darkTheme;
  }
  
  changeTheme(){
    setState(() { darkTheme = !darkTheme; });
  }
}