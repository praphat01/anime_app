import 'dart:convert';

import 'package:anime_app/models/picsum.dart';
import 'package:anime_app/models/picsum.dart';
import 'package:http/http.dart' as http;

class ApiService {
  Future<List<Picsum>> get() async {
    try {
      final Response =
          await http.get(Uri.parse("https://picsum.photos/v2/list"));
      if (Response.statusCode == 200) {
        List<dynamic> json = jsonDecode(Response.body);
        return List<Picsum>.from(json.map((e) => Picsum.fromJson(e)));
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
