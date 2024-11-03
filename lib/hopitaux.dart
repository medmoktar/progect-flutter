import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rapport/createhopital.dart';
import 'package:rapport/updatehopital.dart';
import 'package:rapport/url.dart';

class Hopitaux extends StatefulWidget {
  final id;
  const Hopitaux({super.key, required this.id});

  @override
  State<Hopitaux> createState() => _Hopitaux();
}

class _Hopitaux extends State<Hopitaux> {
  var id;
  Future<List> all(id) async {
    var x = await http.get(Uri.parse("${Url().URL}/api/all/hopitaux/$id"));
    List reponse = jsonDecode(x.body);
    return reponse;
  }

  void _refreshPage() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Createhopital(
              id: widget.id,
              onupdate: _refreshPage,
            ),
          ));
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
            Text("Hopitaux", style: TextStyle(fontWeight: FontWeight.bold)),
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
            print("=========");
            print(Snapshot.data);
            print("=========");
            return ListView.builder(
                itemCount: Snapshot.data!.length,
                itemBuilder: (context, i) {
                  return Container(
                    padding: EdgeInsets.only(top: 20, left: 15, right: 15),
                    width: 110,
                    child: Card(
                      child: ListTile(
                        title: Text(Snapshot.data![i]["nom"]),
                        leading: CircleAvatar(
                          child: Snapshot.data![i]["photo"] == ""
                              ? null
                              : Image.network(
                                  "${Snapshot.data![i]["photo_url"]}",
                                  // fit: BoxFit.fill,
                                  // height: 50,
                                ),
                        ),
                        trailing: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Updatehopital(
                                        id: Snapshot.data![i]['id'],
                                        idvillage: widget.id,
                                        onUpdate: _refreshPage,
                                      )));
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white),
                            child: Text("Modifier")),
                        subtitle: Text("${Snapshot.data![i]["type"]}"),
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
    var y = await http.get(Uri.parse("${Url().URL}/api/all/hopitaux/$Id"));
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
                                builder: (context) => Updatehopital(
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
