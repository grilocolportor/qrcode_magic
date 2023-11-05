import 'package:flutter/material.dart';
import 'package:qrcode_magic/components/AppButton.dart';

class AppAlertDialog extends StatelessWidget {
  final String text;

  const AppAlertDialog({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error,
              size: 80.0,
              color: Colors.red[500],
            ),
            const SizedBox(height: 5),
            Text(
              text,
              style: theme.textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 5),
            AppButton(
                child: Text(
                  'Ok',
                  style: theme.textTheme.bodyText1?.copyWith(color: Colors.white),
                ),
                onPressed: () => Navigator.of(context).pop())
          ],
        ),
      ),
    );
  }
}
