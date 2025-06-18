// widgets/adaptive_widgets.dart
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../utils/platform_detector.dart';

// Adaptive App Bar
class AdaptiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const AdaptiveAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.backgroundColor,
    this.foregroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (PlatformDetector.isIOS()) {
      return CupertinoNavigationBar(
        middle: Text(title),
        leading: leading,
        trailing: actions != null && actions!.isNotEmpty
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: actions!,
              )
            : null,
        backgroundColor: backgroundColor,
      );
    } else {
      return AppBar(
        title: Text(title),
        actions: actions,
        leading: leading,
        automaticallyImplyLeading: automaticallyImplyLeading,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
      );
    }
  }

  @override
  Size get preferredSize {
    if (PlatformDetector.isIOS()) {
      return const Size.fromHeight(44.0);
    } else {
      return const Size.fromHeight(kToolbarHeight);
    }
  }
}

// Adaptive Button
class AdaptiveButton extends StatelessWidget {
  final String label;
  final void Function()? onPressed; // Changed to nullable
  final bool isPrimary;
  final bool isDestructive;
  final Widget? icon;

  const AdaptiveButton({
    Key? key,
    required this.label,
    required this.onPressed, // Still required, but can be null
    this.isPrimary = true,
    this.isDestructive = false,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (PlatformDetector.isIOS()) {
      return CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: isDestructive
            ? CupertinoColors.destructiveRed
            : isPrimary
                ? Theme.of(context).primaryColor
                : null,
        onPressed: onPressed, // Handles null (disables button)
        child: icon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  icon!,
                  const SizedBox(width: 8),
                  Text(label),
                ],
              )
            : Text(label),
      );
    } else {
      if (isPrimary) {
        return icon != null
            ? ElevatedButton.icon(
                onPressed: onPressed, // Handles null (disables button)
                icon: icon!,
                label: Text(label),
                style: isDestructive
                    ? ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      )
                    : null,
              )
            : ElevatedButton(
                onPressed: onPressed, // Handles null (disables button)
                style: isDestructive
                    ? ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      )
                    : null,
                child: Text(label),
              );
      } else {
        return icon != null
            ? OutlinedButton.icon(
                onPressed: onPressed, // Handles null (disables button)
                icon: icon!,
                label: Text(label),
                style: isDestructive
                    ? OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                      )
                    : null,
              )
            : OutlinedButton(
                onPressed: onPressed, // Handles null (disables button)
                style: isDestructive
                    ? OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                      )
                    : null,
                child: Text(label),
              );
      }
    }
  }
}

// Adaptive Switch
class AdaptiveSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const AdaptiveSwitch({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (PlatformDetector.isIOS()) {
      return CupertinoSwitch(
        value: value,
        onChanged: onChanged,
        activeColor: Theme.of(context).primaryColor,
      );
    } else {
      return Switch(
        value: value,
        onChanged: onChanged,
      );
    }
  }
}

// Adaptive Scaffold
class AdaptiveScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final Color? backgroundColor;

  const AdaptiveScaffold({
    Key? key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (PlatformDetector.isIOS()) {
      return CupertinoPageScaffold(
        navigationBar: appBar as CupertinoNavigationBar?,
        backgroundColor: backgroundColor,
        child: SafeArea(
          bottom: bottomNavigationBar != null,
          child: Column(
            children: [
              Expanded(child: body),
              if (bottomNavigationBar != null) bottomNavigationBar!,
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: appBar,
        body: body,
        bottomNavigationBar: bottomNavigationBar,
        floatingActionButton: floatingActionButton,
        backgroundColor: backgroundColor,
      );
    }
  }
}