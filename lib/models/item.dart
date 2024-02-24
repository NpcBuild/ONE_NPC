import 'dart:convert';

class Item {
  final int id;
  final String todoName;
  final String? remark;

  Item({required this.id, required this.todoName, required this.remark});

  factory Item.fromJson(Map<String, dynamic> data) {
    return Item(
      id: data['id'],
      todoName: data['todoName'],
      remark: data['remark'],
    );
  }
}