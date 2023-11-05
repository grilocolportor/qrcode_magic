import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qrcode_magic/pages/index.dart';
import 'package:qrcode_magic/pages/new_qr.dart';
import 'package:qrcode_magic/pages/scan_qr.dart';
import 'package:qrcode_magic/pages/show_result_scan.dart';
import 'package:qrcode_magic/theme.dart';
import 'package:upgrader/upgrader.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Upgrader.clearSavedSettings();
  MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QRCode Magic',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: appTheme,
      initialRoute: '/',
      routes: {
        '/': (ctx) => const Index(),
        '/newqr': (ctx) => const NewQR(),
        '/scanqr': (ctx) => const ScanQR(),
        '/showresultscan': (ctx) =>  ShowResultScan(),
      },
      builder: (ctx, widget) {

        return Scaffold(
          body: UpgradeAlert(
              child: Scaffold(
                appBar: AppBar(title: const Text('QRCode Magic')),
                body: Column(

                  children: [
                    Expanded(child: widget ?? Container()),
                    // Container(
                    //   alignment: Alignment.center,
                    //   width: myBanner.size.width.toDouble(),
                    //   height: myBanner.size.height.toDouble(),
                    //   child: AdWidget(
                    //     ad: myBanner,
                    //   ),
                    // )
                  ],
                ),
              )),
        );
      },
    );
  }
}