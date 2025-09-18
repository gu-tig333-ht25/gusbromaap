import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ToDo {
  final String text;
  bool isDone;

  ToDo(this.text, {this.isDone = false});
}

enum TodoFilter { all, done, undone } // fasta värden för filtreringen

// AppState är appens "state-klass". Här sparas data som kan ändras
// medan appen körs, och kan meddela UI:t när något ändras
class AppState extends ChangeNotifier {
  final List<ToDo> _todos = []; // Privat lista med alla ToDo objekt
  TodoFilter _filter = TodoFilter.all; // default all för filter

  List<ToDo> get todos {
    switch (_filter) {
      case TodoFilter.done:
        return _todos.where((t) => t.isDone).toList();
      case TodoFilter.undone:
        return _todos.where((t) => !t.isDone).toList();
      case TodoFilter.all:
        return List.unmodifiable(_todos);
    }
  } // Gör filtrerad lista tillgänglig för andra klasser och kan bara ändras inifrån AppState

  TodoFilter get filter => _filter;

  void setFilter(TodoFilter filter) {
    _filter = filter;
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
    todo.isDone = !todo.isDone; // växlar mellan true/false
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
      home: HomePage(), // Anropar HomePage som är hemsidan
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
              PopupMenuItem(value: TodoFilter.all, child: Text('all')),
              PopupMenuItem(value: TodoFilter.done, child: Text('done')),
              PopupMenuItem(value: TodoFilter.undone, child: Text('undone')),
            ],
          ),
        ],
      ),
      body: ListView(
        children: todos.map((todo) => _item(context, todo)).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddToDoItem()),
          );
        },
        backgroundColor: Theme.of(context).primaryColor,
        shape: CircleBorder(),
        child: Icon(Icons.add, size: 45),
      ),
    );
  }
}

class AddToDoItem extends StatefulWidget {
  // "Lägg till sidan"
  const AddToDoItem({super.key});

  @override
  _AddToDoItemState createState() => _AddToDoItemState();
}

class _AddToDoItemState extends State<AddToDoItem> {
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
          tooltip: 'Tillbaka', // namn för pilikonen
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
              PopupMenuItem(value: TodoFilter.all, child: Text('all')),
              PopupMenuItem(value: TodoFilter.done, child: Text('done')),
              PopupMenuItem(value: TodoFilter.undone, child: Text('undone')),
            ],
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // default
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(
                25,
                40,
                25,
                25,
              ), // vänster, topp, höger, botten
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
          value: todo.isDone,
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
        SizedBox(width: 8), // Mellanrum mellan checkbox och text
        Text(
          todo.text,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            decoration: todo.isDone
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
        Spacer(), // tar upp all plats mellan texten och ikonen
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

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Säkerställer att flutter initieras så status och navigeringsfält kan tas bort

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [],
  ); // Gömmer status- och navigeringsfält
  AppState state =
      AppState(); // Skapar en instans av AppState som håller koll på appens tillstånd
  runApp(
    ChangeNotifierProvider(create: (context) => state, child: MyApp()),
  ); // Gör AppState tillgänglig i hela appen via Provider
}
