import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rapport/packages/dropdown.dart';
import 'package:rapport/url.dart';
import 'package:http/http.dart' as http;

class Infovillage extends StatefulWidget {
  final id;

  const Infovillage({super.key, required this.id});
  @override
  State<Infovillage> createState() => _Infovillage();
}

class _Infovillage extends State<Infovillage> {
  late List eaux = [];
  pointeaux() async {
    var x = await http.get(Uri.parse("${Url().URL}/api/pointdeaux"));
    eaux = jsonDecode(x.body);
    setState(() {});
  }

  late List langue = [];
  language() async {
    var x = await http.get(Uri.parse("${Url().URL}/api/language"));
    langue = jsonDecode(x.body);
    setState(() {});
  }

  late List reseau = [];
  reseaux() async {
    var x = await http.get(Uri.parse("${Url().URL}/api/reseaux"));
    reseau = jsonDecode(x.body);
    setState(() {});
  }

  late AppTextField d, e, f;
  TextEditingController x = TextEditingController();
  TextEditingController y = TextEditingController();
  TextEditingController z = TextEditingController();
  int a = 0, b = 1;
  createR(id, List data) async {
    var url = Uri.parse("${Url().URL}/api/village/reseaux/$id");
    final Map<String, String> headers = {'Content-Type': 'application/json'};
    int x = 0;
    for (var i = 0; i < data.length; i++) {
      var response = await http.post(url,
          headers: headers, body: jsonEncode({'nom': data[i]}));
      if (response.statusCode != 201) {
        x = 1;
      }
    }
    if (x == 0) {
      a = 201;
    }
  }

  createL(id, List data) async {
    var url = Uri.parse("${Url().URL}/api/village/language/$id");
    final Map<String, String> headers = {'Content-Type': 'application/json'};
    int x = 0;
    for (var i = 0; i < data.length; i++) {
      var response = await http.post(url,
          headers: headers, body: jsonEncode({'nom': data[i]}));
      if (response.statusCode != 201) {
        x = 1;
      }
    }
    if (x == 0) {
      b = 201;
    }
  }

  createP(id, List data) async {
    var url = Uri.parse("${Url().URL}/api/village/pointdeaux/$id");
    final Map<String, String> headers = {'Content-Type': 'application/json'};
    int x = 0;
    for (var i = 0; i < data.length; i++) {
      var response = await http.post(url,
          headers: headers, body: jsonEncode({'nom': data[i]}));
      if (response.statusCode != 201) {
        x = 1;
      }
    }
    if (x == 0 && a == b) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.rightSlide,
        title: 'Succed',
        btnOkOnPress: () {
          Navigator.of(context).pop(context);
        },
      ).show();
    }
  }

  @override
  void initState() {
    pointeaux();
    language();
    reseaux();
    super.initState();
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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Info Village",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text("معلومات القرية",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          )),
      body: ListView(
        children: [
          SizedBox(
            height: 40,
          ),
          d = AppTextField(
            textEditingController: x,
            MultileSelection: true,
            cities: [
              for (var i = 0; i < eaux.length; i++)
                SelectedListItem(name: eaux[i]['nom'])
            ],
            title: "",
            hint: "Select pointd'eaux",
            isCitySelected: true,
          ),
          SizedBox(
            height: 10,
          ),
          e = AppTextField(
            textEditingController: y,
            MultileSelection: true,
            cities: [
              for (var i = 0; i < langue.length; i++)
                SelectedListItem(name: langue[i]['nom'])
            ],
            title: "",
            hint: "Select language",
            isCitySelected: true,
          ),
          SizedBox(
            height: 10,
          ),
          f = AppTextField(
            
            textEditingController: z,
            cities: [
              for (var i = 0; i < reseau.length; i++)
                SelectedListItem(name: reseau[i]['nom'])
            ],
            title: "",
            hint: "Select resaux",
            isCitySelected: true, MultileSelection: true,
          ),
          SizedBox(
            height: 50,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
                onPressed: () {
                  createR(widget.id, f.list);
                  createL(widget.id, e.list);
                  createP(widget.id, d.list);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white),
                child: Text("Enregistrer")),
          )
        ],
      ),
    );
  }
}
