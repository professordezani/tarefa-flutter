import 'package:flutter/material.dart';
import 'package:tarefas_app/widgets/tarefa-item.dart';
import 'package:tarefas_app/models/tarefa.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ListaPage extends StatefulWidget {
  @override
  _ListaPageState createState() => _ListaPageState();
}

class _ListaPageState extends State<ListaPage> {
  List<Tarefa> tarefas = new List<Tarefa>();

  final String url = 'https://tarefas-api.herokuapp.com/tarefa';

  Future<void> _loadData() async {
    // recuperar o token:
    var preferences = await SharedPreferences.getInstance();
    final String token = preferences.getString('token');

    // acessar a API:
    var response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      var _lista = new List<Tarefa>();
      Iterable dados = jsonDecode(response.body);
      for (var item in dados) {
        _lista.add(Tarefa.fromJson(item));
      }
      setState(() {
        tarefas = _lista;
      });
    }
    // else if(response.statusCode == 401) {
    //   // Navigator.of(context).pushReplacementNamed('/');
    // }
  }

  Future<void> _delete(String id) async {
    // recuperar o token:
    var preferences = await SharedPreferences.getInstance();
    final String token = preferences.getString('token');

    // acessar a API:
    var response = await http.delete(
      url + '/$id',
      headers: {'Authorization': 'Bearer $token'},
    );

    if(response.statusCode == 200) {
      setState(() { 
        tarefas.removeWhere((item) => item.id == id);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadData();
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
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: ListView.builder(
          itemCount: tarefas.length,
          itemBuilder: (_, i) {
            return Dismissible(
              background: Container(color: Colors.red),
              key: Key(tarefas[i].id),
              onDismissed: (_) => _delete(tarefas[i].id),
              child: TarefaItem(
                tarefas[i],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.of(context).pushNamed('/cadastro');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
