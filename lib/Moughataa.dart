import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:rapport/commune.dart';
import 'package:rapport/url.dart';

class Moughataa extends StatefulWidget {
  final int idwillaya;
  const Moughataa({super.key, required this.idwillaya});

  @override
  State<Moughataa> createState() => _Moughataa();
}

class _Moughataa extends State<Moughataa> {
  var id;
  Future<List> Moughataa(id) async {
    var x = await http.get(Uri.parse("${Url().URL}/api/willaya/$id"));
    List reponse = jsonDecode(x.body);
    return reponse;
  }

  Future<int> counthopitaux(id) async {
    var x =
        await http.get(Uri.parse("${Url().URL}/api/Moughataa/hopitaux/$id"));
    return jsonDecode(x.body);
  }

  Future<int> countEcole(id) async {
    var x = await http.get(Uri.parse("${Url().URL}/api/Moughataa/Ecole/$id"));
    return jsonDecode(x.body);
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
              Text("Moughataa", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("المقاطعة", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          // actions: [
          //   IconButton(
          //       onPressed: () {
          //         showSearch(
          //             context: context, delegate: Search(id: widget.idwillaya));
          //       },
          //       icon: Icon(Icons.search))
          // ],
        ),
        body: FutureBuilder(
            future: Moughataa(widget.idwillaya),
            builder: (context, Snapshot) {
              if (Snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              List data = Snapshot.data!;
              return Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: Row(
                      children: [
                        Expanded(
                            // width: 300,
                            // padding: EdgeInsets.only(top: 30, left: 30),
                            // height: 70,
                            child: TextField(
                          onTap: () {
                            showSearch(
                                context: context,
                                delegate: Search(id: widget.idwillaya));
                          },
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 10),
                            prefixIcon: Icon(Icons.search, color: Colors.blue),
                            border: OutlineInputBorder(),
                            hintText: "Recherche Moughataa",
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                borderSide: BorderSide(
                                    width: 1, color: Color(0xffD9D9D9))),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                borderSide: BorderSide(
                                    width: 1, color: Color(0xffD9D9D9))),
                          ),
                        ))
                      ],
                    ),
                  ),
                  Expanded(
                      child: ListView.builder(
                          itemCount: Snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return FutureBuilder(
                                future: Future.wait([
                                  counthopitaux(data[index]['id']),
                                  countEcole(data[index]['id'])
                                ]).then((r) {
                                  return {'hopitaux': r[0], 'Ecole': r[1]};
                                }),
                                builder: (context, Snapshot) {
                                  if (Snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  return Container(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Card(
                                        color: Colors.white,
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                // Expanded(
                                                // const Padding(padding: EdgeInsets.only(left: )),
                                                Column(
                                                  children: [
                                                    const Text(
                                                      "Moughataa                       ",
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                    const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 10)),
                                                    Text(
                                                      "    " +
                                                          data[index]['nom'],
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20),
                                                    ),
                                                    Text(
                                                        "Hopitaux:${Snapshot.data!['hopitaux']}     "),
                                                    Text(
                                                        "Ecoles:${Snapshot.data!['Ecole']}         "),
                                                    Text("Popilation:   ")
                                                  ],
                                                ),

                                                Column(
                                                  children: [
                                                    const Text(
                                                      "                       المقاطعة",
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                    const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 10)),
                                                    Text(
                                                      data[index]
                                                              ['nom-arabic'] +
                                                          "    ",
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20),
                                                    ),
                                                    Text(
                                                        "${Snapshot.data!['hopitaux']}:المستشفيات"),
                                                    Text(
                                                        "      ${Snapshot.data!['Ecole']}:المدارس"),
                                                    Text("        :السكان")
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5),
                                              child: ElevatedButton(
                                                  onPressed: () {
                                                    id = data[index]["id"];
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                Commune(
                                                                    communid:
                                                                        id)));
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.blue,
                                                    foregroundColor:
                                                        Colors.white,
                                                  ),
                                                  child: const Column(
                                                    children: [
                                                      Text("التفاصيل"),
                                                      Text("Details")
                                                    ],
                                                  )),
                                            )
                                          ],
                                        )),
                                  );
                                });
                          }))
                ],
              );
            }));
  }
}

class Search extends SearchDelegate {
  final int id;
  Search({required this.id});
  Future<List> Moughataa(id) async {
    var x = await http.get(Uri.parse("${Url().URL}/api/willaya/$id"));
    List reponse = jsonDecode(x.body);
    return reponse;
  }

  Future<int> counthopitaux(id) async {
    var x =
        await http.get(Uri.parse("${Url().URL}/api/Moughataa/hopitaux/$id"));
    return jsonDecode(x.body);
  }

  Future<int> countEcole(id) async {
    var x = await http.get(Uri.parse("${Url().URL}/api/Moughataa/Ecole/$id"));
    return jsonDecode(x.body);
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.close))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    List filter = [];
    return FutureBuilder(
        future: Moughataa(id),
        builder: (context, Snapshot) {
          if (Snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!Snapshot.hasData || Snapshot.data == null) {
            return Center(child: Text('Aucune donnée trouvée.'));
          }

          filter = Snapshot.data!
              .where(
                  (e) => e['nom'].toLowerCase().contains(query.toLowerCase()))
              .toList();
          return ListView.builder(
              itemCount: filter.length,
              itemBuilder: (context, index) {
                return FutureBuilder(
                    future: Future.wait([
                      counthopitaux(filter[index]['id']),
                      countEcole(filter[index]['id'])
                    ]).then((r) {
                      return {'hopitaux': r[0], 'Ecole': r[1]};
                    }),
                    builder: (context, Snapshot) {
                      if (Snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Card(
                            color: Colors.white,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Expanded(
                                    // const Padding(padding: EdgeInsets.only(left: )),
                                    Column(
                                      children: [
                                        const Text(
                                          "Moughataa                       ",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        const Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 10)),
                                        Text(
                                          "    " + filter[index]['nom'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                        Text(
                                            "Hopitaux:${Snapshot.data!['hopitaux']}     "),
                                        Text(
                                            "Ecoles:${Snapshot.data!['Ecole']}         "),
                                        const Text("Popilation:   ")
                                      ],
                                    ),

                                    Column(
                                      children: [
                                        const Text(
                                          "                       المقاطعة",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        const Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 10)),
                                        Text(
                                          filter[index]['nom'] + "    ",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                        Text(
                                            "${Snapshot.data!['hopitaux']}:المستشفيات"),
                                        Text(
                                            "      ${Snapshot.data!['Ecole']}:المدارس"),
                                        const Text("        :السكان")
                                      ],
                                    ),
                                  ],
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) => Commune(
                                                    communid: filter[index]
                                                        ["id"])));
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        foregroundColor: Colors.white,
                                      ),
                                      child: const Column(
                                        children: [
                                          Text("التفاصيل"),
                                          Text("Details")
                                        ],
                                      )),
                                )
                              ],
                            )),
                      );
                    });
              });
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
        future: Moughataa(id),
        builder: (context, Snapshot) {
          if (Snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (query == '') {
            return ListView.builder(
                itemCount: Snapshot.data!.length,
                itemBuilder: (context, i) {
                  return InkWell(
                      onTap: () {
                        query = Snapshot.data![i]['nom'];
                        showResults(context);
                      },
                      child: Card(
                        child: ListTile(
                          title: Text(Snapshot.data![i]['nom']),
                        ),
                      ));
                });
          } else {
            List filter = [];
            filter = Snapshot.data!
                .where((e) =>
                    e['nom'].toLowerCase().startsWith(query.toLowerCase()))
                .toList();
            return ListView.builder(
                itemCount: filter.length,
                itemBuilder: (context, i) {
                  return InkWell(
                      onTap: () {
                        query = filter[i]['nom'];
                        showResults(context);
                      },
                      child: Card(
                        child: ListTile(
                          title: Text(filter[i]['nom']),
                        ),
                      ));
                });
          }
        });
  }
}
