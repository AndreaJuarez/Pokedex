import 'package:flutter/material.dart';
import 'package:flutter_app_pokedev1/main.dart';
import 'package:flutter_app_pokedev1/pokemon.dart';
import 'pokemon.dart';
import 'search_test.dart';

class PokeDetail extends StatelessWidget {
  //Declara un campo que contenga la clase
  final Pokemon pokemon;
  PokeHub pokeHub;

  //En el constructor, se requiere el objeto
  PokeDetail({this.pokemon});

  //print(pokemon.type.toList().toString());
  bodyWidget(BuildContext context) =>
      Stack(
        children: <Widget>[
          Positioned(
            height: MediaQuery
                .of(context)
                .size
                .height / 1.4,
            width: MediaQuery
                .of(context)
                .size
                .width - 19,
            left: 10.0,
            top: MediaQuery
                .of(context)
                .size
                .height * 0.10,
            child:  Container(
              child: SingleChildScrollView( // ENCIERRA TODA LA CARTA, FUNCION DE FLUTTER, HACE QUE SE MUEVA LA TARJETA
                child: Card(
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60.0)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SizedBox(
                        height: 25.0,
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Hero(
                            tag: pokemon.img,
                            child: Container(
                              height: 200.0,
                              width: 200.0,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(pokemon.img),
                                    fit: BoxFit.cover),
                              ),
                            )),
                      ),
                      Text(pokemon.name,
                          style: TextStyle(
                              fontSize: 30.0, fontWeight: FontWeight.bold)),
                      Text("Height: ${pokemon.height}",
                          style: TextStyle(
                              fontSize: 12.0,
                              fontStyle: FontStyle.italic)),
                      Text("Weight: ${pokemon.weight}",
                          style: TextStyle(
                              fontSize: 12.0,
                              fontStyle: FontStyle.italic)),
                      Text("Types",
                          style: TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.bold)),
                      new Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width - 45,
                        padding: EdgeInsets.only(left: 40.0, right: 40.0),
                        child: new Wrap(
                          spacing: 15.0,
                          alignment: WrapAlignment.spaceAround,
                          children: pokemon.type
                              .map((t) =>
                              FilterChip(
                                  label: Text(t,
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                  backgroundColor: Colors.green[500],
                                  onSelected: (b) {
                                    print(b);
                                    print(t);
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => homePages(t)
                                    ));
                                  }))
                              .toList(),
                        ),
                      ),
                      Text("Weakness",
                          style: TextStyle(
                              fontSize: 22.0, fontWeight: FontWeight.bold)),
                      new Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width - 45,
                        padding: EdgeInsets.only(left: 40.0, right: 40.0),
                        child: new Wrap(
                          spacing: 15.0,
                          runSpacing: 4.0,
                          alignment: WrapAlignment.spaceAround,
                          children: pokemon.weaknesses
                              .map((t) =>
                              FilterChip(
                                  label: Text(
                                    t,
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  backgroundColor: Colors.blue[900],
                                  onSelected: (b) {
                                    print(b);
                                    print(t);
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => homePages(t)
                                    ));
                                  }
                              ))
                              .toList(),
                        ),
                      ),
                      Text("Prev-Evolution",
                          style: TextStyle(
                              fontSize: 22.0, fontWeight: FontWeight.bold)),
                      new Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width - 45,
                        padding: EdgeInsets.only(left: 50.0, right: 40.0),
                        child: new Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          alignment: WrapAlignment.spaceAround,
                          children: pokemon.prevEvolution == null
                              ? <Widget>[
                            Text("This is the first form",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white))
                          ]
                              : pokemon.prevEvolution
                              .map((n) =>
                              FilterChip(
                                backgroundColor: Colors.cyan[500],
                                label: Text(
                                  n.name,
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                onSelected: (b) {},
                              ))
                              .toList(),
                        ),
                      ),
                      Text("Next-Evolution",
                          style: TextStyle(
                              fontSize: 22.0, fontWeight: FontWeight.bold)),
                      new Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width - 45,
                        padding: EdgeInsets.only(left: 50.0, right: 40.0),
                        child: new Wrap(
                          spacing: 9.0,
                          runSpacing: 4.0,
                          alignment: WrapAlignment.spaceAround,
                          children: pokemon.nextEvolution == null
                              ? <Widget>[
                            Text("This is the final form",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white))
                          ]
                              : pokemon.nextEvolution
                              .map((n) =>
                              FilterChip(
                                backgroundColor: Colors.grey[700],
                                label: Text(
                                  n.name,
                                  style: TextStyle(fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                onSelected: (b) {},
                              ))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                //ORIENTACION DEL MOVIMIENTO
                scrollDirection: Axis.vertical,
                //PARA QUE REGRESE
                reverse: false,
              ),
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue[800],
        title: Text(pokemon.name),
      ),
      body: bodyWidget(context),
    );
  }
}