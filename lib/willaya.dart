import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:rapport/Moughataa.dart';
import 'package:rapport/sqlite.dart';
import 'package:rapport/url.dart';

class Willaya extends StatefulWidget {
  final int Id;
  const Willaya({super.key, required this.Id});

  @override
  State<Willaya> createState() => _Willaya();
}

class _Willaya extends State<Willaya> {
  int i = 0;
  var id;
  Future<List> willaya(int id) async {
    var y = await http.get(Uri.parse("${Url().URL}/api/users/$id"));
    List reponse = jsonDecode(y.body);
    return reponse;
  }

  Future<int> counthopitaux(id) async {
    var x = await http.get(Uri.parse("${Url().URL}/api/willaya/hopitaux/$id"));
    return jsonDecode(x.body);
  }

  Future<int> countEcole(id) async {
    var x = await http.get(Uri.parse("${Url().URL}/api/willaya/Ecole/$id"));
    return jsonDecode(x.body);
  }

  sqlDb sql = sqlDb();

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
              Text("willaya", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("الولايات", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          actions: [],
        ),
        body: FutureBuilder(
            future: willaya(widget.Id),
            builder: (context, Snapshot) {
              if (Snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              List data = Snapshot.data!;
              return Column(
                children: [
                  Flexible(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: Row(
                          children: [
                            Expanded(
                                child: TextField(
                              onTap: () {
                                showSearch(
                                    context: context,
                                    delegate: Search(id: widget.Id));
                              },
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 10),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.blue,
                                ),
                                border: OutlineInputBorder(),
                                hintText: "Recherche Willaya",
                                // hintStyle:
                                //     TextStyle(fontWeight: FontWeight.w300),
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
                      )),
                  Expanded(
                    child: ListView.builder(
                        itemCount: data.length,
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
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10),
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
                                                    "Willaya                       ",
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  ),
                                                  const Padding(
                                                      padding: EdgeInsets.only(
                                                          bottom: 10)),
                                                  Text(
                                                    "    " +
                                                        data[index]['name'],
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                                    "                       الولايات",
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  ),
                                                  const Padding(
                                                      padding: EdgeInsets.only(
                                                          bottom: 10)),
                                                  Text(
                                                    data[index]['nom-arabic'] +
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
                                                  const Text("        :السكان")
                                                ],
                                              ),
                                            ],
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: ElevatedButton(
                                                onPressed: () {
                                                  id = data[index]["id"];
                                                  // if (sql.getMoughataa(id) ==
                                                  //     []) {
                                                  //   print("==================");
                                                  //   print(sql.getMoughataa(id));
                                                  //   print("==================");
                                                  //   // sql.insertMoughataa(id);
                                                  // }
                                                  // print("==================");
                                                  // print(sql.getMoughataa(id));
                                                  // print("==================");
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Moughataa(
                                                                  idwillaya:
                                                                      id)));
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
                        }),
                  ),
                ],
              );
            }));
  }
}

class Search extends SearchDelegate {
  final int id;
  Search({required this.id});
  Future<List> willaya(int Id) async {
    var y = await http.get(Uri.parse("${Url().URL}/api/users/$id"));
    List reponse = jsonDecode(y.body);
    return reponse;
  }

  Future<int> counthopitaux(id) async {
    var x = await http.get(Uri.parse("${Url().URL}/api/willaya/hopitaux/$id"));
    return jsonDecode(x.body);
  }

  Future<int> countEcole(id) async {
    var x = await http.get(Uri.parse("${Url().URL}/api/willaya/Ecole/$id"));
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
        future: willaya(id),
        builder: (context, Snapshot) {
          if (Snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!Snapshot.hasData || Snapshot.data == null) {
            return Center(child: Text('Aucune donnée trouvée.'));
          }

          filter = Snapshot.data!
              .where(
                  (e) => e['name'].toLowerCase().contains(query.toLowerCase()))
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
                                          "Willaya                       ",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        const Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 10)),
                                        Text(
                                          "    " + filter[index]['name'],
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
                                          "                       الولايات",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        const Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 10)),
                                        Text(
                                          filter[index]['name'] + "    ",
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
                                                builder: (context) => Moughataa(
                                                    idwillaya: filter[index]
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
        future: willaya(id),
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
                        query = Snapshot.data![i]['name'];
                        showResults(context);
                      },
                      child: Card(
                        child: ListTile(
                          title: Text(Snapshot.data![i]['name']),
                        ),
                      ));
                });
          } else {
            List filter = [];
            filter = Snapshot.data!
                .where((e) =>
                    e['name'].toLowerCase().startsWith(query.toLowerCase()))
                .toList();
            return ListView.builder(
                itemCount: filter.length,
                itemBuilder: (context, i) {
                  return InkWell(
                      onTap: () {
                        query = filter[i]['name'];
                        showResults(context);
                      },
                      child: Card(
                        child: ListTile(
                          title: Text(filter[i]['name']),
                        ),
                      ));
                });
          }
        });
  }
}
