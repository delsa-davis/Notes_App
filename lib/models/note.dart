class Note {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;

  const Note({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
  });

  Note copyWith({String? title, String? description}) {
    return Note(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}
