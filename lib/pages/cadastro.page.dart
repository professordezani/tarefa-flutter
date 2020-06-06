import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CadastroPage extends StatelessWidget {

  var _formKey = GlobalKey<FormState>();
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<bool> create() async { 
    var preferences = await SharedPreferences.getInstance();
    var token = preferences.getString('token');

    var response = await http.post('https://tarefas-api.herokuapp.com/tarefa',
      body: jsonEncode({'nome' : nome}),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization' : 'Bearer $token'
      }
    );

    return response.statusCode == 200 ? true : false;
  }

  String nome;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Nova Tarefa"),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(16, 20, 16, 0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                autovalidate: false,
                decoration: InputDecoration(
                  hintText: 'O que você precisa fazer?',
                  labelText: 'Tarefa',
                ),
                onSaved: (value) => nome = value,
                validator: (value) => value.isEmpty ? "Campo Obrigatório" : null,
              ),
              SizedBox(height: 16,),
              ButtonTheme(
                minWidth: double.infinity,
                buttonColor: Theme.of(context).primaryColor,
                textTheme: ButtonTextTheme.primary,
                child: RaisedButton(
                  child: Text("Salvar"),
                  onPressed: () async {
                    if(_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      if(await create())
                        Navigator.of(context).pop();
                      else
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text("Falha ao cadastrar"),
                          backgroundColor: Colors.red,                          
                        ));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
