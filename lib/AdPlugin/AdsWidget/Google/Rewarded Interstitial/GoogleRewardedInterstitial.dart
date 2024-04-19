// 🐦 Flutter imports:
import 'package:flutter/cupertino.dart';

// 📦 Package imports:
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

// 🌎 Project imports:
import '../../../MainJson/MainJson.dart';

class GoogleRewardedInterstitial {
  RewardedInterstitialAd? _rewardeInterstitialdAd;

  void loadAd(
      {required BuildContext context,
      required Function() onLoaded,
      required Function() onComplete,
      required Function() onFailed}) {
    MainJson mainJson = context.read<MainJson>();
    RewardedInterstitialAd.load(
        adUnitId: '${mainJson.data!['adIds']['google']['rewardInter']}',
        request: const AdRequest(),
        rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            _rewardeInterstitialdAd = ad;
            _rewardeInterstitialdAd!.fullScreenContentCallback =
                FullScreenContentCallback(
                    onAdShowedFullScreenContent: (ad) {},
                    onAdImpression: (ad) {},
                    onAdFailedToShowFullScreenContent: (ad, err) {
                      onFailed();
                      ad.dispose();
                    },
                    onAdDismissedFullScreenContent: (ad) {
                      if (mainJson.data![mainJson.version]['globalConfig']
                          ['rewardOverRide']) {
                        onComplete();
                      }
                      ad.dispose();
                    },
                    onAdClicked: (ad) {});
            onLoaded();
            _rewardeInterstitialdAd!.show(
                onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
              onComplete();
              ad.dispose();
            });
          },
          onAdFailedToLoad: (LoadAdError error) {
            onFailed();
          },
        ));
  }
}
