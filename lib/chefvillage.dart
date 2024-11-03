import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:rapport/url.dart';

class Chefvillage extends StatefulWidget {
  final id;
  const Chefvillage({super.key, required this.id});

  @override
  State<Chefvillage> createState() => _Chefvillage();
}

class _Chefvillage extends State<Chefvillage> {
  late List A = [];
  late bool t = false;
  chef(id) async {
    var x = await http.get(Uri.parse("${Url().URL}/api/village/chef/$id"));
    A = jsonDecode(x.body);
    t = true;
    setState(() {});
  }

  @override
  void initState() {
    chef(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: t == false
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: [
                const SizedBox(
                  height: 25,
                ),
                const Text(
                  "ChefVillage",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.blue),
                ),
                const SizedBox(
                  height: 25,
                ),
                Container(
                  padding: EdgeInsets.only(left: 30),
                  child: Row(
                    children: [
                      const Text(
                        "Nom : ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      Text(
                        "${A[0]["nom"]}",
                        style: TextStyle(fontSize: 15),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 30),
                  child: Row(
                    children: [
                      const Text(
                        "Telephone : ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      Text("${A[0]["tel"]}", style: TextStyle(fontSize: 15))
                    ],
                  ),
                ),
                Divider(
                  color: Colors.blue,
                  thickness: 2,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white),
                      child: Text("Modiffier")),
                )
              ],
            ),
    );
  }
}
