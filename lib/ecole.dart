import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:rapport/createecole.dart';
import 'package:rapport/updateecole.dart';
import 'package:rapport/url.dart';

class Ecole extends StatefulWidget {
  final id;
  const Ecole({super.key, required this.id});

  @override
  State<Ecole> createState() => _Ecole();
}

class _Ecole extends State<Ecole> {
  var id;
  Future<List> all(id) async {
    var x = await http.get(Uri.parse("${Url().URL}/api/all/Ecole/$id"));
    List reponse = jsonDecode(x.body);
    return reponse;
  }

  void _refreshPage() {
    setState(() {
      // Logique pour rafraîchir les données de la page
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          id = widget.id;
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Createecole(
                    id: id,
                    onupdate: _refreshPage,
                  )));
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.blue,
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
            const Text("Ecoles", style: TextStyle(fontWeight: FontWeight.bold)),
            // Text("البلدية", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                showSearch(
                    context: context,
                    delegate: Search(id: widget.id, refreshPage: _refreshPage));
              },
              icon: Icon(Icons.search))
        ],
      ),
      body: FutureBuilder(
          future: all(widget.id),
          builder: (context, Snapshot) {
            if (Snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
                itemCount: Snapshot.data!.length,
                itemBuilder: (context, i) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                    width: 110,
                    child: Card(
                      child: ListTile(
                        title: Text(Snapshot.data![i]["nom"]),
                        leading: Image.network(
                          "${Snapshot.data![i]["photo_url"]}",
                          fit: BoxFit.fill,
                          height: 50,
                        ),
                        trailing: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Updateecole(
                                        id: Snapshot.data![i]['id'],
                                        idvillage: widget.id,
                                        onUpdate: _refreshPage,
                                      )));
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xffDA5266),
                                foregroundColor: Colors.white),
                            child: Text("Modifier")),
                      ),
                    ),
                  );
                });
          }),
    );
  }
}

class Search extends SearchDelegate {
  final int id;
  final Function refreshPage;
  Search({
    required this.id,
    required this.refreshPage,
  });
  Future<List> willaya(int Id) async {
    var y = await http.get(Uri.parse("${Url().URL}/api/all/Ecole/$Id"));
    List reponse = jsonDecode(y.body);
    return reponse;
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
                  (e) => e['nom'].toLowerCase().contains(query.toLowerCase()))
              .toList();
          return ListView.builder(
              itemCount: filter.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                  width: 110,
                  child: Card(
                    child: ListTile(
                      title: Text(filter[index]["nom"]),
                      trailing: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Updateecole(
                                      id: filter[index]['id'],
                                      idvillage: id,
                                      onUpdate: refreshPage,
                                    )));
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xffDA5266),
                              foregroundColor: Colors.white),
                          child: Text("Modifier")),
                    ),
                  ),
                );
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
