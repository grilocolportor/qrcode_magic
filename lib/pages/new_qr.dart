import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:qrcode_magic/components/AppAlertDialog.dart';
import 'package:qrcode_magic/components/AppButton.dart';
import 'package:qrcode_magic/components/AppInput.dart';
import 'package:qrcode_magic/controllers/AppDropdownController.dart';
import 'package:qrcode_magic/dialogs/GenerateOptionsDialog.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class NewQR extends StatefulWidget {
  const NewQR({Key? key}) : super(key: key);

  @override
  State<NewQR> createState() => _NewQRState();
}

class _NewQRState extends State<NewQR> {
  final MethodChannel _channel = const MethodChannel("qrcode_magic");

  bool _saving = false, _sharing = false;

  final TextEditingController _dataController = TextEditingController();
  String _data =
      "https://play.google.com/store/apps/details?id=com.example.qrcode_magic";
  double _size = 220.0;
  bool _rounded = true;
  String? _image;

  void _generateQR() {
    TextEditingController sizeController = TextEditingController(),
        imageController = TextEditingController();
    AppDropdownController dropdownController = AppDropdownController('Yes');

    showDialog(
        context: context,
        builder: (ctx) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GenerateOptionsDialog(
                    sizeController: sizeController,
                    appDropdownController: dropdownController,
                    imageController: imageController,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  AppButton(
                      child: Text(
                        AppLocalizations.of(context)!.generate,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            ?.copyWith(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          _data = _dataController.value.text;
                          _rounded =
                              dropdownController.value == 'Yes' ? true : false;
                          if (sizeController.value.text.trim().isNotEmpty) {
                            _size = double.parse(sizeController.value.text);
                          }
                          if (imageController.value.text.trim().isNotEmpty) {
                            _image = imageController.value.text;
                          }
                        });
                      })
                ],
              ),
            ),
          );
        });
  }

  Future<String> _saveQR(BuildContext context) async {
    ScreenshotController controller = ScreenshotController();
    AppLocalizations? localization = AppLocalizations.of(context);

    var storage = Directory(
        "${(await _channel.invokeMethod("getExternalStorageDirectory"))}/QRCodeMagic");
    var status = await Permission.storage.status;
    if (!status.isGranted && !(await Permission.storage.request().isGranted)) {
      return Future.error(localization?.errorOccurred
              .replaceAll("%error%", localization.allowManageFiles) ??
          "");
    }

    storage.createSync(recursive: true);

    var now = DateTime.now();
    return controller
        .captureFromWidget(PrettyQr(
      data: _data,
      roundEdges: _rounded,
      size: _size / 2.625,
      image: _image != null ? FileImage(File(_image!)) : null,
    ))
        .then((value) async {
      final generatedQR = await File(
              "${storage.path}/${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}:${now.second}.png")
          .create();
      generatedQR.writeAsBytes(value);
      return generatedQR.path;
    });
  }

  Future<void> _share() async {
    return _saveQR(context)
        .then((value) => Share.shareXFiles([XFile(value)], text: 'QRCode'));
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var localization = AppLocalizations.of(context);

    return Container(
      decoration: BoxDecoration(color: theme.primaryColor),
      child: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(
                    Icons.arrow_back_outlined,
                    color: Colors.white,
                  ),
                ),
                Expanded(
                    child: Text(
                  'QRCode Manager',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyText2?.copyWith(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                )),
                GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed('/scanqr'),
                  child: const Icon(
                    Icons.qr_code_2,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(18.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          localization!.provideData,
                          style: theme.textTheme.bodyText2,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        AppInput(
                          hint: localization.exampleData,
                          controller: _dataController,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        AppButton(
                            onPressed: () {
                              if (_dataController.text.trim().isEmpty) {
                                showDialog(
                                    context: context,
                                    builder: (ctx) => AppAlertDialog(
                                        text: localization.needProvideData));
                                return;
                              }
                              _generateQR();
                            },
                            child: Text(
                              localization.generate,
                              style: theme.textTheme.bodyText1
                                  ?.copyWith(color: Colors.white),
                            )),
                        const SizedBox(
                          height: 30,
                        ),
                        PrettyQr(
                          data: _data,
                          roundEdges: _rounded,
                          size: 230,
                          image:
                              _image != null ? FileImage(File(_image!)) : null,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          localization.generatedQRObs,
                          style: theme.textTheme.bodyText1
                              ?.copyWith(color: Colors.red[500], fontSize: 13),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AppButton(
                                onPressed: _saving
                                    ? () {}
                                    : () {
                                        if (_dataController.text
                                            .trim()
                                            .isEmpty) {
                                          showDialog(
                                              context: context,
                                              builder: (ctx) => AppAlertDialog(
                                                  text: localization
                                                      .needProvideData));
                                          return;
                                        }

                                        setState(() => _saving = true);
                                        _saveQR(context).then((value) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(localization
                                                      .qrSaved
                                                      .replaceAll("%file%",
                                                          value.toString()))));
                                          setState(() => _saving = false);
                                        }).onError((error, stackTrace) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content:
                                                      Text(error.toString())));
                                        });
                                      },
                                child: _saving
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.download,
                                            color: Colors.white,
                                            size: 20.0,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            localization.save,
                                            style: theme.textTheme.bodyText1
                                                ?.copyWith(color: Colors.white),
                                          ),
                                        ],
                                      )),
                            const SizedBox(height: 5),
                            AppButton(
                                buttonStyle: AppButtonStyle.OUTLINED,
                                onPressed: _sharing
                                    ? () {}
                                    : () async {
                                        if (_dataController.text
                                            .trim()
                                            .isEmpty) {
                                          showDialog(
                                              context: context,
                                              builder: (ctx) => AppAlertDialog(
                                                  text: localization
                                                      .needProvideData));
                                          return;
                                        }

                                        setState(() => _sharing = true);
                                        await _share();
                                        setState(() => _sharing = false);
                                      },
                                child: _sharing
                                    ? SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: theme.primaryColor,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Row(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.ios_share_outlined,
                                            color: theme.primaryColor,
                                            size: 20.0,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            localization.share,
                                            textAlign: TextAlign.center,
                                            style: theme.textTheme.bodyText1
                                                ?.copyWith(
                                                    color: theme.primaryColor),
                                          ),
                                        ],
                                      ))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      )),
    );
  }
}
