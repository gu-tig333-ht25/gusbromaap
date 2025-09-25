import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import './api.dart';

class ToDo {
  String id;
  String title;
  bool done;

  ToDo(this.title, {this.done = false, this.id = ''});

  // Factory-konstruktor som gör om JSON till Dart-objekt
  factory ToDo.fromJson(Map<String, dynamic> json) {
    var todo = ToDo(json['title']);
    todo.id = json['id'];
    todo.done = json['done'];
    return todo;
  }

  Map<String, dynamic> toJson() {
    return {"title": title, "done": done};
  }
}

enum TodoFilter { all, done, undone } // Fasta värden för filtreringen

// Här sparas data som kan ändras medan appen körs
class AppState extends ChangeNotifier {
  List<ToDo> _todos = []; // Privat lista med alla ToDo objekt
  TodoFilter _filter = TodoFilter.all; // Default all för filter

  List<ToDo> get todos {
    switch (_filter) {
      case TodoFilter.done:
        return _todos.where((t) => t.done).toList();
      case TodoFilter.undone:
        return _todos.where((t) => !t.done).toList();
      case TodoFilter.all:
        return List.unmodifiable(_todos);
    }
  } // Gör filtrerad lista tillgänglig för andra klasser och kan bara ändras inifrån AppState

  TodoFilter get filter => _filter;

  void setFilter(TodoFilter filter) {
    _filter = filter;
    notifyListeners();
  }

  void getToDos() async {
    var todos = await getToDo();
    _todos = todos;

    notifyListeners();
  }

  void addToDo(String text) {
    _todos.add(ToDo(text));
    notifyListeners();
  }

  void removeToDo(ToDo todo) {
    _todos.remove(todo);
    notifyListeners();
  }

  void toggleToDoStatus(ToDo todo) {
    todo.done = !todo.done; // växlar mellan true/false
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TIG333 TODO',
      theme: ThemeData(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          centerTitle: true,
          titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        iconTheme: IconThemeData(color: Colors.black),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: WidgetStateProperty.all(Colors.white), // textfärg
            backgroundColor: WidgetStateProperty.all(Colors.blue),
            textStyle: WidgetStateProperty.all(
              TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ), // bakgrund
      ),
      home: HomePage(), // Anropar HomePage som hemsidan
    );
  }
}

class HomePage extends StatelessWidget {
  // "Hemsidan"
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final todos = context
        .watch<AppState>()
        .todos; // Hämtar listan från AppState och lyssnar på ändringar

    int numberOfTodos = todos.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Todo Lista'),
        actions: [
          PopupMenuButton<TodoFilter>(
            icon: Icon(Icons.more_vert), // Tre punkter ikon
            tooltip: 'Filtrera',
            onSelected: (filter) {
              context.read<AppState>().setFilter(filter);
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: TodoFilter.all, child: Text('alla')),
              PopupMenuItem(value: TodoFilter.done, child: Text('färdiga')),
              PopupMenuItem(value: TodoFilter.undone, child: Text('pågående')),
            ],
          ),
        ],
      ),
      body:
          numberOfTodos ==
              0 // Om sant visas _emptyListMessage annars visas todo listan
          ? Center(child: _emptyListMessage(context))
          : ListView(
              children: todos.map((todo) => _item(context, todo)).toList(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => _AddToDoItem()),
          );
        },
        shape: CircleBorder(),
        child: Icon(Icons.add, size: 45),
      ),
    );
  }
}

class _AddToDoItem extends StatefulWidget {
  // "Lägg till sidan"
  const _AddToDoItem({super.key});

  @override
  _AddToDoItemState createState() => _AddToDoItemState();
}

class _AddToDoItemState extends State<_AddToDoItem> {
  // "Lägg till sidan" innehåll
  final TextEditingController _controller =
      TextEditingController(); // Controller för TextField

  @override
  void dispose() {
    _controller.dispose(); // Städar upp controllern när sidan försvinner
    super.dispose();
  }

  void _addToDo() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      context.read<AppState>().addToDo(text); // Lägg till ToDo i AppState
      _controller.clear(); // Töm TextField
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo Lista'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios), // Pil ikon
          tooltip: 'Tillbaka',
          onPressed: () {
            Navigator.pop(context); // Går tillbaka till föregående sida
          },
        ),
        actions: [
          PopupMenuButton<TodoFilter>(
            icon: Icon(Icons.more_vert), // Tre punkter ikon
            tooltip: 'Filtrera',
            onSelected: (filter) {
              context.read<AppState>().setFilter(filter);
              Navigator.pop(context); // Går tillbaka till föregående sida
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: TodoFilter.all, child: Text('alla')),
              PopupMenuItem(value: TodoFilter.done, child: Text('färdiga')),
              PopupMenuItem(value: TodoFilter.undone, child: Text('pågående')),
            ],
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // Default
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(
                25,
                40,
                25,
                25,
              ), // Vänster, topp, höger, botten
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
              ),
              child: TextField(
                controller: _controller,
                style: Theme.of(context).textTheme.titleLarge,
                decoration: InputDecoration(
                  hintText: "Skriv ny todo!", // Instruktions text
                ),
              ),
            ),
            TextButton.icon(
              icon: Icon(Icons.add),
              label: Text("ADD"),
              onPressed: () {
                _addToDo();
              },
            ),
          ],
        ),
      ),
    );
  }
}

Widget _emptyListMessage(BuildContext context) {
  // Retunerar Text "Finns inga todos..."
  final filter = context.watch<AppState>().filter;

  if (filter == TodoFilter.all) {
    return Text("Finns inga todos", style: TextStyle(color: Colors.grey));
  } else if (filter == TodoFilter.done) {
    return Text(
      "Finns inga färdiga todos",
      style: TextStyle(color: Colors.grey),
    );
  } else {
    return Text(
      "Finns inga pågående todos",
      style: TextStyle(color: Colors.grey),
    );
  }
}

Widget _item(BuildContext context, ToDo todo) {
  // Retunerar todo-box
  return Container(
    padding: EdgeInsets.all(15),
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(color: Theme.of(context).primaryColor, width: 2.0),
      ),
    ),
    child: Row(
      children: [
        Checkbox(
          value: todo.done,
          fillColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.selected)) {
              return Theme.of(context).primaryColor; // Färg när markerad
            }
            return Colors.transparent; // Färg när inte markerad
          }),
          onChanged: (_) {
            context.read<AppState>().toggleToDoStatus(todo);
          },
        ),
        SizedBox(width: 8),
        Text(
          todo.title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            decoration: todo.done
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
        Spacer(), // Tar upp all plats mellan texten och ikonen
        IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            context.read<AppState>().removeToDo(todo); // Tar bort ToDo:n
          },
        ),
      ],
    ),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Säkerställer att flutter initieras så status och navigeringsfält kan tas bort

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [],
  ); // Gömmer status- och navigeringsfält
  AppState state =
      AppState(); // Skapar en instans av AppState som håller koll på appens tillstånd
  state.getToDos();
  runApp(
    ChangeNotifierProvider(create: (context) => state, child: MyApp()),
  ); // Gör AppState tillgänglig i hela appen via Provider
}
