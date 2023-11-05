import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:qrcode_magic/admob_config.dart';
import 'package:qrcode_magic/components/AppButton.dart';

class Index extends StatefulWidget {
  const Index({Key? key}) : super(key: key);

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {

  void initState() {
    // TODO: implement initState
    super.initState();
     
  }

  @override
  Widget build(BuildContext context) {
   
    var theme = Theme.of(context);
    var localization = AppLocalizations.of(context);

    
  final BannerAd myBanner = BannerAd(
           adUnitId: AdmobConfigTeste.bannerAdUnitId, // producao
          size:
              AdSize(width: MediaQuery.of(context).size.width.toInt(), height: 60),
          request: const AdRequest(),
          listener: const BannerAdListener(),
        );

     myBanner.load();

    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(color: Colors.white),
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: const Color(0xFFF0F0F0),
                ),
                padding: const EdgeInsets.fromLTRB(32, 10, 32, 18),
                child: Column(
                  children: [
                    Text("QRCode Magic", style: theme.textTheme.headline3),
                    const SizedBox(height: 8),
                    Text(
                      localization!.appDescription,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyText1?.copyWith(
                          fontWeight: FontWeight.w500, letterSpacing: 0.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.all(30),
                    child: PrettyQr(
                      data:
                          "https://play.google.com/store/apps/details?id=com.example.qrcode_magic",
                      roundEdges: true,
                      size: 165,
                    ),
                  ),
                  Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                              color: theme.primaryColor,
                              offset: const Offset(-2, -2),
                              spreadRadius: 1)
                        ]),
                  ),
                  Positioned(
                    right: 0,
                    child: Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                                color: theme.primaryColor,
                                offset: const Offset(2, -2),
                                spreadRadius: 1)
                          ]),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                                color: theme.primaryColor,
                                offset: const Offset(-2, 2),
                                spreadRadius: 1)
                          ]),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                                color: theme.primaryColor,
                                offset: const Offset(2, 2),
                                spreadRadius: 1)
                          ]),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppButton(
                    onPressed: () => Navigator.of(context).pushNamed('/scanqr'),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          localization.scanNew,
                          style: theme.textTheme.bodyText2
                              ?.copyWith(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  AppButton(
                      onPressed: () =>
                          Navigator.of(context).pushNamed('/newqr'),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.qr_code_2,
                            color: Colors.white,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            localization.generateNew,
                            style: theme.textTheme.bodyText2
                                ?.copyWith(color: Colors.white),
                          )
                        ],
                      ))
                ],
              ),
              const SizedBox(height: 10,),
               Expanded(
                 child: Container(
                    alignment: Alignment.center,
                    width: myBanner.size.width.toDouble(),
                    height: myBanner.size.height.toDouble(),
                    child: AdWidget(
                      ad: myBanner,
                    ),
                  ),
               )
            ],
          ),
        ),
      ),
    );
  }
}
