import 'package:flutter/material.dart';

class CustomSnackbar {
  static void showSuccess({
    required BuildContext context,
    required String message,
    String? actionLabel,
    VoidCallback? onActionPressed,
    Duration duration = const Duration(seconds: 4),
  }) {
    _showSnackbar(
      context: context,
      message: message,
      type: SnackbarType.success,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
      duration: duration,
    );
  }

  static void showError({
    required BuildContext context,
    required String message,
    String? actionLabel,
    VoidCallback? onActionPressed,
    Duration duration = const Duration(seconds: 5),
  }) {
    _showSnackbar(
      context: context,
      message: message,
      type: SnackbarType.error,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
      duration: duration,
    );
  }

  static void showWarning({
    required BuildContext context,
    required String message,
    String? actionLabel,
    VoidCallback? onActionPressed,
    Duration duration = const Duration(seconds: 4),
  }) {
    _showSnackbar(
      context: context,
      message: message,
      type: SnackbarType.warning,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
      duration: duration,
    );
  }

  static void showInfo({
    required BuildContext context,
    required String message,
    String? actionLabel,
    VoidCallback? onActionPressed,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showSnackbar(
      context: context,
      message: message,
      type: SnackbarType.info,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
      duration: duration,
    );
  }

  static void _showSnackbar({
    required BuildContext context,
    required String message,
    required SnackbarType type,
    String? actionLabel,
    VoidCallback? onActionPressed,
    Duration duration = const Duration(seconds: 4),
  }) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    final theme = Theme.of(context);

    final colors = _getSnackbarColors(type, theme);

    final snackBar = SnackBar(
      content: _SnackbarContent(
        message: message,
        type: type,
        textColor: colors.textColor,
      ),
      backgroundColor: colors.backgroundColor,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colors.borderColor, width: 1),
      ),
      elevation: 0,
      action: actionLabel != null
          ? SnackBarAction(
              label: actionLabel,
              onPressed: onActionPressed ?? () {},
              textColor: colors.actionColor,
            )
          : null,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static _SnackbarColors _getSnackbarColors(
    SnackbarType type,
    ThemeData theme,
  ) {
    final colorScheme = theme.colorScheme;

    switch (type) {
      case SnackbarType.success:
        return _SnackbarColors(
          backgroundColor: colorScheme.secondary,
          textColor: colorScheme.onSecondary,
          borderColor: colorScheme.secondary,
          actionColor: colorScheme.onSecondary,
        );
      case SnackbarType.error:
        return _SnackbarColors(
          backgroundColor: colorScheme.error,
          textColor: colorScheme.onError,
          borderColor: colorScheme.error,
          actionColor: colorScheme.onError,
        );
      case SnackbarType.warning:
        return _SnackbarColors(
          backgroundColor: colorScheme.tertiary,
          textColor: colorScheme.onTertiary,
          borderColor: colorScheme.tertiary,
          actionColor: colorScheme.onTertiary,
        );
      case SnackbarType.info:
        return _SnackbarColors(
          backgroundColor: colorScheme.primary,
          textColor: colorScheme.onPrimary,
          borderColor: colorScheme.primary,
          actionColor: colorScheme.onPrimary,
        );
    }
  }
}

class _SnackbarContent extends StatelessWidget {
  final String message;
  final SnackbarType type;
  final Color textColor;

  const _SnackbarContent({
    required this.message,
    required this.type,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(_getIconForType(type), color: textColor, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            message,
            style: TextStyle(
              color: textColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  IconData _getIconForType(SnackbarType type) {
    switch (type) {
      case SnackbarType.success:
        return Icons.check_circle_outline;
      case SnackbarType.error:
        return Icons.error_outline;
      case SnackbarType.warning:
        return Icons.warning_amber_outlined;
      case SnackbarType.info:
        return Icons.info_outline;
    }
  }
}

enum SnackbarType { success, error, warning, info }

class _SnackbarColors {
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final Color actionColor;

  const _SnackbarColors({
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
    required this.actionColor,
  });
}

extension SnackbarExtension on BuildContext {
  void showSuccessSnackbar(
    String message, {
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    CustomSnackbar.showSuccess(
      context: this,
      message: message,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  void showErrorSnackbar(
    String message, {
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    CustomSnackbar.showError(
      context: this,
      message: message,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  void showWarningSnackbar(
    String message, {
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    CustomSnackbar.showWarning(
      context: this,
      message: message,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  void showInfoSnackbar(
    String message, {
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    CustomSnackbar.showInfo(
      context: this,
      message: message,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }
}
