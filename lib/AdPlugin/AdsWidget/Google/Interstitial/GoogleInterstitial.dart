// 🐦 Flutter imports:
import 'package:flutter/cupertino.dart';

// 📦 Package imports:
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

// 🌎 Project imports:
import '../../../MainJson/MainJson.dart';

class GoogleInterstitial {
  InterstitialAd? interstitialAd;

  loadAd(
      {required BuildContext context,
      required Function() onLoaded,
      required Function() onComplete,
      required Function() onFailed}) {
    MainJson mainJson = context.read<MainJson>();
    InterstitialAd.load(
        adUnitId: '${mainJson.data!['adIds']['google']['fullScreen']}',
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
                onAdShowedFullScreenContent: (ad) {},
                onAdImpression: (ad) {},
                onAdFailedToShowFullScreenContent: (ad, err) {
                  onFailed();
                  ad.dispose();
                },
                onAdDismissedFullScreenContent: (ad) {
                  onComplete();

                  ad.dispose();
                },
                onAdClicked: (ad) {});

            interstitialAd = ad;
            onLoaded();
            interstitialAd!.show();
          },
          onAdFailedToLoad: (LoadAdError error) {
            onFailed();
          },
        ));
  }
}
