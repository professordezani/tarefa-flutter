import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class LoginPage extends StatelessWidget {
  String email;
  String password;

  var _formKey = new GlobalKey<FormState>();

  Future<void> onLogin(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      var response = await http.post(
        'https://tarefas-api.herokuapp.com/usuario/login',
        body: convert.jsonEncode({"email": email, "senha": password}),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );

      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);
        print(jsonResponse);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', jsonResponse['token']);

        Navigator.of(context).pushReplacementNamed('/lista');
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.fromLTRB(16, 50, 16, 0),
          child: Form(
            key: _formKey,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "E-mail",
                  ),
                  onSaved: (value) => email = value,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Senha",
                  ),
                  obscureText: true,
                  onSaved: (value) => password = value,
                ),
                ButtonTheme(
                  minWidth: double.infinity,                  
                  child: RaisedButton(
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,                  
                    child: Text("Entrar"),
                    onPressed: () => onLogin(context),
                  ),
                ),               
                  FlatButton(                
                    child: Text("Novo Usuário"),
                    onPressed: () => {},
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
