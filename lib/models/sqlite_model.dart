// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class SQLiteModel {
  final int id;
  final String book_id;
  final String book_name;
  SQLiteModel({
    required this.id,
    required this.book_id,
    required this.book_name,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'book_id': book_id,
      'book_name': book_name,
    };
  }

  factory SQLiteModel.fromMap(Map<String, dynamic> map) {
    return SQLiteModel(
      id: (map['id'] ?? 0) as int,
      book_id: (map['book_id'] ?? '') as String,
      book_name: (map['book_name'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SQLiteModel.fromJson(String source) => SQLiteModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
