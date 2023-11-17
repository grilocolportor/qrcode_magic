import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../admob_config.dart';

class Admobs {
  NativeAd? nativeAd;
  
  static BannerAd getBannerAd(BuildContext context) {
    return BannerAd(
      adUnitId: AdmobConfig.bannerAdUnitId,
      size:
          AdSize(width: MediaQuery.of(context).size.width.toInt(), height: 60),
      request: const AdRequest(),
      listener: const BannerAdListener(),
    );
  }

  // static NativeAd getNativeAd(BuildContext contest,
  //     {bool wantSmallNativeAd = false}) {
  //   // NativeAd? nativeAd = NativeAd(
  //   //   adUnitId: AdmobConfigTeste.nativeAdUnitId,
  //   //   factoryId: wantSmallNativeAd ? "listTile" : "listTileMedium",
  //   //   listener: NativeAdListener(onAdLoaded: (ad) {
  //   //     setState(() {
  //   //       isNativeAdLoaded = true;
  //   //     });
  //   //   }, onAdFailedToLoad: (ad, error) {
  //   //     // loadNativeAd2();
  //   //     nativeAd!.dispose();
  //   //   }),
  //   //   request: const AdRequest(),
  //   // );
  //   // nativeAd.load();

  //   // return nativeAd;
  // }
}
