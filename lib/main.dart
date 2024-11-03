import 'package:flutter/material.dart';
import 'package:rapport/login.dart';

void main() {
  runApp(const Rapport());
}

class Rapport extends StatefulWidget {
  const Rapport({super.key});

  @override
  State<Rapport> createState() => _Rapport();
}

class _Rapport extends State<Rapport> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: login(),
    );
  }
}
