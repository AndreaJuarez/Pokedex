import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import "ver_detalles.dart";
import "pokemon.dart";
import 'package:flutter_app_pokedev1/ver_detalles.dart';

/*class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}*/
void main() => runApp(new MaterialApp(
  home: new MyApp(),
  theme: ThemeData(brightness: Brightness.dark, fontFamily: 'Center'),
  debugShowCheckedModeBanner: false, //BANER DE DEPURACION
));

class MyApp extends StatelessWidget{
  MyApp({this.debilidad});
  String debilidad;
  //CONSTRUCTOR

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: homePages(this.debilidad),
    );
  }
}
class homePages extends StatefulWidget {
  homePages(this.debilidad);
  String debilidad;
  //CONSTRUCTOR
  @override
  _myHomePageState createState() => new _myHomePageState(this.debilidad);
}

class _myHomePageState extends State<homePages> {
  _myHomePageState(this.debilidad);
  String debilidad;
  var url =
      "https://raw.githubusercontent.com/lupitaesp/Pokemon-1/master/todas.json";
  PokeHub pokeHub;


  @override
  void initState() {
    super.initState();
    bajar();
  }

  void dispose(){
    super.dispose();
  }

  void bajar() async {
    //async = asincrono
    var res = await http.get(url);
    //print(res.body);
    var decodeJson = jsonDecode(res.body);
    pokeHub = PokeHub.fromJson(decodeJson);
    //print(pokeHub.toJson());
    setState(() {});
  }

  //*Control de la busqueda*/
  String _searchText = "";
  final TextEditingController _search = new TextEditingController();
  Widget _appBarTitle = new Text("Search Pokemon");
  bool _typing = false;

  @override
  Widget build(BuildContext context) {
// TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: _typing
            ? TextField(
          autofocus: true,
          controller: _search,
          onChanged: (text) {
            setState(() {});
          },
        )
            : Text("Pokemon"),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
      ),
      body: pokeHub == null
          ? Center(
        child: CircularProgressIndicator(),
      )
          : OrientationBuilder(
        builder: (context, orientation) {
          return GridView.count(
            crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
            children: pokeHub.pokemon
                .where((poke) => (
                //BUSQUEDA POR TIPO
                poke.weaknesses.toList().toList().toString().toLowerCase().contains(this.debilidad.toLowerCase())

            ))
                .map((Pokemon poke) => Padding(
              padding: const EdgeInsets.all(2.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PokeDetail(
                            pokemon: poke,
                          )));
                },
                child: Hero(
                  tag: poke.img,
                  child: Container(
                    child: Card(
                      color: Colors.grey[300],
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(30.0)),
                      elevation: 3.0,
                      child: Container(
                        color: Colors.transparent,
                        /* checar color*/
                        child: new Column(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            new Container(
                              height: 100.0,
                              width: 100.0,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          poke.img))),
                            ),
                            Text(
                              poke.name,
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ))
                .toList(),
          );
        },
      ),
    );
  }
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TextEditingController>('_search', _search));
    properties.add(DiagnosticsProperty<TextEditingController>('_search', _search));
    properties.add(DiagnosticsProperty<TextEditingController>('_search', _search));
  }
}