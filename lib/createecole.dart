import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rapport/url.dart';

class Createecole extends StatefulWidget {
  final id;
  final Function onupdate;
  const Createecole({super.key, required this.id, required this.onupdate});
  @override
  State<Createecole> createState() => _Createecole();
}

class _Createecole extends State<Createecole> {
  GlobalKey<FormState> valid = GlobalKey();
  final TextEditingController _name = TextEditingController();
  var l = 18.098564, A = -15.958748;

  late File image;

  Img() async {
    var _image = await ImagePicker().pickImage(source: ImageSource.gallery);
    image = File(_image!.path);
  }

  create(File img) async {
    var Image = await http.MultipartFile.fromPath('photo', img.path,
        filename: p.basename(img.path));
    var url = Uri.parse('${Url().URL}/api/create/Ecole');
    var request = http.MultipartRequest('POST', url);

    final Map<String, String> headers = {'Content-Type': 'application/json'};
    request.fields['nom'] = _name.text;
    request.files.add(Image);
    request.fields['village_id'] = widget.id.toString();
    request.fields['altitude'] = l.toString();
    request.fields['longitude'] = A.toString();
    request.headers.addAll(headers);

    final reponse = await request.send();
    print(reponse.statusCode);
    if (reponse.statusCode == 201) {
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
          Navigator.of(context).pop();
          widget.onupdate();
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
            widget.onupdate();
            setState(() {});
          },
        ).show();
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition();
    l = position.latitude;
    A = position.longitude;
    getlocalisation();
    setState(() {});
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  getlocalisation() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(l, A), zoom: 14)));
  }

  @override
  void initState() {
    super.initState();
    _determinePosition();
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
              Text("Ajouter Ecole",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text("اضافت مدرسة",
                  style: TextStyle(fontWeight: FontWeight.bold)),
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
                      hintText: "Entrer Le Nom de L'ecole",
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
                    IconButton(onPressed: Img, icon: Icon(Icons.photo))
                  ],
                ),
              ),

              Container(
                padding: EdgeInsets.only(bottom: 70),
                height: 500,
                child: GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  initialCameraPosition: CameraPosition(
                    target: LatLng(l, A),
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
                    getlocalisation();
                    setState(() {});
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 60),
                child: ElevatedButton(
                    onPressed: () {
                      if (valid.currentState!.validate()) {
                        create(image);
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
