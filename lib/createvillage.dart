import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:rapport/url.dart';
import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart' as p;
// import 'package:connectivity_plus/connectivity_plus.dart';

class Createvillage extends StatefulWidget {
  final id;
  final Function onupdate;
  const Createvillage({super.key, required this.id, required this.onupdate});

  @override
  State<Createvillage> createState() => _Createvillage();
}

class _Createvillage extends State<Createvillage> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _popilation = TextEditingController();
  final TextEditingController nom_local = TextEditingController();
  // late ConnectivityResult conxResult = ConnectivityResult.none;h
  var l = 18.098564;
  var A = -15.958748;
  static LatLng currentps = LatLng(37.77498, -122.4194);

  late Database database;

//   initedata() async {
//     var databasesPath = await getDatabasesPath();
//     String path = p.join(databasesPath, 'village.db');

// // open the database

//     database = await openDatabase(path, version: 1,
//         onCreate: (Database db, int version) async {
//       // When creating the db, create the table
//       return db.execute(
//           'CREATE TABLE village (id INTEGER PRIMARY KEY, nom TEXT,nom_arabic TEXT, commune_id INTEGER,Popilation INTEGER, altidude REAL,longitude REAL)');
//     });
//   }

  // insertdata(Map<String, dynamic> villageData) async {
  //   await database.insert(
  //     'village',
  //     villageData,
  //     conflictAlgorithm: ConflictAlgorithm.replace,
  //   );
  // }

  // Future<List<Map<String, dynamic>>> _getStoredVillages() async {
  //   return await database.query('villages');
  // }

  // _sendStoredVillages() async {
  //   List<Map<String, dynamic>> villages = await _getStoredVillages();
  //   for (var i in villages) {
  //     var url = Uri.parse('${Url().URL}/api/village/create');
  //     final Map<String, String> headers = {'Content-Type': 'application/json'};
  //     final response =
  //         await http.post(url, headers: headers, body: jsonEncode(i));

  //     if (response.statusCode == 200) {
  //       await database
  //           .delete('villages', where: 'id = ?', whereArgs: [i['id']]);
  //     }
  //   }
  // }

  // Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
  //   setState(() {
  //     conxResult = result as ConnectivityResult;
  //   });

  //   if (result != ConnectivityResult.none) {
  //     await _sendStoredVillages();
  //   }
  // }

  create() async {
    var url = Uri.parse('${Url().URL}/api/village/create');
    Map<String, dynamic> data = {
      'nom_administratif': _name.text,
      'nom-local': nom_local.text,
      'distance_de_la_route': Route.text,
      'commune_id': widget.id,
      'Popilation': _popilation.text,
      'altidude': l,
      'longitude': A
    };

    final Map<String, String> headers = {'Content-Type': 'application/json'};

    final reponse =
        await http.post(url, headers: headers, body: jsonEncode(data));

    if (reponse.statusCode == 200) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.rightSlide,
        title: 'Succed',
        btnOkOnPress: () {
          widget.onupdate();
          Navigator.of(context).pop(context);
        },
      ).show();
      // }
    }
  }

  GlobalKey<FormState> valid = GlobalKey();
  _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'active la localisation',
        btnOkOnPress: () {
          Navigator.of(context).pop(context);
          widget.onupdate();
          setState(() {});
        },
      ).show();
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return null;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition();
    l = position.latitude;
    A = position.longitude;

    currentps = LatLng(l, A);
    _goToPosition(currentps);
    setState(() {});
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  Future<void> _goToPosition(LatLng targetPosition) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: targetPosition,
      zoom: 14.4746,
    )));
  }

  // Future<void> _goToTheLake() async {
  //   final GoogleMapController controller = await _controller.future;
  //   await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  // }
  // ignore: unused_field
  // late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  // final Connectivity _connectivity = Connectivity();

  @override
  void initState() {
    super.initState();
    _determinePosition();

    // initedata();
    // _connectivitySubscription =
    //     _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  TextEditingController Route = TextEditingController();

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
                Text("Ajouter Village",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text("اضافة قرية", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            )),
        body: Form(
            key: valid,
            child: ListView(
              children: [
                SizedBox(
                  height: 15.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                      controller: _name,
                      decoration: const InputDecoration(
                        // filled: true,
                        // fillColor: Colors.black12,
                        contentPadding: EdgeInsets.only(
                            left: 8, bottom: 0, top: 0, right: 15),
                        hintText: "Entrer le nom Administratif",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            style: BorderStyle.none,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Entrer une Nom";
                        }
                        return null;
                      }),
                ),
                const SizedBox(height: 15.0),
                // Expanded(
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: nom_local,
                    decoration: const InputDecoration(
                      // filled: true,
                      // fillColor: Colors.black12,
                      contentPadding: EdgeInsets.only(
                          left: 8, bottom: 0, top: 0, right: 15),
                      hintText: "Entrer le nom local",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          style: BorderStyle.none,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Entrer une nom";
                      }
                      return null;
                    },
                  ),
                ),

                SizedBox(
                  height: 15.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _popilation,
                    decoration: const InputDecoration(
                      // filled: true,
                      // fillColor: Colors.black12,
                      contentPadding: EdgeInsets.only(
                          left: 8, bottom: 0, top: 0, right: 15),
                      hintText: "Entrer la Popilation",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          style: BorderStyle.none,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Entrer une Popilation";
                      }
                      return null;
                    },
                  ),
                ),
                
                // Container(
                //   padding: EdgeInsets.symmetric(vertical: 30, horizontal: 80),
                //   child: ElevatedButton(
                //       onPressed: () {
                //         _determinePosition();
                //       },
                //       style: ElevatedButton.styleFrom(
                //           backgroundColor: Colors.green[400],
                //           foregroundColor: Colors.white),
                //       child: Text("Localisation actuelle")),
                // ),

                SizedBox(
                  height: 15.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: Route,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Entrer la distance du Route";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      // filled: true,
                      // fillColor: Colors.black12,
                      contentPadding: EdgeInsets.only(
                          left: 8, bottom: 0, top: 0, right: 15),
                      hintText: "Entrer la distance du Route",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          style: BorderStyle.none,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 30, top: 30),
                  height: 400,
                  child: GoogleMap(
                    mapType: MapType.normal,
                    markers: {
                      Marker(
                          markerId: MarkerId("1"),
                          icon: BitmapDescriptor.defaultMarker,
                          position: LatLng(l, A))
                    },
                    onTap: (argument) {
                      A = argument.longitude;
                      l = argument.latitude;
                      _goToPosition(argument);
                      setState(() {});
                    },
                    initialCameraPosition:
                        CameraPosition(target: LatLng(18.098564, -15.958748)),
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 60),
                  child: ElevatedButton(
                      onPressed: () {
                        if (valid.currentState!.validate()) {
                          create();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white),
                      child: Text("Enregistrer")),
                )
              ],
            )));
  }
}
