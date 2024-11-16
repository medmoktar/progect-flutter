import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:rapport/packages/dropdown.dart';
import 'package:rapport/url.dart';

class Createlanguage extends StatefulWidget {
  final id;
  const Createlanguage({super.key, required this.id});

  @override
  State<Createlanguage> createState() => _CreatelanguageState();
}

class _CreatelanguageState extends State<Createlanguage> {
  late AppTextField f;
  TextEditingController z = TextEditingController();

  late List langue = [];
  language() async {
    var x = await http.get(Uri.parse("${Url().URL}/api/language"));
    langue = jsonDecode(x.body);
    setState(() {});
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
    language();
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
                for (var i = 0; i < langue.length; i++)
                  SelectedListItem(name: langue[i]['nom'])
              ],
              title: "",
              hint: "Select Language",
              isCitySelected: true,
              MultileSelection: true,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: ElevatedButton(
                  onPressed: () {
                    createL(widget.id, f.list);
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
