import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rapport/Language.dart';
import 'package:rapport/chefvillage.dart';
import 'package:rapport/createvillage.dart';
import 'package:rapport/eaux.dart';
// import 'package:rapport/detailsvillage.dart';
import 'package:rapport/ecole.dart';
import 'package:rapport/hopitaux.dart';
import 'package:rapport/reseaux.dart';
import 'package:rapport/url.dart';

class Village extends StatefulWidget {
  final int idvillage;
  const Village({super.key, required this.idvillage});

  @override
  State<Village> createState() => _Village();
}

class _Village extends State<Village> {
  var id;
  Future<List> village(id) async {
    var x = await http.get(Uri.parse("${Url().URL}/api/village/$id"));
    List reponse = jsonDecode(x.body);
    return reponse;
  }

  Future<int> counthopitaux(id) async {
    var x = await http.get(Uri.parse("${Url().URL}/api/village/hopitaux/$id"));
    return jsonDecode(x.body);
  }

  Future<int> countEcole(id) async {
    var x = await http.get(Uri.parse("${Url().URL}/api/village/Ecole/$id"));
    return jsonDecode(x.body);
  }

  void _refreshPage() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: () {
            id = widget.idvillage;
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Createvillage(
                      id: id,
                      onupdate: _refreshPage,
                    )));
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        appBar: AppBar(
          toolbarHeight: 70,
          elevation: 10.0,
          shadowColor: const Color(0xff858DE0),
          backgroundColor: const Color(0xff858DE0),
          // leading: const
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Village", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("القري", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          actions: [],
        ),
        body: FutureBuilder(
            future: village(widget.idvillage),
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
                                delegate: Search(id: widget.idvillage));
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
                                    return Text("");
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
                                                      "Village                       ",
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 10)),
                                                    Text(
                                                      "    " +
                                                          data[index][
                                                              'nom_administratif'],
                                                      style: TextStyle(
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
                                                      "                       القرية",
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                    const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 10)),
                                                    Text(
                                                      data[index]['nom-local'] +
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
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      IconButton(
                                                        onPressed: () {
                                                          showModalBottomSheet(
                                                              context: context,
                                                              builder:
                                                                  (context) =>
                                                                      Chefvillage(
                                                                        id: data[index]
                                                                            [
                                                                            "id"],
                                                                      ));
                                                        },
                                                        icon: Icon(
                                                          Icons.person,
                                                        ),
                                                      ),
                                                      Text(
                                                        "Chef",
                                                        style: TextStyle(
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.03,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                // Padding(
                                                //     padding:
                                                //         EdgeInsets.symmetric(
                                                //             horizontal: 10)),
                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      IconButton(
                                                        onPressed: () {
                                                          showModalBottomSheet(
                                                              context: context,
                                                              builder:
                                                                  (context) =>
                                                                      Reseaux(
                                                                        id: data[index]
                                                                            [
                                                                            "id"],
                                                                      ));
                                                        },
                                                        icon: Icon(
                                                          Icons
                                                              .network_cell_rounded,
                                                        ),
                                                      ),
                                                      Text("Reseaux",
                                                          style: TextStyle(
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.03,
                                                          ))
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      IconButton(
                                                        onPressed: () {
                                                          showModalBottomSheet(
                                                              context: context,
                                                              builder:
                                                                  (context) =>
                                                                      Language(
                                                                        id: data[index]
                                                                            [
                                                                            "id"],
                                                                      ));
                                                        },
                                                        icon: Icon(
                                                          Icons.language,
                                                        ),
                                                      ),
                                                      Text("Language",
                                                          style: TextStyle(
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.03,
                                                          ))
                                                    ],
                                                  ),
                                                ),
                                                // Padding(
                                                //     padding:
                                                //         EdgeInsets.symmetric(
                                                //             horizontal: 10)),
                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      IconButton(
                                                        onPressed: () {
                                                          showModalBottomSheet(
                                                              context: context,
                                                              builder:
                                                                  (context) =>
                                                                      Eaux(
                                                                        id: data[index]
                                                                            [
                                                                            "id"],
                                                                      ));
                                                        },
                                                        icon: Icon(
                                                          Icons.water,
                                                          size: 30,
                                                        ),
                                                      ),
                                                      Text("eaux",
                                                          style: TextStyle(
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.03,
                                                          ))
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      IconButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .push(MaterialPageRoute(
                                                                    builder: (context) => Ecole(
                                                                        id: data[index]
                                                                            [
                                                                            "id"])));
                                                          },
                                                          icon: Icon(
                                                            Icons.school,
                                                            color: Colors.blue,
                                                          )),
                                                      Text("Edication",
                                                          style: TextStyle(
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.03,
                                                          ))
                                                    ],
                                                  ),
                                                ),
                                                // Padding(
                                                //     padding:
                                                //         EdgeInsets.symmetric(
                                                //             horizontal: 10)),
                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      IconButton(
                                                        onPressed: () {
                                                          Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      Hopitaux(
                                                                          id: data[index]
                                                                              [
                                                                              "id"])));
                                                        },
                                                        icon: Icon(
                                                          Icons.local_hospital,
                                                        ),
                                                        color: Colors.red,
                                                      ),
                                                      Text("Hopitaux",
                                                          style: TextStyle(
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.03,
                                                          ))
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5),
                                              child: ElevatedButton(
                                                  onPressed: () {
                                                    id = data[index]["id"];
                                                    // Navigator.of(context).push(
                                                    //     MaterialPageRoute(
                                                    //         builder: (context) =>
                                                    //             Detailsvillage(
                                                    //                 id: id)));
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.blue,
                                                    foregroundColor:
                                                        Colors.white,
                                                  ),
                                                  child: Text("Modiffier")),
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
  Future<List> willaya(int Id) async {
    var y = await http.get(Uri.parse("${Url().URL}/api/village/$Id"));
    List reponse = jsonDecode(y.body);
    return reponse;
  }

  Future<int> counthopitaux(id) async {
    var x = await http.get(Uri.parse("${Url().URL}/api/village/hopitaux/$id"));
    return jsonDecode(x.body);
  }

  Future<int> countEcole(id) async {
    var x = await http.get(Uri.parse("${Url().URL}/api/village/Ecole/$id"));
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
              .where((e) => e['nom_administratif']
                  .toLowerCase()
                  .contains(query.toLowerCase()))
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
                                          "Village                       ",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        const Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 10)),
                                        Text(
                                          "    " +
                                              filter[index]
                                                  ['nom_administratif'],
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
                                          "                       القرية",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        const Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 10)),
                                        Text(
                                          filter[index]['nom_administratif'] +
                                              "    ",
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
                                        // Navigator.of(context).push(
                                        //     MaterialPageRoute(
                                        //         builder: (context) =>
                                        //             Detailsvillage(
                                        //                 id: filter[index]
                                        //                     ["id"])));
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
                        query = Snapshot.data![i]['nom_administratif'];
                        showResults(context);
                      },
                      child: Card(
                        child: ListTile(
                          title: Text(Snapshot.data![i]['nom_administratif']),
                        ),
                      ));
                });
          } else {
            List filter = [];
            filter = Snapshot.data!
                .where((e) => e['nom_administratif']
                    .toLowerCase()
                    .startsWith(query.toLowerCase()))
                .toList();
            return ListView.builder(
                itemCount: filter.length,
                itemBuilder: (context, i) {
                  return InkWell(
                      onTap: () {
                        query = filter[i]['nom_administratif'];
                        showResults(context);
                      },
                      child: Card(
                        child: ListTile(
                          title: Text(filter[i]['nom_administratif']),
                        ),
                      ));
                });
          }
        });
  }
}
