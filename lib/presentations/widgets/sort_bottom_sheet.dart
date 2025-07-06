import 'package:flutter/material.dart';

import '../data/models/enums.dart';

class SortBottomSheet extends StatefulWidget {
  final Sorting currentSorting;
  final bool isAscending;
  final Function(Sorting, bool) onApply;

  const SortBottomSheet({
    super.key,
    required this.currentSorting,
    required this.isAscending,
    required this.onApply,
  });

  @override
  State<SortBottomSheet> createState() => _SortBottomSheetState();
}

class _SortBottomSheetState extends State<SortBottomSheet> {
  late Sorting _selectedSorting;
  late bool _isAscending;

  @override
  void initState() {
    super.initState();
    _selectedSorting = widget.currentSorting;
    _isAscending = widget.isAscending;
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
              Icon(Icons.sort, size: 24),
              SizedBox(width: 10),
              Text(
                'Sort Tasks',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 20),

          Text(
            'Sort by',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 10),

          ...Sorting.values.map(
            (sorting) => RadioListTile<Sorting>(
              title: Text(_getSortingLabel(sorting)),
              value: sorting,
              groupValue: _selectedSorting,
              onChanged: (value) {
                setState(() {
                  _selectedSorting = value!;
                });
              },
              contentPadding: EdgeInsets.zero,
            ),
          ),

          SizedBox(height: 20),

          Text(
            'Sort Order',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 10),

          SwitchListTile(
            title: Text('Ascending Order'),
            subtitle: Text(
              _isAscending
                  ? 'A to Z, Low to High, Oldest to Newest'
                  : 'Z to A, High to Low, Newest to Oldest',
            ),
            value: _isAscending,
            onChanged: (value) {
              setState(() {
                _isAscending = value;
              });
            },
            contentPadding: EdgeInsets.zero,
          ),

          SizedBox(height: 30),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _selectedSorting = Sorting.title;
                      _isAscending = true;
                    });
                  },
                  child: Text('Reset'),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(elevation: 0),

                  onPressed: () {
                    widget.onApply(_selectedSorting, _isAscending);
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

  String _getSortingLabel(Sorting sorting) {
    switch (sorting) {
      case Sorting.title:
        return 'Title';
      case Sorting.dueDate:
        return 'Due Date';
      case Sorting.creationDate:
        return 'Creation Date';
      case Sorting.priority:
        return 'Priority';
    }
  }
}