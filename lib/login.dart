import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:rapport/Willaya.dart';
import 'package:http/http.dart' as http;
import 'package:rapport/bottombar.dart';
import 'package:rapport/sqlite.dart';
import 'package:rapport/url.dart';

// ignore: camel_case_types
class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _login();
}

// ignore: camel_case_types
class _login extends State<login> {
  GlobalKey<FormState> valid = GlobalKey();

  // ignore: prefer_typing_uninitialized_variables
  var x;
  late List login = [];

  var k, p;
  fetch() async {
    x = await http.get(
      Uri.parse("${Url().URL}/api/login"),
    );

    login = jsonDecode(x.body);
  }

  bool t = true;

  @override
  initState() {
    super.initState();
    fetch();
  }

  sqlDb sql = sqlDb();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
            key: valid,
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topLeft, colors: [
                Color.fromARGB(255, 30, 28, 28),
                Color.fromARGB(255, 169, 160, 160),
                Color.fromARGB(255, 56, 51, 51),
                Color.fromARGB(255, 41, 33, 33),
              ])),
              child: Column(children: [
                Container(
                  padding: const EdgeInsets.only(top: 150, bottom: 120),
                  child: const Expanded(
                      child: Center(
                    child: Text(
                      "Login",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 25),
                    ),
                  )),
                ),
                Expanded(
                    child: Container(
                  // height: 500,
                  padding: EdgeInsets.only(bottom: 0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60),
                          topRight: Radius.circular(60))),
                  child: ListView(
                    children: [
                      SizedBox(
                        height: 60,
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 60, right: 60),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            suffixIcon: Icon(
                              Icons.email,
                              color: Colors.black,
                            ),
                            hintText: "Enter Username",
                            hintStyle: TextStyle(color: Colors.black),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 27, 24, 24))),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 28, 26, 26))),
                            focusedErrorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 27, 25, 25))),
                            errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 23, 22, 22))),
                          ),
                          validator: (value) {
                            k = 0;
                            for (var j = 0; j < login.length; j++) {
                              if (value == login[j]['email']) {
                                k = 1;
                                p = j;
                              }
                            }
                            if (value!.isNotEmpty && k == 0) {
                              return "uername incorrect";
                            }
                            if (value.isEmpty) {
                              return "le champ est vide";
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        padding:
                            const EdgeInsets.only(left: 60, right: 60, top: 30),
                        child: TextFormField(
                          obscureText: t,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                if (t == true) {
                                  t = false;
                                } else {
                                  t = true;
                                }
                                ;
                                setState(() {});
                              },
                              icon: Icon(
                                Icons.remove_red_eye_sharp,
                                color: Colors.black,
                              ),
                            ),
                            hintText: "Entrer Password",
                            hintStyle: TextStyle(color: Colors.black),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 27, 24, 24))),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 28, 26, 26))),
                            focusedErrorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 27, 25, 25))),
                            errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 23, 22, 22))),
                          ),
                          validator: (value) {
                            if (p != null) {
                              if (value!.isNotEmpty &&
                                  value != login[p]['password']) {
                                return "password incorrect";
                              }
                            }

                            if (value!.isEmpty) {
                              return "le champ est vide";
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        padding:
                            const EdgeInsets.only(left: 60, right: 60, top: 40),
                        child: ElevatedButton(
                          onPressed: () {
                            if (valid.currentState!.validate()) {
                              int id = login[p]['id'];
                              // sql.insertwillaya(id);
                              // sql.getwillaya();
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => bottombar(id: id)));
                            }
                          },
                          style: const ButtonStyle(
                              backgroundColor:
                                  WidgetStatePropertyAll(Colors.green),
                              foregroundColor:
                                  WidgetStatePropertyAll(Colors.white)),
                          child: const Text("Login"),
                        ),
                      )
                    ],
                  ),
                ))
              ]),
            )));
  }
}
