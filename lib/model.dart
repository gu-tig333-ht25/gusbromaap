
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