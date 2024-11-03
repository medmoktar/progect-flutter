import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:rapport/url.dart';

class Createchefvillage extends StatefulWidget {
  final id;
  const Createchefvillage({super.key, required this.id});

  @override
  State<Createchefvillage> createState() => _Createchefvillage();
}

class _Createchefvillage extends State<Createchefvillage> {
  GlobalKey<FormState> valid = GlobalKey();
  TextEditingController _name = TextEditingController();
  TextEditingController NNI = TextEditingController();
  TextEditingController tel = TextEditingController();
  create() async {
    var url = Uri.parse('${Url().URL}/api/chefvillage/create');
    Map data = {
      'nom': _name.text,
      'village_id': widget.id,
      'NNI': 123,
      'tel': tel.text
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
          // widget.onupdate();
          Navigator.of(context).pop(context);
        },
      ).show();
    }
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
      body: Form(
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
                      hintText: "Entrer le nom",
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

              // Container(
              //   padding: const EdgeInsets.only(left: 60, right: 60),
              //   child: TextFormField(
              //       controller: NNI,
              //       decoration: const InputDecoration(
              //         contentPadding:
              //             EdgeInsets.symmetric(vertical: 2, horizontal: 10),
              //         // prefixIcon: Icon(Icons.lock_outline),
              //         hintText: "Entrer NNI",
              //         hintStyle: TextStyle(fontWeight: FontWeight.w300),
              //         focusedBorder: OutlineInputBorder(
              //             borderRadius: BorderRadius.all(Radius.circular(10)),
              //             borderSide: BorderSide(color: Color(0xffD9D9D9))),
              //         enabledBorder: OutlineInputBorder(
              //             borderRadius: BorderRadius.all(Radius.circular(10)),
              //             borderSide: BorderSide(color: Color(0xffD9D9D9))),
              //         focusedErrorBorder: OutlineInputBorder(
              //             borderRadius: BorderRadius.all(Radius.circular(10)),
              //             borderSide: BorderSide(color: Color(0xffD9D9D9))),
              //         errorBorder: OutlineInputBorder(
              //             borderRadius: BorderRadius.all(Radius.circular(10)),
              //             borderSide: BorderSide(color: Color(0xffD9D9D9))),
              //       ),
              //       validator: (value) {
              //         if (value!.isEmpty) {
              //           return "Entrer une NNI";
              //         }
              //         return null;
              //       }),
              // ),
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
                        create();
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
