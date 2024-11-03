import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rapport/url.dart';

// import 'package:rapport/hopitaux.dart';

class Updatehopital extends StatefulWidget {
  final id, idvillage;
  final Function onUpdate;
  const Updatehopital(
      {super.key,
      required this.id,
      required this.idvillage,
      required this.onUpdate});
  @override
  State<Updatehopital> createState() => _Updatehopital();
}

class _Updatehopital extends State<Updatehopital> {
  GlobalKey<FormState> valid = GlobalKey();
  var l = 18.098564, A = -15.958748;
  late File image;
  img() async {
    var Image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (Image != null) {
      image = File(Image.path);
    }
  }

  var reponse;

  get(id) async {
    var x = await http.get(Uri.parse('${Url().URL}/api/store/hopitaux/$id'));

    reponse = jsonDecode(x.body);
    _name.text = reponse['nom'];
    l = double.parse(reponse['altitude']);
    A = double.parse(reponse['longitude']);
    // image = File(reponse['photo']);
    getlocation();
    setState(() {});
  }

  late TextEditingController _name;

  // var i=reponse[1]['nom'];

  update(id, File Img) async {
    var img = await http.MultipartFile.fromPath('photo', Img.path,
        filename: p.basename(Img.path));
    var url = Uri.parse('${Url().URL}/api/update/hopitaux/$id');
    var request = http.MultipartRequest('Post', url);
    final Map<String, String> headers = {'Content-Type': 'application/json'};
    request.fields['nom'] = _name.text;
    request.fields['village_id'] = widget.idvillage.toString();
    request.fields['altitude'] = l.toString();
    request.fields['longitude'] = A.toString();
    request.files.add(img);
    request.headers.addAll(headers);
    var reponse = await request.send();
    print("Code de statut : ${reponse.statusCode}");

    if (reponse.statusCode == 200) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.rightSlide,
        title: 'Succed',
        btnOkOnPress: () {
          widget.onUpdate();
          Navigator.of(context).pop(context);
        },
      ).show();
    }
  }

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
          setState(() {});
        },
      ).show();
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          title: 'la permission de localisation est faible',
          btnOkOnPress: () {
            setState(() {});
          },
        ).show();
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
    getlocation();
    setState(() {});
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  getlocation() async {
    GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(l, A), zoom: 14)));
  }

  @override
  initState() {
    super.initState();
    // _determinePosition();
    get(widget.id);
    _name = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Text("Localisation"),
      ),
      appBar: AppBar(
          toolbarHeight: 70,
          elevation: 10.0,
          shadowColor: const Color(0xff858DE0),
          backgroundColor: const Color(0xff858DE0),
          // leading: const
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Modiffier Hopital",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Text("تغيير مستشفي",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          )),
      body: Form(
          key: valid,
          child: ListView(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 50, left: 70),
                child: const Text("Nom",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              ),
              const Padding(padding: EdgeInsets.only(left: 100)),
              // Expanded(
              Container(
                padding: const EdgeInsets.only(left: 60, right: 60),
                child: TextFormField(
                    controller: _name,
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                      // prefixIcon: Icon(Icons.lock_outline),
                      hintText: "Entrer Le Nom de L'hopital",
                      hintStyle: TextStyle(fontWeight: FontWeight.w300),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: Color(0xffD9D9D9))),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: Color(0xffD9D9D9))),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: Color(0xffD9D9D9))),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: Color(0xffD9D9D9))),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Entrer une Nom";
                      }
                      return null;
                    }),
              ),

              Container(
                padding: EdgeInsets.only(left: 80),
                child: Row(
                  children: [
                    Text(
                      "choisir une photo",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    IconButton(onPressed: img, icon: Icon(Icons.photo))
                  ],
                ),
              ),

              Container(
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 80),
                child: ElevatedButton(
                    onPressed: () {
                      _determinePosition();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[400],
                        foregroundColor: Colors.white),
                    child: Text("Localisation actuelle")),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 40),
                height: 450,
                child: GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  initialCameraPosition: CameraPosition(
                    target: LatLng(18.083553, -16.052914),
                    zoom: 11.0,
                  ),
                  markers: {
                    Marker(
                        markerId: MarkerId("1"),
                        icon: BitmapDescriptor.defaultMarker,
                        position: LatLng(l, A))
                  },
                  onTap: (argument) {
                    l = argument.latitude;
                    A = argument.longitude;
                    getlocation();
                    setState(() {});
                  },
                ),
              ),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 60),
                child: ElevatedButton(
                    onPressed: () {
                      if (valid.currentState!.validate()) {
                        update(widget.id, image);
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
