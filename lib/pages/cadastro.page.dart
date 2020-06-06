import 'package:flutter/material.dart';

class CadastroPage extends StatelessWidget {

  var _formKey = GlobalKey<FormState>();

  String nome;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  onPressed: () {
                    if(_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      //TODO: Salvar dados na API
                      Navigator.of(context).pop();
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
