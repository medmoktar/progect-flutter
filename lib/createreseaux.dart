import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rapport/packages/dropdown.dart';
import 'package:rapport/url.dart';

class Createreseaux extends StatefulWidget {
  final id;
  const Createreseaux({super.key, required this.id});
  @override
  State<Createreseaux> createState() => _CreatereseauxState();
}

class _CreatereseauxState extends State<Createreseaux> {
  late List reseau = [];
  reseaux() async {
    var x = await http.get(Uri.parse("${Url().URL}/api/reseaux"));
    reseau = jsonDecode(x.body);
    setState(() {});
  }

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
  initState() {
    reseaux();
    super.initState();
  }

  late AppTextField f;
  TextEditingController z = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: ListView(
          children: [
            SizedBox(
              height: 25,
            ),
            f = AppTextField(
              textEditingController: z,
              cities: [
                for (var i = 0; i < reseau.length; i++)
                  SelectedListItem(name: reseau[i]['nom'])
              ],
              title: "",
              hint: "Select resaux",
              isCitySelected: true,
              MultileSelection: true,
              
            ),
            
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: ElevatedButton(
                  onPressed: () {
                    createR(widget.id, f.list);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white),
                  child: Text("Enregistrer")),
            )
          ],
        ));
  }
}
