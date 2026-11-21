import 'package:flutter/material.dart';
import '/models/task_model.dart';

class TaskProvider with ChangeNotifier {
  // قائمة أولية تجريبية للمهام
  final List<Task> _tasks = [
    Task(
      id: '1',
      title: 'تنظيف المطبخ وغسل الأطباق',
      assignedTo: 'أحمد',
      dueDate: DateTime.now().add(const Duration(hours: 2)),
      points: 50,
    ),
    Task(
      id: '2',
      title: 'إخراج النفايات',
      assignedTo: 'سارة',
      dueDate: DateTime.now().add(const Duration(hours: 4)),
      points: 20,
    ),
  ];

  List<Task> get tasks => _tasks;

  // إجمالي نقاط العائلة المُنجزة
  int get totalPoints {
    return _tasks
        .where((task) => task.isCompleted)
        .fold(0, (sum, item) => sum + item.points);
  }

  // إضافة مهمة جديدة
  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners(); // إشعار الواجهة بالتحديث
  }

  // تغيير حالة الإنجاز
  void toggleTaskStatus(String id) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
      notifyListeners();
    }
  }
}