import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

enum Priority { high, mid, low }

class TaskModel extends Equatable {
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
  })  : id = id ?? const Uuid().v1(),
        createdOn = createdOn ?? DateTime.now();

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      priority: getPriorityFromString(json['priority']),
      date: DateTime.parse(json['date']),
      isCompleted: json['isCompleted'],
      createdOn: DateTime.parse(json['createdOn']),
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

  static Priority getPriorityFromString(String name) {
    switch (name) {
      case 'high':
        return Priority.high;
      case 'mid':
        return Priority.mid;
      case 'low':
        return Priority.low;
      default:
        return Priority.mid;
    }
  }

  @override
  List<Object> get props => [
        id,
        title,
        description,
        priority,
        date,
        isCompleted,
        createdOn,
      ];
}
