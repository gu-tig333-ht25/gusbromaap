import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ToDo {
  final String text;
  bool isDone;

  ToDo(this.text, {this.isDone = false});
}

// AppState är appens "state-klass". Här sparas data som kan ändras
// medan appen körs, och kan meddela UI:t när något ändras
class AppState extends ChangeNotifier {
  final List<ToDo> _todos = []; // Privat lista med alla ToDo objekt

  List<ToDo> get todos => List.unmodifiable(
    _todos,
  ); // Gör listan tillgänglig för andra klasser och kan bara ändras inifrån AppState

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
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TIG333 TODO',
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
        title: Text('TIG333 TODO'),
        centerTitle: true,
        backgroundColor: Colors.grey,
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert), // Tre punkter ikon
            tooltip: 'Meny', // namn för menyikonen
            onPressed: () {
              // tomt så länge
            },
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
        backgroundColor: Colors.grey,
        shape: CircleBorder(),
        child: Icon(Icons.add, color: Colors.white, size: 45),
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
        title: Text('TIG333 TODO'),
        centerTitle: true,
        backgroundColor: Colors.grey,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios), // Pil ikon
          tooltip: 'Tillbaka', // namn för pilikonen
          onPressed: () {
            Navigator.pop(context); // Går tillbaka till föregående sida
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert), // Tre punkter ikon
            tooltip: 'Meny', // namn för menyikonen
            onPressed: () {
              // tomt sålänge
            },
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
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: TextField(
                controller: _controller,
                style: Theme.of(context).textTheme.titleLarge,
                decoration: InputDecoration(
                  hintText: "Skriv ny ToDo!", // Instruktions text
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none, // Tar bort standard understrykning
                ),
              ),
            ),
            TextButton.icon(
              icon: Icon(Icons.add, color: Colors.black),
              label: Text(
                "ADD",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
      border: Border(bottom: BorderSide(color: Colors.grey, width: 2.0)),
    ),
    child: Row(
      children: [
        Checkbox(
          value: todo.isDone,
          fillColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.selected)) {
              return Colors.grey; // Färg när markerad
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
