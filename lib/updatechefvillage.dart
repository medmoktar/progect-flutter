import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:rapport/url.dart';

class Updatechefvillage extends StatefulWidget {
  final id;
  const Updatechefvillage({super.key, required this.id});

  @override
  State<Updatechefvillage> createState() => _UpdatechefvillageState();
}

class _UpdatechefvillageState extends State<Updatechefvillage> {
  late List A = [];
  late bool t = false;
  get(id) async {
    var x = await http.get(Uri.parse("${Url().URL}/api/chefvillage/store/$id"));
    A = jsonDecode(x.body);
    _name.text = A[0]['nom_administratif'];
    _nom_local.text = A[0]['nom_local'];
    tel.text = A[0]['tel'];
    t = true;
    setState(() {});
  }

  GlobalKey<FormState> valid = GlobalKey();
  TextEditingController _name = TextEditingController();
  TextEditingController _nom_local = TextEditingController();
  TextEditingController tel = TextEditingController();
  update(id) async {
    var url = Uri.parse('${Url().URL}/api/chefvillage/update/$id');
    Map data = {
      'nom_administratif': _name.text,
      'nom_local': _nom_local.text,
      'village_id': widget.id,
      'tel': tel.text
    };

    final Map<String, String> headers = {'Content-Type': 'application/json'};

    final reponse =
        await http.patch(url, headers: headers, body: jsonEncode(data));
    print(reponse.statusCode);
    if (reponse.statusCode == 200) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.rightSlide,
        title: 'Succed',
        btnOkOnPress: () {
          // widget.onupdate();
          Navigator.of(context).pop(context);
        },
      ).show();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get(widget.id);
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
              Text("Ajouter Hopital",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text("اضافت مستشفي",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          )),
      body: t == false
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: valid,
              child: ListView(
                children: [
                  SizedBox(height: 30),
                  // Expanded(
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                        controller: _name,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(
                              left: 8, bottom: 0, top: 0, right: 15),
                          hintText: "Entrer le Nom Administratif",
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.blue,
                          ),
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
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                        controller: _nom_local,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(
                              left: 8, bottom: 0, top: 0, right: 15),
                          hintText: "Entrer le Nom Local",
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.blue,
                          ),
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

                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                        controller: tel,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.phone,
                            color: Colors.blue,
                          ),
                          contentPadding: EdgeInsets.only(
                              left: 8, bottom: 0, top: 0, right: 15),
                          hintText: "Entrer le Numero Telephone",
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
                            return "Entrer une Numero telephone";
                          }
                          return null;
                        }),
                  ),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                    child: ElevatedButton(
                        onPressed: () {
                          if (valid.currentState!.validate()) {
                            update(widget.id);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white),
                        child: Text("Enregistrer")),
                  )
                ],
              )),
    );
  }
}
