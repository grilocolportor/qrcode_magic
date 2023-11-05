
import 'package:flutter/material.dart';
import '../components/AppDropdown.dart';
import '../components/AppFileSelect.dart';
import '../components/AppInput.dart';
import '../controllers/AppDropdownController.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GenerateOptionsDialog extends StatelessWidget {
  final TextEditingController sizeController, imageController;
  final AppDropdownController appDropdownController;

  const GenerateOptionsDialog(
      {Key? key,
      required this.sizeController,
      required this.appDropdownController,
      required this.imageController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var localization = AppLocalizations.of(context);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(localization!.size,
                    style: theme.textTheme.bodyText2?.copyWith(fontSize: 14)),
                AppInput(
                  hint: "150",
                  controller: sizeController,
                  keyboardType: TextInputType.number,
                )
              ],
            )),
            const SizedBox(
              width: 15,
            ),
            Expanded(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(localization.rounded,
                    style: theme.textTheme.bodyText2?.copyWith(fontSize: 14)),
                AppDropdown(
                  values: const ['Yes', 'No'],
                  defaultValue: 'Yes',
                  controller: appDropdownController,
                )
              ],
            ))
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(localization.imageSelect,
                style: theme.textTheme.bodyText2?.copyWith(fontSize: 14)),
            AppFileSelect(
              controller: imageController,
              hint: localization.clickToSelect,
            )
          ],
        )
      ],
    );
  }
}
