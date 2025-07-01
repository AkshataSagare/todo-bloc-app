import 'package:uuid/uuid.dart';

enum Priority { high, mid, low }

class TaskModel {
  final String id;
  final String title;
  final String description;
  final Priority priority;
  final DateTime date;
  final bool isCompleted;
  final DateTime createdOn;

  TaskModel({
    String? id,
    DateTime? createdOn,
    required this.title,
   
    required this.description,
    
    required this.priority,
    required this.date,
     required this.isCompleted,
  }) : id = id ?? const Uuid().v1(),
       createdOn = createdOn ?? DateTime.now();

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      priority: json['priority'],
      date: json['date'],
      isCompleted: json['isCompleted'],
      createdOn: json['createdOn'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority.name,
      'date': date.toIso8601String(),
      'isCompleted': isCompleted,
      'createdOn': createdOn.toIso8601String()
    };
  }
}
