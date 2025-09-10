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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Tar bort debug-bannern
      title: 'TIG333 TODO',
      home: Scaffold(
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
                ), // Understrykning))),
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
            // tomt sålänge
          },
          backgroundColor: Colors.grey,
          shape: CircleBorder(),
          child: Icon(Icons.add, color: Colors.white, size: 45),
        ),
      ),
    );
  }
}
