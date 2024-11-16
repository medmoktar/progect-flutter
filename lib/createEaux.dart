import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:rapport/packages/dropdown.dart';
import 'package:rapport/url.dart';

class Createeaux extends StatefulWidget {
  final id;
  const Createeaux({super.key,required this.id });

  @override
  State<Createeaux> createState() => _CreateeauxState();
}

class _CreateeauxState extends State<Createeaux> {
  late List eaux = [];
  pointeaux() async {
    var x = await http.get(Uri.parse("${Url().URL}/api/pointdeaux"));
    eaux = jsonDecode(x.body);
    setState(() {});
  }

  late AppTextField f;
  TextEditingController z = TextEditingController();

  create(id, List data) async {
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
  void initState() {
    // TODO: implement initState
    super.initState();
    pointeaux();
  }

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
                for (var i = 0; i < eaux.length; i++)
                  SelectedListItem(name: eaux[i]['nom'])
              ],
              title: "",
              hint: "Select Points d'eaux",
              isCitySelected: true,
              MultileSelection: true,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: ElevatedButton(
                  onPressed: () {
                    create(widget.id, f.list);
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
