import 'package:flutter/material.dart';

class Item {
  String? title; //lembrar de colocar um ! na hora de chamar senao da ruim
  bool? done;

  Item({this.title, this.done}); //construtor

  //metodos converter de json e converter para json
  //LEMBRE-SE DO SITE JSON TO DART
  Item.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    done = json['done'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['done'] = this.done;
    return data;
  }
}

//var item = new Item(title: "oi", done: true);
