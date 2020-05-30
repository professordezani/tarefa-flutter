import 'package:flutter/material.dart';
import 'package:tarefas_app/pages/cadastro.page.dart';
import 'package:tarefas_app/pages/lista.page.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    var routes = {
      '/': (context) => ListaPage(),
      '/cadastro': (context) => CadastroPage(),
    };

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: routes,
      initialRoute: '/',
      // home: ListaPage(),
    );
  }
}
