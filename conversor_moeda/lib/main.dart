import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?format=json&key=dd5cf3d6";

Widget buildTextField(String labeltext, String prefixtext,
    TextEditingController control, Function(String) f, String suf) {
  if (suf == "-") {
    return TextField(
      controller: control,
      keyboardType: TextInputType.number,
      style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 20.0),
      cursorColor: Colors.deepOrangeAccent,
      decoration: InputDecoration(
        labelText: labeltext,
        labelStyle: TextStyle(color: Colors.black, fontSize: 20.0),
        border: OutlineInputBorder(),
        prefixText: prefixtext,
      ),
      onChanged: f,
    );
  }
  return TextField(
    controller: control,
    keyboardType: TextInputType.number,
    style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 20.0),
    cursorColor: Colors.deepOrangeAccent,
    decoration: InputDecoration(
        labelText: labeltext,
        labelStyle: TextStyle(color: Colors.black, fontSize: 20.0),
        border: OutlineInputBorder(),
        prefixText: prefixtext,
        suffixIcon: Icon(
          Icons.arrow_circle_up,
          color: Colors.green,
        ),
        suffixStyle: TextStyle(color: Colors.green, fontSize: 20.0),
        suffixText: "|  " + suf),
    onChanged: f,
  );
}

void main() async {
  print(await getData());
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
      focusColor: Colors.deepOrangeAccent,
      labelStyle: TextStyle(color: Colors.deepOrangeAccent),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.deepOrangeAccent),
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      hintStyle: TextStyle(color: Colors.deepOrangeAccent),
    )),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(Uri.parse(request));
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late double btc;
  late double dolar;
  late double delta_btc;
  late double delta_dolar;

  final realController = TextEditingController();
  final btcController = TextEditingController();
  final dolarController = TextEditingController();

  void _realChanged(String text) {
    if (text != "") {
      double real = double.parse(text);

      dolarController.text = (real / dolar).toStringAsFixed(2);
      btcController.text = (real / btc).toStringAsFixed(12);
    }
  }

  void _btcChanged(String text) {
    if (text != "") {
      double btc = double.parse(text);
      realController.text = (btc * this.btc).toStringAsFixed(2);
      dolarController.text = (btc * this.btc / dolar).toStringAsFixed(2);
    }
  }

  void _dolarChanged(String text) {
    if (text != "") {
      double dolar = double.parse(text);
      realController.text = (dolar * this.dolar).toStringAsFixed(2);
      btcController.text = (dolar * this.dolar / btc).toStringAsFixed(12);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("\$Conversor \$"),
          backgroundColor: Colors.deepOrangeAccent,
          centerTitle: true,
        ),
        body: FutureBuilder<Map>(
            future: getData(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                      child: Text("Carregando dados...",
                          style: TextStyle(
                              color: Colors.deepOrangeAccent, fontSize: 25.0),
                          textAlign: TextAlign.center));

                default:
                  if (snapshot.hasError) {
                    return Center(
                        child: Text("Error ao carregar dados ='( !!!",
                            style: TextStyle(
                                color: Colors.deepOrangeAccent, fontSize: 25.0),
                            textAlign: TextAlign.center));
                  } else {
                    btc =
                        snapshot.data!["results"]["bitcoin"]["foxbit"]["last"];
                    dolar =
                        snapshot.data!["results"]["currencies"]["USD"]["buy"];

                    delta_btc = snapshot.data!["results"]["bitcoin"]["foxbit"]
                        ["variation"];
                    delta_dolar = snapshot.data!["results"]["currencies"]["USD"]
                        ["variation"];

                    return SingleChildScrollView(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Container(
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.monetization_on_rounded,
                                size: 150.0,
                                color: Colors.amberAccent,
                              )),
                          buildTextField("Reais", "R\$ ", realController,
                              _realChanged, "-"),
                          Divider(),
                          buildTextField(
                              "Bitcoin(foxbit)",
                              "BTC ",
                              btcController,
                              _btcChanged,
                              delta_btc.toStringAsFixed(2)),
                          Divider(),
                          buildTextField("Dolar", "US\$ ", dolarController,
                              _dolarChanged, delta_dolar.toStringAsFixed(2)),
                        ],
                      ),
                    );
                  }
              }
            }));
  }
}
