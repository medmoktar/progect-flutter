import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rapport/createLanguage.dart';
import 'package:rapport/updateLanguage.dart';
import 'package:rapport/url.dart';

class Language extends StatefulWidget {
  final id;
  const Language({super.key, required this.id});

  @override
  State<Language> createState() => _LanguageState();
}

class _LanguageState extends State<Language> {
  late List A = [];
  late bool t = false;
  langue(id) async {
    var x = await http.get(Uri.parse("${Url().URL}/api/language/store/$id"));
    A = jsonDecode(x.body);
    t = true;
    setState(() {});
  }

  @override
  void initState() {
    langue(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: t == false
            ? Center(
                child: CircularProgressIndicator(),
              )
            : A.isEmpty
                ? Container(
                    height: 110,
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    child: Card(
                      child: ListTile(
                        title: Text(
                          "Languages",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      Createlanguage(id: widget.id)));
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white),
                            child: Text("Ajouter")),
                      ),
                    ),
                  )
                : ListView(
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      const Text(
                        "Languages",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.blue),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: ListView.builder(
                            itemCount: A.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, i) {
                              return Container(
                                child: Text(
                                  "- ${A[i]['nom']}",
                                  style: TextStyle(fontSize: 18),
                                ),
                              );
                            }),
                      ),
                      Divider(
                        color: Colors.blue,
                        thickness: 2,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      Updatelanguage(id: widget.id)));
                            },
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white),
                            child: Text("Modiffier")),
                      )
                    ],
                  ));
  }
}
