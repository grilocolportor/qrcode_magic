import 'package:flutter/material.dart';
import 'package:qrcode_magic/controllers/AppDropdownController.dart';

class AppDropdown extends StatefulWidget {
  final String? hint, defaultValue;
  final AppDropdownController? controller;
  final List<String> values;

  const AppDropdown({Key? key, this.hint, this.defaultValue, this.controller, required this.values}) : super(key: key);

  @override
  State<AppDropdown> createState() => _AppDropdownState();
}

class _AppDropdownState extends State<AppDropdown> {
  var _value;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xFFF0F0F0),
      ),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
      alignment: Alignment.topCenter,
      child: DropdownButton<String>(
        style: theme.textTheme.bodyText1?.copyWith(fontSize: 14, fontWeight: FontWeight.w400),
        hint: widget.hint != null ? Text(widget.hint!) : null,
        items: widget.values.map((e) => DropdownMenuItem<String>(value: e, child: Text(e))).toList(),
        onChanged: (value) => setState(() {
          widget.controller?.value = value!;
          _value = value;
        }),
        isDense: true,
        isExpanded: true,
        value: _value ?? widget.defaultValue,
        underline: Container(),
      ),
    );
  }
}
