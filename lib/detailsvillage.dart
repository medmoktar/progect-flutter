import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:rapport/createchefvillage.dart';
import 'package:rapport/infovillage.dart';
import 'package:rapport/url.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';

class Detailsvillage extends StatefulWidget {
  final id;
  const Detailsvillage({super.key, required this.id});
  

  @override
  State<Detailsvillage> createState() => _Detailsvillage();
}

class _Detailsvillage extends State<Detailsvillage> {
  late List A = [], B = [];
  bool t = false;
  var id;
  // final List<ConnectivityResult> p = await (Connectivity().checkConnectivity());
  chef(id) async {
    var x = await http.get(Uri.parse("${Url().URL}/api/village/chef/$id"));
    A = jsonDecode(x.body);
    t = true;
    setState(() {});
  }

  info(id) async {
    var x = await http.get(Uri.parse("${Url().URL}/api/village/info/$id"));
    B = jsonDecode(x.body);
    t = true;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    chef(widget.id);
    info(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            toolbarHeight: 70,
            elevation: 10.0,
            shadowColor: const Color(0xff858DE0),
            backgroundColor: const Color(0xff858DE0),
            // leading: const
            title: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Details Village",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text("تفاصيل القرية",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            )),
        body: ListView(
          children: [
            Padding(padding: EdgeInsets.only(top: 20)),
            A.isEmpty
                ? Container(
                    height: 110,
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    child: Card(
                      child: ListTile(
                        title: Text(
                          "Chef Village",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: ElevatedButton(
                            onPressed: () {
                              id = widget.id;
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      Createchefvillage(id: id)));
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white),
                            child: Text("Create")),
                      ),
                    ),
                  )
                : Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              "Chefvillage",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "Nom : ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text("${A[0]["nom"]}")
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Numero Telephone : ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text("${A[0]["tel"]}")
                            ],
                          ),
                          Divider(
                            color: Colors.blue,
                            thickness: 2,
                          ),
                          Center(
                            child: ElevatedButton(
                                onPressed: () {
                                  id = widget.id;
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          Createchefvillage(id: id)));
                                
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white),
                                child: Text("Moddiffier")),
                          )
                        ],
                      ),
                    ),
                  ),
            Container(
              height: 110,
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Card(
                child: ListTile(
                  title: Text(
                    "Info Village",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: ElevatedButton(
                      onPressed: () {
                        id = widget.id;
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Infovillage(id: id)));
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white),
                      child: Text("Details")),
                ),
              ),
            ),
          ],
        ));
  }
}
