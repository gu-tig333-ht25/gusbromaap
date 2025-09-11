import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Säkerställer att flutter initieras så status och navigeringsfält kan tas bort

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [],
  ); // Gömmer status- och navigeringsfält
  runApp(MyApp());
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
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
              // tomt sålänge
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: List.generate(6, (index) {
            return Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey, width: 2.0),
                ),
              ),
              child: Row(
                children: [
                  Checkbox(value: false, onChanged: (_) {}),
                  SizedBox(width: 8), // Mellanrum mellan checkbox och text
                  Text(
                    'Saker att göra ${index + 1}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Spacer(), // tar upp all plats mellan texten och ikonen
                  Icon(Icons.close, color: Colors.black),
                ],
              ),
            );
          }),
        ),
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

class AddToDoItem extends StatelessWidget { // "Lägg till sidan"
  const AddToDoItem({super.key});

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
              child: Row(
                children: [
                  Text(
                    "Skriv ny ToDo!",
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                    // tomt sålänge
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
