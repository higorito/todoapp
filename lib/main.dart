import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:todoapp/modelos/item.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'APP lista de fazer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PageInicial(),
    );
  }
}

class PageInicial extends StatefulWidget {
  late List<Item>
      items; //p falar que a variavel items pode ser inicializada mais tarde

  PageInicial() {
    items = <Item>[];
    // items.add(Item(title: "Maçã", done: false));
    // items.add(Item(title: "Banana", done: true));
    // items.add(Item(title: "Arroz", done: false));
  }

  @override
  State<PageInicial> createState() => _PageInicialState();
}

class _PageInicialState extends State<PageInicial> {
  //para fazer o controle do input da tarefa
  var newTaskCtrl = TextEditingController();

  void addItem() {
    if (newTaskCtrl.text.isEmpty) return; //verificação

    setState(() {
      widget.items.add(Item(title: newTaskCtrl.text, done: false));

      newTaskCtrl.clear();
      salvarItem();
    });
  }

  void removeItem(int index) {
    setState(() {
      widget.items.removeAt(index);
      salvarItem();
    });
  }

  Future lerItem() async {
    //future é uma "promessa"  não é em tempo real(async), tipo de retorno => future
    var prefs = await SharedPreferences
        .getInstance(); //await... sintetizando: aguarde ate que SharedPreferences.getInstance() esteja completo

    var data = prefs.getString('data'); //para salvar no formato json

    if (data != null) {
      // lê uma string data codificada em JSON, decodifica-a em um objeto
      //mapeia cada item desse objeto em um objeto do tipo Item
      // e retorna uma lista de objetos Item. Se data for nulo, nada será feito.
      Iterable decoded = jsonDecode(data);
      List<Item> result = decoded.map((x) => Item.fromJson(x)).toList();

      setState(() {
        widget.items = result;
      });
    }
  }

  salvarItem() async {
    var prefs = await SharedPreferences.getInstance();

    await prefs.setString('data', jsonEncode(widget.items));
  }

  _PageInicialState() {
    //passando no construtor para n ficar atualizando toda hora no build... e tambem sempre que inicar chama o sharedpreferences e executa as rotinas
    lerItem();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          controller:
              newTaskCtrl, //aq o controlador,,,//newTaskCtrl.clear(); etc etc
          keyboardType:
              TextInputType.text, //ele escolhe qual o melhor teclado p cada
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
          ),
          decoration: InputDecoration(
            labelText: "Digite a nova tarefa",
            labelStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: ListView.builder(
        //o builder p atualizar em tempo real
        itemCount: widget.items.length, //pegar la de cima a quantidade de items
        itemBuilder: (BuildContext ctxt, int index) {
          //como deve renderizar os items
          final item = widget.items[index]; //var pra auxiliar
          return Dismissible(
            key: Key(item.title.toString()),
            child: CheckboxListTile(
              title: Text(item.title.toString()),
              //antes tinha uma key aqui
              value: item.done,
              onChanged: (value) {
                setState(() {
                  //setState apenas possivel em statefull
                  item.done = value;
                  salvarItem();
                });
              },
            ),
            background: Container(
              color: Colors.grey.withOpacity(0.3),
            ),
            onDismissed: (direction) {
              removeItem(index);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addItem, //so passa a função, inves de chamar
        child: Icon(Icons.add),
        backgroundColor: Colors.amber,
      ),
    );
  }
}
