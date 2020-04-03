import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app_pokedev1/ver_detalles.dart';
import 'package:flutter_app_pokedev1/pokemon.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_app_pokedev1/search_test.dart';

void main() => runApp(new MaterialApp(
  navigatorKey: nav,
  home: new MyApp(),
  theme: ThemeData(brightness: Brightness.dark, fontFamily: 'Center'),
  debugShowCheckedModeBanner: false, //BANER DE DEPURACION
));

final GlobalKey<NavigatorState> nav = GlobalKey<NavigatorState>();

//void main() {
//runApp(new MaterialApp(
//home: new MyApp(),
//));
//}

//ESTA CLASE GUARDARA ALL
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      title: new Text(
        'Bienvenido',
        style: new TextStyle(
            fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white),
      ),
      photoSize: 200.0,
      seconds: 10,
      backgroundColor: Colors.black,
      image: Image.network(
        "https://www.stickpng.com/assets/images/5a0596df9cf05203c4b60445.png",
      ),
      navigateAfterSeconds: new AfterSplash(),
    );
  }
}

//*void main() => runApp(MyApp());
class AfterSplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
// TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false, //BANER DE DEPURACION
      theme:
      ThemeData(brightness: Brightness.light, primarySwatch: Colors.cyan),
      darkTheme: ThemeData(
          brightness: Brightness.dark, primarySwatch: Colors.blueGrey),
      home: homePage(),
    );
  }
}

//ESTA CLASE PERMITE REALIZAR CAMBIOS
class homePage extends StatefulWidget {
  @override
  _myHomePageState createState() => new _myHomePageState();
}

//ESTA CLASE GUARDA LOS CAMBIOS
class _myHomePageState extends State<homePage> {
  var url =
      "https://raw.githubusercontent.com/lupitaesp/Pokemon-1/master/todas.json";
  PokeHub pokeHub;
  //VARIABLES QUE MANDAN A TRAER CLASES QUE ESTAN EN LAS LIBRERIAS QUE PERTENECEN A CONECTIVITY
  StreamSubscription connectivitySubscription;
  ConnectivityResult _previousResult;

  @override
  void initState() {
    super.initState();
    connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult connectivityResult) {
          //SI NO HAY CONEXION NOS VA A SACAR DEL SISTEMA
      if (connectivityResult == ConnectivityResult.none) {
        SystemNavigator.pop();
         //SI HAY CONEXION NOS MANDARA A HOME PAGE
      } else if (_previousResult == ConnectivityResult.none) {
        nav.currentState
            .push(MaterialPageRoute(builder: (BuildContext _) => homePage()));
      }

      _previousResult = connectivityResult;
    });
    fetchData();
  }

  //LIBERA RECURSOS DETENIDOS
  void dispose() {
    super.dispose();
    connectivitySubscription.cancel();
  }

  void fetchData() async {
    var res = await http.get(url);
    var decodedValue = jsonDecode(res.body);
    pokeHub = PokeHub.fromJson(decodedValue);
    setState(() {});
  }

  void bajar() async {
  //async = asincrono
    var res = await http.get(url);
    print(res.body);
    var decodeJson = jsonDecode(res.body);
    pokeHub = PokeHub.fromJson(decodeJson);
    //POKEHUB AYUDA A LLAMAR LOS DATOS DESDE JSON
    print(pokeHub.toJson());
    setState(() {});
  }

  /*Control de la busqueda*/
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
            : Text("Search some pokemon"),
        leading: Container(
          child: IconButton(
            icon: Icon(_typing ? Icons.done : Icons.search),
            onPressed: () {
              print("Is typing" + _typing.toString());
              setState(() {
                _typing = !_typing;
                _search.text = "";
              });
            },
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent[100],
      ),
      body: pokeHub == null
          ? Center(
        child: CircularProgressIndicator(),
      )
          : OrientationBuilder(
        builder: (context, orientation) {
          return GridView.count(
            //
            crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
            children: pokeHub.pokemon
                .where((poke) => ((
                //BUSQUEDA POR NOMBRE
                poke.name.toLowerCase().contains(_search.text.toLowerCase())) ||
                //BUSQUEDA POR TIPO
                poke.type.toList().toList().toString().toLowerCase().contains(_search.text.toLowerCase()) ||
                //BUSQUEDA POR NUMERO
                poke.num.toString().contains(_search.text)))
            //  poke.weaknesses
                  //  .toList()
                   // .toList()
                    //.toString()
                    //.toLowerCase()
                    //.contains(_search.text.toLowerCase())))
                .map((poke) => Padding(
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
                      color: Colors.deepPurple[300],
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(100.0)),
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
}