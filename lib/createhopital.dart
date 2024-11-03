import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rapport/packages/dropdown.dart';
import 'package:rapport/url.dart';
// import 'package:image/image.dart' as img;

class Createhopital extends StatefulWidget {
  final id;
  final Function onupdate;
  const Createhopital({super.key, required this.id, required this.onupdate});
  @override
  State<Createhopital> createState() => _Createhopital();
}

class _Createhopital extends State<Createhopital> {
  GlobalKey<FormState> valid = GlobalKey();
  final TextEditingController _name = TextEditingController();
  TextEditingController y = TextEditingController();

  var l = 18.098564, A = -15.958748;

  var image;

  Img() async {
    var _image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (_image != null) {
      print("==================");
      print(_image.path);
      print("==================");
      image = File(_image.path);
    }
  }

  imgcamera() async {
    var _image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (_image != null) {
      print("==================");
      print(_image.path);
      print("==================");
      // var imag= File(_image.path);
      //   final imageBytes = img.decodeImage(imag.readAsBytesSync());

      // // Redimensionner l'image (par exemple à une largeur de 800 pixels)
      // final resizedImage = img.copyResize(imageBytes!, width: 800);

      // // Sauvegarder l'image redimensionnée dans un fichier temporaire
      // final tempDir = await getTemporaryDirectory();
      // final tempFile = File('${tempDir.path}/resized_image.jpg')
      //   ..writeAsBytesSync(img.encodeJpg(resizedImage, quality: 85));
      image = File(_image.path);
    }
  }

  create(File? img, type) async {
    try {
      var url = Uri.parse('${Url().URL}/api/create/hopitaux');
      var request = http.MultipartRequest('Post', url);
      if (img != null) {
        var Image = await http.MultipartFile.fromPath(
          'photo',
          img.path,
          filename: p.basename(img.path),
        );
        request.files.add(Image);
      }

      final Map<String, String> headers = {'Content-Type': 'application/json'};
      request.fields['nom'] = _name.text;

      request.fields['village_id'] = widget.id.toString();
      request.fields['type'] = type;
      request.fields['altitude'] = l.toString();
      request.fields['longitude'] = A.toString();
      request.headers.addAll(headers);

      var reponse = await request.send();

      print("Code de statut : ${reponse.statusCode}");

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
    } catch (e) {
      print("Erreur lors de l'upload de l'image : $e ======");
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
    gettype();
    _determinePosition();
  }

  late List type = [];
  gettype() async {
    var $x = await http.get(Uri.parse("${Url().URL}/api/typecente"));
    type = jsonDecode($x.body);
    setState(() {});
  }

  late AppTextField T;

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
              SizedBox(
                height: 40,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                    controller: _name,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(
                          left: 8, bottom: 0, top: 0, right: 15),
                      hintText: "Entrer le nom",
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
              T = AppTextField(
                MultileSelection: false,
                textEditingController: y,
                cities: [
                  for (var i = 0; i < type.length; i++)
                    SelectedListItem(name: type[i]['nom'])
                ],
                title: "",
                hint: "Select Type",
                isCitySelected: true,
              ),
              Container(
                padding: EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    Text(
                      "choisir une photo",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    IconButton(onPressed: Img, icon: Icon(Icons.photo)),
                    Padding(padding: EdgeInsets.only(left: 10)),
                    Text(
                      "prend une photo",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                        onPressed: imgcamera,
                        icon: Icon(Icons.camera_alt_rounded)),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 40),
                height: 450,
                child: GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  initialCameraPosition: CameraPosition(
                    target: LatLng(18.098564, -15.958748),
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
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: ElevatedButton(
                    onPressed: () {
                      if (valid.currentState!.validate()) {
                        var t = T.list[0];
                        create(image, t);
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
