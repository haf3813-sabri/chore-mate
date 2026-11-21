class Task {
  final String id;
  final String title;
  final String assignedTo;
  final DateTime dueDate;
  final int points;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.assignedTo,
    required this.dueDate,
    required this.points,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'assignedTo': assignedTo,
      'dueDate': dueDate.toIso8601String(),
      'points': points,
      'isCompleted': isCompleted,
    };
  }
}