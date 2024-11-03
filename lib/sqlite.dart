import 'dart:convert';
import 'package:rapport/url.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

class sqlDb {
  static Database? _db;

  Future<Database> Data() async {
    if (_db == null) {
      _db = await initData();
      print("init=========");
      print(_db);
      return _db!;
    } else {
      print("Sussed========");
      return _db!;
    }
  }

  Future<Database> initData() async {
    String pathData = await getDatabasesPath();
    String path = join(pathData, 'local.db');
    Database mydb = await openDatabase(path, version: 1, onCreate: _oncreate);
    return mydb;
  }

  _oncreate(Database db, int version) async {
    db.execute(
        "CREATE TABLE willaya (id INTEGER , name TEXT,nom_arabic TEXT,nb_hopitaux INTEGER,nb_ecole INTEGER,popilation INTEGER)");
    db.execute(
        "CREATE TABLE Moughataa (id INTEGER , nom TEXT,nom_arabic TEXT,willaya_id INTEGER,nb_hopitaux INTEGER,nb_ecole INTEGER,popilation INTEGER)");
    db.execute(
        "CREATE TABLE commune (id INTEGER , nom TEXT,nom_arabic TEXT,moughataa_id,nb_hopitaux INTEGER,nb_ecole INTEGER,popilation INTEGER)");
    db.execute(
        "CREATE TABLE village (id INTEGER , nom TEXT,nom_arabic TEXT,commune_id INTEGER, Popilation INTEGER,altidude REAL,longitude REAL,nb_hopitaux INTEGER,nb_ecole INTEGER)");
    db.execute(
        "CREATE TABLE hopitaux (id INTEGER , nom TEXT,photo TEXT,village_id INTEGER,altidude REAL,longitude REAL)");
    db.execute(
        "CREATE TABLE ecole (id INTEGER , nom TEXT,photo TEXT,village_id INTEGER,altidude REAL,longitude REAL)");
    db.execute(
        "CREATE TABLE chefvillage (id INTEGER , nom TEXT,village_id INTEGER,NNI TEXT,tel TEXT)");
  }

  int? idw;
  insertwillaya(int id) async {
    var x = await http.get(Uri.parse("${Url().URL}/api/users/$id"));
    List response = jsonDecode(x.body);

    for (var i = 0; i < response.length; i++) {
      var y = await http.get(
          Uri.parse("${Url().URL}/api/willaya/hopitaux/${response[i]['id']}"));
      var nb_hp = jsonDecode(y.body);
      var z = await http.get(
          Uri.parse("${Url().URL}/api/willaya/Ecole/${response[i]['id']}"));
      var nb_ecole = jsonDecode(z.body);
      Map<String, Object> data = {
        'id': response[i]['id'],
        'name': response[i]['name'],
        'nom_arabic': response[i]['nom-arabic'],
        'nb_hopitaux': nb_hp,
        'nb_ecole': nb_ecole,
      };
      Database db = await Data();
      db.insert("willaya", data);
    }
  }

  insertMoughataa(int id) async {
    var x = await http.get(Uri.parse("${Url().URL}/api/willaya/$id"));
    List response = jsonDecode(x.body);
    var y =
        await http.get(Uri.parse("${Url().URL}/api/Moughataa/hopitaux/$id"));
    var nb_hp = jsonDecode(y.body);
    var z = await http.get(Uri.parse("${Url().URL}/api/Moughataa/Ecole/$id"));
    var nb_ecole = jsonDecode(z.body);
    for (var i = 0; i < response.length; i++) {
      Map<String, Object> data = {
        'id': response[i]['id'],
        'nom': response[i]['nom'],
        'nom_arabic': response[i]['nom-arabic'],
        'willaya_id': id,
        'nb_hopitaux': nb_hp[i],
        'nb_ecole': nb_ecole[i],
      };
      Database db = await Data();
      db.insert("Moughataa", data);
    }
  }

  insertcommune(int id) async {
    var x = await http.get(Uri.parse("${Url().URL}/api/commune/$id"));
    List response = jsonDecode(x.body);
    var y = await http.get(Uri.parse("${Url().URL}/api/commune/hopitaux/$id"));
    var nb_hp = jsonDecode(y.body);
    var z = await http.get(Uri.parse("${Url().URL}/api/commune/Ecole/$id"));
    var nb_ecole = jsonDecode(z.body);
    for (var i = 0; i < response.length; i++) {
      Map<String, Object> data = {
        'id': response[i]['id'],
        'nom': response[i]['nom'],
        'nom_arabic': response[i]['nom-arabic'],
        'moughataa_id': id,
        'nb_hopitaux': nb_hp[i],
        'nb_ecole': nb_ecole[i],
      };
      Database db = await Data();
      db.insert("commune", data);
    }
  }

  insertvillage(int id) async {
    var x = await http.get(Uri.parse("${Url().URL}/api/village/$id"));
    List response = jsonDecode(x.body);
    var y = await http.get(Uri.parse("${Url().URL}/api/village/hopitaux/$id"));
    var nb_hp = jsonDecode(y.body);
    var z = await http.get(Uri.parse("${Url().URL}/api/village/Ecole/$id"));
    var nb_ecole = jsonDecode(z.body);
    for (var i = 0; i < response.length; i++) {
      Map<String, Object> data = {
        'id': response[i]['id'],
        'nom': response[i]['nom'],
        'nom_arabic': response[i]['nom-arabic'],
        'commune_id': response[i]['commune_id'],
        'Popilation': response[i]['Popilation'],
        'altidude': response[i]['altidude'],
        'longitude': response[i]['longitude'],
        'nb_hopitaux': nb_hp[i],
        'nb_ecole': nb_ecole[i],
      };
      Database db = await Data();
      db.insert("village", data);
    }
  }

  inserthopitaux(Database db, Map<String, Object> data) async {
    db = await Data();
    db.insert("hopitaux", data);
  }

  insertecole(Database db, Map<String, Object> data) async {
    db = await Data();
    db.insert("ecole", data);
  }

  insertchefvillage(Database db, Map<String, Object> data) async {
    db = await Data();
    db.insert("chefvillage", data);
  }

  getwillaya() async {
    Database db = await Data();
    return db.query("willaya");
  }

  getMoughataa(int willaya_id) async {
    Database db = await Data();
    return db.rawQuery("SELECT*FROM Moughataa WHERE willaya_id=$willaya_id");
  }

  getcommune(int moughataa_id) {
    return _db!
        .rawQuery("SELECT*FROM commune WHERE moughataa_id=$moughataa_id");
  }

  getvillage() {
    _db!.query("village");
  }

  gethopitaux() {
    _db!.query("hopitaux");
  }

  getecole() {
    _db!.query("ecole");
  }
}
