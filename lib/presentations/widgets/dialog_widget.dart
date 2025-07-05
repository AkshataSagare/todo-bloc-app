import 'package:flutter/material.dart';

import '../data/models/task_model.dart';

class CreateAndEditTaskDialog extends StatefulWidget {
  final Function(TaskModel) onSubmit;
  final TaskModel? taskModel;

  const CreateAndEditTaskDialog({
    super.key,
    this.taskModel,
    required this.onSubmit,
  });

  @override
  State<CreateAndEditTaskDialog> createState() => _CreateAndEditTaskDialogState();
}

class _CreateAndEditTaskDialogState extends State<CreateAndEditTaskDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late Priority _selectedPriority;
  late DateTime _selectedDate;

    @override
  void initState() {
    _titleController = TextEditingController(text:  widget.taskModel?.title );
    _descriptionController = TextEditingController(text:  widget.taskModel?.description );
    _selectedPriority = widget.taskModel?.priority ??  Priority.mid;
    _selectedDate = widget.taskModel?.date ?? DateTime.now();

    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Theme.of(context).colorScheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Color _getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.high:
        return const Color(0xFFEF4444); // Red
      case Priority.mid:
        return const Color(0xFFF59E0B); // Amber
      case Priority.low:
        return const Color(0xFF10B981); // Emerald
    }
  }

  String _getPriorityLabel(Priority priority) {
    switch (priority) {
      case Priority.high:
        return 'High';
      case Priority.mid:
        return 'Medium';
      case Priority.low:
        return 'Low';
    }
  }

  void _createTask() {
    if (_formKey.currentState!.validate()) {
      final task = TaskModel(
        id: widget.taskModel?.id,
        createdOn: widget.taskModel?.createdOn,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        priority: _selectedPriority,
        date: _selectedDate,
        isCompleted: widget.taskModel?.isCompleted?? false,
      );
      
      widget.onSubmit(task);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.add_task_rounded,
                          color: Theme.of(context).colorScheme.primary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.taskModel != null? 'Edit' : 'Create New'} Task',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${widget.taskModel != null? 'Edit' : 'Fill in'} the details below',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded),
                        style: IconButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Title Field
                  Text(
                    'Task Title',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: 'Enter task title...',
                      prefixIcon: Icon(
                        Icons.title_rounded,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a task title';
                      }
                      if (value.trim().length < 3) {
                        return 'Title must be at least 3 characters long';
                      }
                      return null;
                    },
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Description Field
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Enter task description...',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(bottom: 40),
                        child: Icon(
                          Icons.description_rounded,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a task description';
                      }
                      return null;
                    },
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Priority Selection - Now as Row
                  Text(
                    'Priority Level',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: Priority.values.map((priority) {
                      final isSelected = _selectedPriority == priority;
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: priority != Priority.values.last ? 8.0 : 0,
                          ),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _selectedPriority = priority;
                              });
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected 
                                    ? _getPriorityColor(priority).withOpacity(0.1)
                                    : null,
                                border: Border.all(
                                  color: isSelected 
                                      ? _getPriorityColor(priority)
                                      : Theme.of(context).colorScheme.outline,
                                  width: isSelected ? 2 : 1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _getPriorityLabel(priority),
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                  color: isSelected 
                                      ? _getPriorityColor(priority)
                                      : null,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Date Selection
                  Text(
                    'Due Date',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _selectDate,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today_rounded,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                          Icon(
                            Icons.arrow_drop_down_rounded,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: _createTask,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child:  Text("${widget.taskModel != null? 'Save' : 'Create'} Task"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}