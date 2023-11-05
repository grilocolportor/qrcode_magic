import 'package:flutter/material.dart';

class AppInput extends StatelessWidget {
  final String? hint, defaultValue;
  final TextEditingController? controller;
  final TextInputType? keyboardType;

  const AppInput({Key? key, this.hint, this.defaultValue, this.controller, this.keyboardType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xFFF0F0F0),
      ),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
      child: TextField(
        keyboardType: keyboardType,
        controller: controller,
        style: theme.textTheme.bodyText1?.copyWith(fontSize: 14, fontWeight: FontWeight.w400),
        decoration: InputDecoration(hintText: hint, border: InputBorder.none),
      ),
    );
  }
}
