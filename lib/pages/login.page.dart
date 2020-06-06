import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LoginPage extends StatelessWidget {
  var _formKey = GlobalKey<FormState>();

  String email;
  String senha;

  void _login(BuildContext context) async {
    final String url = 'https://tarefas-api.herokuapp.com/usuario/login';
    var response = await http.post(
      url,
      body: jsonEncode({'email': email, 'senha': senha}),
      headers: {'Content-Type': 'application/json; charset=utf-8'}
    );

    if(response.statusCode == 200) {
      var token = jsonDecode(response.body)['token'];
      var preferences = await SharedPreferences.getInstance();
      preferences.setString('token', token);

      Navigator.of(context).pushReplacementNamed('/lista');
    }
    else {
      print('Erro no login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.fromLTRB(16, 20, 16, 0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  width: 200,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).primaryColor,
                        Colors.white,
                      ],
                    ),
                  ),
                  margin: EdgeInsets.symmetric(vertical: 30),
                  child: Center(
                    child: Text("LOGO"),
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                  ),
                  onSaved: (value) => email = value,
                  validator: (value) =>
                      value.isEmpty ? "Campo Obrigatório" : null,
                  keyboardType: TextInputType.emailAddress,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Senha',
                  ),
                  onSaved: (value) => senha = value,
                  validator: (value) =>
                      value.isEmpty ? "Campo Obrigatório" : null,
                  obscureText: true,
                ),
                SizedBox(
                  height: 20,
                ),
                ButtonTheme(
                  minWidth: double.infinity,
                  buttonColor: Theme.of(context).primaryColor,
                  textTheme: ButtonTextTheme.primary,
                  child: RaisedButton(
                    child: Text("Entrar"),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        _login(context);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
