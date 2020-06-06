import 'package:flutter/material.dart';
import 'package:tarefas_app/models/tarefa.dart';
import 'package:tarefas_app/widgets/tarefa-item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class ListaPage extends StatefulWidget {
  @override
  _ListaPageState createState() => _ListaPageState();
}

class _ListaPageState extends State<ListaPage> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  var _tarefas = new List<Tarefa>();

  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    var response = await http.get(
      'https://tarefas-api.herokuapp.com/tarefa',
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + token
      },
    );

    var tarefas = List<Tarefa>();

    if (response.statusCode == 200) {
      Iterable jsonResponse = convert.jsonDecode(response.body);
      for (var item in jsonResponse) {
        tarefas.add(Tarefa.fromJson(item));
      }

      setState(() {
        _tarefas = tarefas;
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Falha na requisição HTTP."),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  // Future<List<Tarefa>> onLoadData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String token = prefs.getString('token');

  //   var response = await http.get(
  //     'https://tarefas-api.herokuapp.com/tarefa',
  //     headers: {
  //       'Content-Type': 'application/json; charset=UTF-8',
  //       'Authorization': 'Bearer ' + token
  //     },
  //   );

  //   var lista = List<Tarefa>();

  //   if (response.statusCode == 200) {
  //     Iterable jsonResponse = convert.jsonDecode(response.body);
  //     for(var item in jsonResponse) {
  //       lista.add(Tarefa.fromJson(item));
  //     }
  //   } else {
  //     print('Request failed with status: ${response.statusCode}.');
  //   }

  //   return lista;
  // }

  Future<void> delete(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    await http.delete('https://tarefas-api.herokuapp.com/tarefa/$id',
        headers: {'Authorization': 'Bearer ' + token});

    setState(() {
      _tarefas.removeWhere((element) => element.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Lista de Tarefas"),
        actions: [
          IconButton(
            icon: Icon(Icons.power_settings_new),
            onPressed: () {
              Navigator.of(context).popAndPushNamed('/');
            },
          ),
        ],
      ),
      // body: FutureBuilder(
      //   future: onLoadData(),
      //   builder: (_, AsyncSnapshot<List<Tarefa>> snapshot) {

      //     if(snapshot.connectionState == ConnectionState.waiting)
      //       return Center(child: CircularProgressIndicator(),);

      //     return ListView.builder(
      //       itemCount: snapshot.data.length,
      //       itemBuilder: (_, index) {
      //         return TarefaItem(snapshot.data[index]);
      //       },
      //     );
      //   },
      // ),
      body: Stack(
        children: [
          _tarefas.length == 0
              ? Center(
                  child: Text("Você não tem registros."),
                )
              : SizedBox(),
          RefreshIndicator(
            child: ListView.builder(
              itemCount: _tarefas.length,
              itemBuilder: (_, index) {
                return Dismissible(
                  onDismissed: (_) => delete(_tarefas[index].id),                  
                  background: Container(
                    color: Colors.red,
                  ),
                  key: Key(_tarefas[index].id),
                  child: TarefaItem(_tarefas[index]),
                );
              },
            ),
            onRefresh: loadData,
          ),
        ],
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
