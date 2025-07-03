import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/models/task_model.dart';

class TaskTile extends StatefulWidget {
  final TaskModel task;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onToggleComplete;

  const TaskTile({
    super.key,
    required this.task,
    this.onEdit,
    this.onDelete,
    this.onToggleComplete,
  });

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.high:
        return const Color(0xFFE57373);
      case Priority.mid:
        return const Color(0xFFFF9800);
      case Priority.low:
        return const Color(0xFF4CAF50);
    }
  }

  String _getPriorityLabel(Priority priority) {
    switch (priority) {
      case Priority.high:
        return 'HIGH';
      case Priority.mid:
        return 'MED';
      case Priority.low:
        return 'LOW';
    }
  }

  IconData _getPriorityIcon(Priority priority) {
    switch (priority) {
      case Priority.high:
        return Icons.keyboard_double_arrow_up_rounded;
      case Priority.mid:
        return Icons.keyboard_arrow_up_rounded;
      case Priority.low:
        return Icons.keyboard_arrow_down_rounded;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final taskDate = DateTime(date.year, date.month, date.day);

    if (taskDate == today) {
      return 'Today';
    } else if (taskDate == today.add(const Duration(days: 1))) {
      return 'Tomorrow';
    } else if (taskDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else {
      return DateFormat('MMM dd').format(date);
    }
  }

  bool _isOverdue() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final taskDate = DateTime(
      widget.task.date.year,
      widget.task.date.month,
      widget.task.date.day,
    );
    return taskDate.isBefore(today) && !widget.task.isCompleted;
  }

  Widget _buildPriorityChip() {
    final priority = widget.task.priority;
    final color = _getPriorityColor(priority);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.6), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getPriorityIcon(priority), size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            _getPriorityLabel(priority),
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateChip() {
    final isOverdue = _isOverdue();
    final dateColor = isOverdue
        ? const Color(0xFFE57373)
        : Theme.of(context).colorScheme.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isOverdue
            ? const Color(0xFFE57373).withValues(alpha: 0.15)
            : Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isOverdue
              ? const Color(0xFFE57373).withValues(alpha: 0.4)
              : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isOverdue ? Icons.schedule_rounded : Icons.calendar_today_rounded,
            size: 14,
            color: dateColor,
          ),
          const SizedBox(width: 6),
          Text(
            _formatDate(widget.task.date),
            style: TextStyle(
              color: dateColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator() {
    if (widget.task.isCompleted) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF4CAF50).withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFF4CAF50).withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_rounded,
              size: 14,
              color: const Color(0xFF4CAF50),
            ),
            const SizedBox(width: 4),
            Text(
              'DONE',
              style: TextStyle(
                color: const Color(0xFF4CAF50),
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      );
    } else if (_isOverdue()) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFE57373).withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFFE57373).withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_rounded, size: 14, color: const Color(0xFFE57373)),
            const SizedBox(width: 4),
            Text(
              'OVERDUE',
              style: TextStyle(
                color: const Color(0xFFE57373),
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildCheckbox() {
    return GestureDetector(
      onTap: widget.onToggleComplete,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.task.isCompleted
              ? _getPriorityColor(widget.task.priority)
              : Colors.transparent,
          border: Border.all(
            color: widget.task.isCompleted
                ? _getPriorityColor(widget.task.priority)
                : Theme.of(context).colorScheme.outline.withValues(alpha: 0.6),
            width: 2,
          ),
        ),
        child: widget.task.isCompleted
            ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isOverdue = _isOverdue();

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: widget.task.isCompleted
                  ? theme.colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.6,
                    )
                  : theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: widget.task.isCompleted
                    ? theme.colorScheme.outline.withValues(alpha: 0.4)
                    : isOverdue
                    ? const Color(0xFFE57373).withValues(alpha: 0.6)
                    : theme.colorScheme.outline.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),

                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _buildCheckbox(),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.task.title,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    decoration: widget.task.isCompleted
                                        ? TextDecoration.lineThrough
                                        : null,
                                    color: widget.task.isCompleted
                                        ? theme.colorScheme.onSurface
                                              .withValues(alpha: 0.6)
                                        : theme.colorScheme.onSurface,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),

                                if (widget.task.description.isNotEmpty)
                                  Text(
                                    widget.task.description,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: widget.task.isCompleted
                                          ? theme.colorScheme.onSurfaceVariant
                                                .withValues(alpha: 0.6)
                                          : theme.colorScheme.onSurfaceVariant,
                                      decoration: widget.task.isCompleted
                                          ? TextDecoration.lineThrough
                                          : null,
                                      height: 1.4,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),

                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Material(
                                color: theme.colorScheme.primary.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: widget.onEdit,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Icon(
                                      Icons.edit_rounded,
                                      size: 18,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Material(
                                color: const Color(
                                  0xFFE57373,
                                ).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: widget.onDelete,
                                  child: const Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Icon(
                                      Icons.delete_rounded,
                                      size: 18,
                                      color: Color(0xFFE57373),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      Row(
                        children: [
                          _buildPriorityChip(),
                          const SizedBox(width: 8),
                          _buildDateChip(),
                          const Spacer(),
                          _buildStatusIndicator(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
