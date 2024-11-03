import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class Settings extends StatefulWidget {
  @override
  State<Settings> createState() => _Settings();
}

class _Settings extends State<Settings> {
  connectivity() async {
    final List<ConnectivityResult> p =
        await (Connectivity().checkConnectivity());
    if (p.contains(ConnectivityResult.bluetooth)) {
      print("Hello");
      return AwesomeDialog(
        context: context,
        dialogType: DialogType.noHeader,
        animType: AnimType.rightSlide,
        title: 'Connection Bluetooth',
        btnOkOnPress: () {},
      ).show();
    } else if (p.contains(ConnectivityResult.wifi)) {
      return AwesomeDialog(
        context: context,
        dialogType: DialogType.noHeader,
        animType: AnimType.rightSlide,
        title: 'Connection none',
        btnOkOnPress: () {},
      ).show();
    }
    print("word");
    return null;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CachedNetworkImage(
          imageUrl: "http://via.placeholder.com/350x150",
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.local_hospital),
        ),
      ),
    );
  }
}
