import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('TODO lista är tom', style: TextStyle(fontSize: 24)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
