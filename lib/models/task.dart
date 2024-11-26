class Task {
  final String id;
  final String title;
  final String description;
  final String status; // "To Do", "In Progress", "Done"
  final DateTime createdAt;
  final Duration elapsedTime;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
    this.elapsedTime = Duration.zero,
  });

  factory Task.fromTodoistJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'].toString(),
      title: json['content'].toString().length > 20
          ? json['content'].toString().substring(0, 20)
          : json['content'].toString(),
      description: json['description'] ?? '',
      status: json['is_completed'] ? "Done" : "To Do",
      // Mapping is_completed field
      createdAt: DateTime.parse(
        json['created_at'],
      ),
    );
  }

  Task copyWith({String? status, Duration? elapsedTime}) {
    return Task(
      id: this.id,
      title: this.title,
      description: this.description,
      status: status ?? this.status,
      createdAt: this.createdAt,
      elapsedTime: elapsedTime ?? this.elapsedTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      status: map['status'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
