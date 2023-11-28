class Note {
  String? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  String title;
  String content;
  String? color;
  bool? priority;
  String status;

  Note({
    this.id,
    this.createdAt,
    this.updatedAt,
    required this.title,
    required this.content,
    this.color,
    this.priority,
    required this.status,
  });

  // Factory method to create a Note object from a JSON map
  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['ID'],
      createdAt: json['CreatedAt'] != null
          ? DateTime.parse(json['CreatedAt'])
          : null,
      updatedAt: json['UpdatedAt'] != null
          ? DateTime.parse(json['UpdatedAt'])
          : null,
      title: json['Title'],
      content: json['Content'],
      color: json['Color'],
      priority: json['Priority'],
      status: json['Status'],
    );
  }

  // Method to convert a Note object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'title': title,
      'content': content,
      'color': color,
      'priority': priority,
      'status': status,
    };
  }
}
