import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qrcode_magic/components/AppButton.dart';

class ScanQR extends StatefulWidget {
  const ScanQR({Key? key}) : super(key: key);

  @override
  State<ScanQR> createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> {
  String? _code;
  QRViewController? _qrViewController;
  bool _done = false;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void initState() {
    super.initState();
    Permission.camera.status.then((cameraStatus) async {
      if (!cameraStatus.isGranted &&
          !(await Permission.camera.request()).isGranted) return false;
      return true;
    }).then((value) {
      if (!value) {
        Navigator.of(context).pop();
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(SnackBar(
            content: Text(AppLocalizations.of(context)?.allowCamera ?? '')));
        return;
      }

      setState(() => _done = true);
    });
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      _qrViewController?.pauseCamera();
    } else if (Platform.isIOS) {
      _qrViewController?.resumeCamera();
    }
  }

  @override
  void dispose() {
    _qrViewController?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() => _qrViewController = controller);
    controller.resumeCamera();
    controller.scannedDataStream.listen((scanData) {
      controller.pauseCamera();

        _qrViewController?.resumeCamera();
                                      // setState(() => _code = null);

      setState(() {
        Navigator.of(context)
            .pushNamed('/showresultscan', arguments:  scanData.code);

        //    _code = scanData.code;
      }); // _code = scanData.code);
    });
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
                  'QRCode Magic',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyText2?.copyWith(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                )),
                GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed('/newqr'),
                  child: const Icon(
                    Icons.add,
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
                    padding: const EdgeInsets.fromLTRB(32, 18, 32, 18),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          localization!.pointCamera,
                          style: theme.textTheme.bodyText2,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                            height: 300,
                            child: _done
                                ? QRView(
                                    key: qrKey,
                                    onQRViewCreated: _onQRViewCreated,
                                    overlay: QrScannerOverlayShape(
                                        borderRadius: 16.0,
                                        borderLength: 50.0,
                                        borderWidth: 5.0,
                                        borderColor: theme.primaryColor),
                                  )
                                : Container(
                                    decoration: const BoxDecoration(
                                        color: Colors.black87),
                                  )),
                        const SizedBox(
                          height: 15,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              localization.result,
                              textAlign: TextAlign.start,
                              style: theme.textTheme.bodyText1
                                  ?.copyWith(fontSize: 13.0),
                            ),
                            Text(
                              _code ?? localization.waiting,
                              style: theme.textTheme.bodyText1?.copyWith(
                                  fontSize: 13.0, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        _code != null
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 15),
                                  AppButton(
                                    onPressed: () {
                                      Clipboard.setData(
                                          ClipboardData(text: _code!));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content:
                                                  Text(localization.copied)));
                                    },
                                    child: Text(
                                      localization.copy,
                                      style: theme.textTheme.bodyText2
                                          ?.copyWith(
                                              color: Colors.white,
                                              fontSize: 13),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  AppButton(
                                    buttonStyle: AppButtonStyle.OUTLINED,
                                    onPressed: () {
                                      _qrViewController?.resumeCamera();
                                      setState(() => _code = null);
                                    },
                                    child: Text(localization.scanNew,
                                        style: theme.textTheme.bodyText1
                                            ?.copyWith(
                                                color: theme.primaryColor,
                                                fontSize: 13)),
                                  ),
                                ],
                              )
                            : Container()
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
