// lib/models/note.dart

class Note {
  int? id; // Primary key, auto-incremented
  String name;
  String content;

  Note({
    this.id,
    required this.name,
    required this.content,
  });

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'name': name,
      'content': content,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  // Extract a Note object from a Map object
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      name: map['name'],
      content: map['content'],
    );
  }
}
