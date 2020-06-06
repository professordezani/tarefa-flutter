import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tarefas_app/models/tarefa.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class TarefaItem extends StatefulWidget {
  final Tarefa tarefa;

  TarefaItem(this.tarefa);

  @override
  _TarefaItemState createState() => _TarefaItemState();
}

class _TarefaItemState extends State<TarefaItem> {
  void setConcluida(bool value) async {
    setState(() {
      this.widget.tarefa.concluida = value;
    });

    await updateConcluida();
  }

  Future<void> updateConcluida() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    await http.put(
        'https://tarefas-api.herokuapp.com/tarefa/${widget.tarefa.id}',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ' + token
        },
        body: convert.jsonEncode(widget.tarefa.toJson()));
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      onChanged: setConcluida, //(value) { },
      title: Text(
        widget.tarefa.nome,
        style: TextStyle(
          fontWeight: FontWeight.normal,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      value: widget.tarefa.concluida,
      // subtitle: concluida ? Text('concluída') : Text('aberta'),
      // trailing: concluida
      //     ? Icon(
      //         Icons.check,
      //         color: Colors.green,
      //         size: 30,
      //       )
      //     : SizedBox(),
    );
  }
}
