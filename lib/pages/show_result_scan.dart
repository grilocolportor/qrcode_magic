// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../admob_config.dart';
import '../components/AppButton.dart';

class ShowResultScan extends StatefulWidget {
  const ShowResultScan({super.key});

  @override
  State<ShowResultScan> createState() => _ShowResultScanState();
}

class _ShowResultScanState extends State<ShowResultScan> {
  NativeAd? nativeAd;
  bool isNativeAdLoaded = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    loadNativeAd();
  }

  void loadNativeAd() {
    nativeAd = NativeAd(
      adUnitId: AdmobConfig.nativeAdUnitId,
      factoryId: 'listTile',
      listener: NativeAdListener(onAdLoaded: (ad) {
        setState(() {
          isNativeAdLoaded = true;
        });
      }, onAdFailedToLoad: (ad, error) {
        //loadNativeAd2();
        nativeAd!.dispose();
      }),
      request: const AdRequest(),
    );
    nativeAd!.load();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var localization = AppLocalizations.of(context);

    final String data = ModalRoute.of(context)!.settings.arguments as String;

    return SafeArea(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // GestureDetector(
              //   onTap: () => Navigator.of(context).pop(),
              //   child: const Icon(
              //     Icons.arrow_back_outlined,
              //     color: Colors.white,
              //   ),
              // ),
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text(
              //   localization!.result,
              //   textAlign: TextAlign.start,
              //   style: theme.textTheme.bodyText1?.copyWith(fontSize: 13.0),
              // ),
              Text(
                data,
                style: theme.textTheme.bodyText1
                    ?.copyWith(fontSize: 13.0, fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
        data != null
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 15),
                  AppButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: data));
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(localization.copied)));
                    },
                    child: Text(
                      localization!.copy,
                      style: theme.textTheme.bodyText2
                          ?.copyWith(color: Colors.white, fontSize: 13),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  AppButton(
                    buttonStyle: AppButtonStyle.OUTLINED,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(localization.scanNew,
                        style: theme.textTheme.bodyText1?.copyWith(
                            color: theme.primaryColor, fontSize: 13)),
                  ),
                ],
              )
            : Container(),
        const SizedBox(
          height: 8,
        ),
        isNativeAdLoaded
            ? Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                height: 265,
                child: AdWidget(
                  ad: nativeAd!,
                ),
              )
            : const SizedBox()
      ],
    ));
  }
}
