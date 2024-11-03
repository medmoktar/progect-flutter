import 'package:flutter/material.dart';
import 'package:rapport/Settings.dart';
import 'package:rapport/willaya.dart';

class bottombar extends StatefulWidget {
  final int id;
  bottombar({super.key, required this.id});
  @override
  State<bottombar> createState() => _bottombar();
}

class _bottombar extends State<bottombar> {
  static List<Widget> _widgetOptions(BuildContext context, int id) {
    return <Widget>[
      Willaya(Id: id),
      Settings(),
    ];
  }

  // @override
  // void initState() {
  //   super.initState();
  //   l = <Widget>[Willaya(Id: widget.id), Settings()];
  // }

  int i = 0;
  @override
  Widget build(BuildContext context) {
    final List<Widget> l = _widgetOptions(context, widget.id);
    return Scaffold(
      body: l.elementAt(i),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings")
        ],
        elevation: 20,
        onTap: (value) {
          i = value;
          setState(() {});
        },
        currentIndex: i,
      ),
    );
  }
}
