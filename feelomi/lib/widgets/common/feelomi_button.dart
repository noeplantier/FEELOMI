import 'package:flutter/material.dart';

enum FeelomiButtonSize { small, medium, large }
enum FeelomiButtonType { primary, secondary, outline, text }

class FeelomiButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final FeelomiButtonType type;
  final FeelomiButtonSize size;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final Color? customColor;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;

  const FeelomiButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.type = FeelomiButtonType.primary,
    this.size = FeelomiButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.customColor,
    this.padding,
    this.borderRadius, required Image leadingImage, required Color color, required Color textColor, required Color borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: _buildButton(theme),
    );
  }

  Widget _buildButton(ThemeData theme) {
    final buttonStyle = _getButtonStyle(theme);
    final contentPadding = padding ?? _getDefaultPadding();
    final buttonRadius = borderRadius ?? 8.0;

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: buttonStyle.copyWith(
        padding: MaterialStateProperty.all(contentPadding),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
          ),
        ),
      ),
      child: _buildButtonContent(theme),
    );
  }

  Widget _buildButtonContent(ThemeData theme) {
    if (isLoading) {
      return SizedBox(
        height: _getLoadingSize(),
        width: _getLoadingSize(),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            _getContentColor(theme),
          ),
        ),
      );
    }

    final textStyle = _getTextStyle(theme);
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            size: _getIconSize(),
            color: _getContentColor(theme),
          ),
          SizedBox(width: size == FeelomiButtonSize.small ? 4 : 8),
        ],
        Text(
          text,
          style: textStyle,
        ),
      ],
    );

    return content;
  }

  ButtonStyle _getButtonStyle(ThemeData theme) {
    final baseColor = customColor ?? theme.primaryColor;

    switch (type) {
      case FeelomiButtonType.primary:
        return ElevatedButton.styleFrom(
          backgroundColor: baseColor,
          foregroundColor: Colors.white,
          elevation: 2,
          disabledBackgroundColor: baseColor.withOpacity(0.6),
        );
      case FeelomiButtonType.secondary:
        return ElevatedButton.styleFrom(
          backgroundColor: baseColor.withOpacity(0.1),
          foregroundColor: baseColor,
          elevation: 0,
        );
      case FeelomiButtonType.outline:
        return ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: baseColor,
          elevation: 0,
          side: BorderSide(color: baseColor),
        );
      case FeelomiButtonType.text:
        return ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: baseColor,
          elevation: 0,
          shadowColor: Colors.transparent,
        );
    }
  }

  EdgeInsetsGeometry _getDefaultPadding() {
    switch (size) {
      case FeelomiButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
      case FeelomiButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
      case FeelomiButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 16);
    }
  }

  double _getIconSize() {
    switch (size) {
      case FeelomiButtonSize.small:
        return 16;
      case FeelomiButtonSize.medium:
        return 20;
      case FeelomiButtonSize.large:
        return 24;
    }
  }

  double _getLoadingSize() {
    switch (size) {
      case FeelomiButtonSize.small:
        return 16;
      case FeelomiButtonSize.medium:
        return 20;
      case FeelomiButtonSize.large:
        return 24;
    }
  }

  TextStyle _getTextStyle(ThemeData theme) {
    final baseStyle = TextStyle(
      color: _getContentColor(theme),
      fontWeight: FontWeight.w600,
    );

    switch (size) {
      case FeelomiButtonSize.small:
        return baseStyle.copyWith(fontSize: 12);
      case FeelomiButtonSize.medium:
        return baseStyle.copyWith(fontSize: 14);
      case FeelomiButtonSize.large:
        return baseStyle.copyWith(fontSize: 16);
    }
  }

  Color _getContentColor(ThemeData theme) {
    final baseColor = customColor ?? theme.primaryColor;
    
    switch (type) {
      case FeelomiButtonType.primary:
        return Colors.white;
      case FeelomiButtonType.secondary:
      case FeelomiButtonType.outline:
      case FeelomiButtonType.text:
        return baseColor;
    }
  }
}