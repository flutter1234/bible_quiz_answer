// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:applovin_max/applovin_max.dart';
import 'package:ironsource_adpluginx/ironsource_adpluginx.dart';
import 'package:provider/provider.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';
import 'package:user_messaging_platform/user_messaging_platform.dart';

// 🌎 Project imports:
import '../AdsWidget/IronSource/InitListner.dart';
import '../MainJson/MainJson.dart';
import 'GoogleInit.dart';

class BaseClass {
  Future<void> initAdNetworks(
      {required BuildContext context,
      required Function() onInitComplete}) async {
    MainJson mainJson = context.read<MainJson>();

    await GoogleInit().onInit();
    await AppLovinMAX.initialize(
      mainJson.data!['adIds']['applovin']['id'] != ""
          ? mainJson.data!['adIds']['applovin']['id']
          : "xiAs_Fs3BiExPelVuawzyDTU2Sy4GL2d6KB1c7C1loiv64T5oquTwRRIJbHC3qO0qRI_65NChIkGy3U2i6rWXn",
    );
    print(mainJson.data!['adIds']['ironSource']['appId']);
    print("Is Ids===============>");
    try {
      await IronSource.init(
        appKey: mainJson.data!['adIds']['ironSource']['appId'],
        adUnits: [
          IronSourceAdUnit.Interstitial,
          IronSourceAdUnit.Banner,
          IronSourceAdUnit.RewardedVideo,
        ],
        initListener: InitListner(),
      );
    } catch (e) {
      print("Errorrrr ===========>");
      print(e);
    }
    await UnityAds.init(
      testMode: true,
      gameId: mainJson.data!['adIds']['unity']['gameId'],
      onComplete: () {
        print("unitu init");
      },
      onFailed: (error, message) {},
    );
    print("unity init ${UnityAds.isInitialized()}");

    // Future.delayed(const Duration(milliseconds: 400), () {
      onInitComplete();
    // });
  }

  Future<void> showUserMessage() async {
    var info = await UserMessagingPlatform.instance.requestConsentInfoUpdate();
    if (info.consentStatus == ConsentStatus.required) {
      await UserMessagingPlatform.instance.showConsentForm();
      await AppTrackingTransparency.requestTrackingAuthorization();
    } else {
      await AppTrackingTransparency.requestTrackingAuthorization();
    }
  }
}
