import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? titleColor;
  final double elevation;
  final Widget? bottom;
  final bool automaticallyImplyLeading;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.backgroundColor,
    this.titleColor,
    this.elevation = 0,
    this.bottom,
    this.automaticallyImplyLeading = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget? leadingWidget = leading;
    if (leadingWidget == null && automaticallyImplyLeading) {
      final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);
      if (parentRoute?.canPop ?? false) {
        leadingWidget = _buildBackButton(context);
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.primaryColor,
        boxShadow: elevation > 0
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: elevation,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: kToolbarHeight,
              child: Row(
                children: [
                  if (leadingWidget != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: leadingWidget,
                    ),
                  Expanded(
                    child: Center(
                      child: Text(
                        title,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: titleColor ?? Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  if (actions != null) ...[
                    ...actions!,
                    const SizedBox(width: 8),
                  ],
                ],
              ),
            ),
            if (bottom != null) bottom!,
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
      onPressed: () => Navigator.of(context).pop(),
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize?.height ?? 0),
      );
}

extension on Widget? {
  get preferredSize => null;
}

// Extension for easy app bar styling
extension CustomAppBarTheme on ThemeData {
  CustomAppBar getStyledAppBar({
    required String title,
    List<Widget>? actions,
    Widget? leading,
    bool centerTitle = true,
    Color? backgroundColor,
    Color? titleColor,
    double elevation = 0,
    Widget? bottom,
  }) {
    return CustomAppBar(
      title: title,
      actions: actions,
      leading: leading,
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? primaryColor,
      titleColor: titleColor ?? Colors.white,
      elevation: elevation,
      bottom: bottom,
    );
  }
}