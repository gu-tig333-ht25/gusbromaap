import 'dart:convert';
import 'package:http/http.dart' as http;
import './model.dart';

const String ENDPOINT = 'https://todoapp-api.apps.k8s.gu.se';
const String apikey = '99268fd9-5743-45ca-8334-a033e82c7923';

// Hämta API key
Future<String> registerApiKey() async {
  final response = await http.get(Uri.parse('$ENDPOINT/register'));
  if (response.statusCode == 200) {
    return response.body;
  } else {
    // Om statuskoden inte är lyckad visas felmeddelande
    throw Exception('Failed to get API key');
  }
}

// Hämta lista av todos från API
Future<List<ToDo>> getToDo() async {
  http.Response response = await http.get(
    Uri.parse('$ENDPOINT/todos?key=$apikey'),
  );

  // Om statuskoden inte är mellan 200–299 (lyckad) visas felmeddelande
  if (response.statusCode < 200 || response.statusCode >= 300) {
    throw Exception('Failed to fetch todos');
  }

  List<dynamic> jsonList = jsonDecode(response.body);

  List<ToDo> todos = jsonList.map((json) => ToDo.fromJson(json)).toList();

  return todos;
}

// Skicka ny todo till API
Future<void> addToDo(ToDo todo) async {
  http.Response response = await http.post(
    Uri.parse('$ENDPOINT/todos?key=$apikey'),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(todo.toJson()),
  ); // Om statuskoden inte är mellan 200–299 visas felmeddelande
  if (response.statusCode < 200 || response.statusCode >= 300) {
    throw Exception('Failed to add todo');
  }
}

// Uppdatera todo i API
Future<void> updateToDo(ToDo todo) async {
  http.Response response = await http.put(
    Uri.parse('$ENDPOINT/todos/${todo.id}?key=$apikey'),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(todo.toJson()),
  ); // Om statuskoden inte är mellan 200–299 visas felmeddelande
  if (response.statusCode < 200 || response.statusCode >= 300) {
    throw Exception('Failed to update todo');
  }
}

// Radera todo i API
Future<void> deleteTodo(ToDo todo) async {
  http.Response response = await http.delete(
    Uri.parse('$ENDPOINT/todos/${todo.id}?key=$apikey'),
  ); // Om statuskoden inte är mellan 200–299 visas felmeddelande
  if (response.statusCode < 200 || response.statusCode >= 300) {
    throw Exception('Failed to delete todo');
  }
}
