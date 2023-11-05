import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AppFileSelect extends StatefulWidget {
  final String? hint;
  final TextEditingController? controller;

  const AppFileSelect({Key? key, this.hint, this.controller}) : super(key: key);

  @override
  State<AppFileSelect> createState() => _AppFileSelectState();
}

class _AppFileSelectState extends State<AppFileSelect> {
  String? _value;
  final TextEditingController controller = TextEditingController();

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
        onTap: () async {
          XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
          if (image != null) {
            widget.controller?.text = image.path;
            controller.text = image.path;
          }
        },
        readOnly: true,
        controller: controller,
        style: theme.textTheme.bodyText1?.copyWith(fontSize: 14, fontWeight: FontWeight.w400),
        decoration: InputDecoration(hintText: widget.hint, border: InputBorder.none),
      ),
    );
  }
}
