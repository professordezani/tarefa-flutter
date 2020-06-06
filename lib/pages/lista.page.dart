import 'package:flutter/material.dart';
import 'package:tarefas_app/models/tarefa.dart';
import 'package:tarefas_app/widgets/tarefa-item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;


class ListaPage extends StatelessWidget {

  Future<List<Tarefa>> onLoadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    var response = await http.get(
      'https://tarefas-api.herokuapp.com/tarefa',
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + token
      },
    );

    var lista = List<Tarefa>();

    if (response.statusCode == 200) { 
      Iterable jsonResponse = convert.jsonDecode(response.body);
      for(var item in jsonResponse) { 
        lista.add(Tarefa.fromJson(item));
      }      
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }

    return lista;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Tarefas"),
        actions: [
          IconButton(
            icon: Icon(Icons.power_settings_new),
            onPressed: () {},
          ),
        ],
      ),
      body: FutureBuilder(
        future: onLoadData(),
        builder: (_, AsyncSnapshot<List<Tarefa>> snapshot) {

          if(snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator(),);

          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (_, index) {
              return TarefaItem(snapshot.data[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/cadastro');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
