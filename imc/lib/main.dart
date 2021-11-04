import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  String _info = "Informe seus dados";

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  void _resetFields() {
    weightController.text = "";
    heightController.text = "";
    setState(() {
      _info = "Informe seus dados";
      _formKey = GlobalKey<FormState>();
    });
  }

  void _calculate() {
    setState(() {
      double weight = double.parse(weightController.text);
      double height = double.parse(heightController.text) / 100;
      double imc = weight / (height * height);
      String imc_p = imc.toStringAsFixed(2); // variavel convertida para string

      if (imc < 18.6) {
        _info = "Abaixo do Peso\n  Info: ${imc_p}";
      } else if (imc < 24.9 && imc >= 18.6) {
        _info = "Peso ideal\n Info: ${imc_p}";
      } else if (imc < 29.9 && imc >= 24.9) {
        _info = "Levemente Acima do peso\n Info: ${imc_p}";
      } else if (imc < 34.9 && imc >= 29.9) {
        _info = "Obesidade Grau I\n Info: ${imc_p}";
      } else if (imc < 39.9 && imc >= 34.9) {
        _info = "Obesidade Grau II\n Info: ${imc_p}";
      } else if (imc >= 40) {
        _info = "Obesidade Grau III\n Info: ${imc_p}";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Calculadora de IMC"),
          centerTitle: true,
          backgroundColor: Colors.lightBlueAccent,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: _resetFields,
            )
          ],
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Icon(Icons.person_outline,
                      size: 120, color: Colors.lightBlueAccent),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: "Peso (Kg)",
                        labelStyle: TextStyle(
                            color: Colors.lightBlueAccent, fontSize: 25.0)),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.lightBlueAccent, fontSize: 25.0),
                    controller: weightController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Insira seu Peso!";
                      }
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: "Altura(cm)",
                        labelStyle: TextStyle(
                            color: Colors.lightBlueAccent, fontSize: 25.0)),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.lightBlueAccent, fontSize: 25.0),
                    controller: heightController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Insira sua Altura!";
                      }
                    },
                  ),
                  Container(
                    height: 60.0,
                    margin: EdgeInsets.only(top: 30.0, bottom: 20.0),
                    // ignore: deprecated_member_use
                    child: RaisedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _calculate();
                        }
                      },
                      child: Text(
                        "Calcular",
                        style: TextStyle(color: Colors.white, fontSize: 25.0),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      color: Colors.lightBlueAccent,
                    ),
                  ),
                  Container(
                      child: Text(
                    _info,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.lightBlueAccent, fontSize: 25.0),
                  )),
                ],
              ),
            )));
  }
}
