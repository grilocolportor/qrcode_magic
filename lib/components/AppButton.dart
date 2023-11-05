import 'package:flutter/material.dart';

enum AppButtonStyle { SOLID, OUTLINED }

class AppButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final AppButtonStyle? buttonStyle;

  const AppButton({Key? key, required this.child, required this.onPressed, this.buttonStyle = AppButtonStyle.SOLID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        decoration: buttonStyle == AppButtonStyle.OUTLINED
            ? BoxDecoration(
                border: Border.all(color: theme.primaryColor, width: 2),
                borderRadius: BorderRadius.circular(32),
              )
            : BoxDecoration(
                color: theme.primaryColor,
                borderRadius: BorderRadius.circular(32),
              ),
        padding: const EdgeInsets.fromLTRB(32, 14, 32, 14),
        child: child,
      ),
    );
  }
}
