import 'dart:convert';
import 'package:http/http.dart' as http;
import './main.dart';

const String ENDPOINT = 'https://todoapp-api.apps.k8s.gu.se';

/*class ToDoApi {
  final String id;
  final String title;
  final bool done;

  ToDoApi(this.id, this.title, this.done);

  // Factory-konstruktor som gör om JSON till Dart-objekt
  factory ToDoApi.fromJson(Map<String, dynamic> json) {
    return ToDoApi(json['id'], json['title'], json['done']);
  }

  Map<String, dynamic> toJson() {
    return {"title": title, "done": done};
  }
}*/

// Hämta API key
Future<String> registerApiKey() async {
  final response = await http.get(Uri.parse('$ENDPOINT/register'));
  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to get API key');
  }
}

// Hämta lista av todos från API och retunerar en omvandlad lista av ToDoApi-objekt
Future<List<ToDo>> getToDo() async {
  http.Response response = await http.get(
    Uri.parse('$ENDPOINT/todos?key=99268fd9-5743-45ca-8334-a033e82c7923'),
  );
  String body = response.body;
  print(body);
  // Gör om JSON-strängen till en lista av Map-objekt
  List<dynamic> jsonList = jsonDecode(body);

  // Omvandla varje JSON-objekt i jsonList till ett ToDoApi-objekt med factory,
  // och samla alla objekt i en lista
  List<ToDo> todos = jsonList.map((json) => ToDo.fromJson(json)).toList();

  return todos;
}

/*Future<List<ToDoApi>> addToDo() async {
  http.post(
    Uri.parse('$ENDPOINT/todos?key=99268fd9-5743-45ca-8334-a033e82c7923'),
  );
}*/
