import 'package:flutter/material.dart';

import '../data/models/task_model.dart';

class FilterBottomSheet extends StatefulWidget {
  final Set<Priority> selectedPriorities;
  final Function(Set<Priority>) onApply;

  const FilterBottomSheet({
    super.key,
    required this.selectedPriorities,
    required this.onApply,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late Set<Priority> _selectedPriorities;

  @override
  void initState() {
    super.initState();
    _selectedPriorities = Set.from(widget.selectedPriorities);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 50,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: 20),

          Row(
            children: [
              Icon(Icons.filter_alt, size: 24),
              SizedBox(width: 10),
              Text(
                'Filter Tasks',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 20),

          Text(
            'Show tasks with priority',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 10),

          ...Priority.values.map(
            (priority) => CheckboxListTile(
              title: Row(
                children: [
                  _getPriorityIcon(priority),
                  SizedBox(width: 8),
                  Text(_getPriorityLabel(priority)),
                ],
              ),
              value: _selectedPriorities.contains(priority),
              onChanged: (value) {
                setState(() {
                  if (value == true) {
                    _selectedPriorities.add(priority);
                  } else {
                    _selectedPriorities.remove(priority);
                  }
                });
              },
              contentPadding: EdgeInsets.zero,
            ),
          ),

          SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _selectedPriorities.clear();
                    });
                  },
                  child: Text('Clear All'),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(elevation: 0),
                  onPressed: () {
                    widget.onApply(_selectedPriorities);
                    Navigator.pop(context);
                  },
                  child: Text('Apply'),
                ),
              ),
            ],
          ),

          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  String _getPriorityLabel(Priority priority) {
    switch (priority) {
      case Priority.high:
        return 'High Priority';
      case Priority.mid:
        return 'Medium Priority';
      case Priority.low:
        return 'Low Priority';
    }
  }

  Widget _getPriorityIcon(Priority priority) {
    switch (priority) {
      case Priority.high:
        return Icon(Icons.keyboard_arrow_up, color: Colors.red, size: 20);
      case Priority.mid:
        return Icon(Icons.remove, color: Colors.orange, size: 20);
      case Priority.low:
        return Icon(Icons.keyboard_arrow_down, color: Colors.green, size: 20);
    }
  }
}