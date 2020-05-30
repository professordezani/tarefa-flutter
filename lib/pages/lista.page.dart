import 'package:flutter/material.dart';
import 'package:tarefas_app/widgets/tarefa-item.dart';

class ListaPage extends StatelessWidget {
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
      body: ListView(
        children: [
          TarefaItem('Estudar linguagem Dart', false),
          TarefaItem('Estudar linguagem C#', true),
          TarefaItem('Finalizar o projeto do módulo do curso de CW do Prof. Dezani', true),
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