// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

// 🌎 Project imports:
import '../../../MainJson/MainJson.dart';

class GoogleNative extends HookWidget {
  const GoogleNative({super.key});

  @override
  Widget build(BuildContext context) {
    final nativeAd = useState<NativeAd?>(null);
    final nativeAdIsLoaded = useState<bool>(false);
    final nativeWidget = useState<AdWidget?>(null);

    MainJson mainJson = context.read<MainJson>();

    loadAd() {
      nativeAd.value = NativeAd(
        adUnitId: '${mainJson.data!['adIds']['google']['native']}',
        factoryId: 'adFactoryExample',
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            nativeAdIsLoaded.value = true;
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
          },
          onAdClicked: (ad) {},
          onAdImpression: (ad) {},
          onAdClosed: (ad) {},
          onAdOpened: (ad) {},
          onAdWillDismissScreen: (ad) {},
          onPaidEvent: (ad, valueMicros, precision, currencyCode) {},
        ),
        request: const AdRequest(),
      );
      nativeAd.value!.load();
      nativeWidget.value = AdWidget(ad: nativeAd.value!);
    }

    useEffect(() {
      loadAd();
      return () {};
    }, []);
    return nativeAdIsLoaded.value
        ? Container(
            margin: const EdgeInsets.all(10.0),
            constraints: const BoxConstraints(minHeight: 270, maxHeight: 320),
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            alignment: Alignment.center,
            width: double.infinity,
            child: nativeWidget.value,
          )
        : const SizedBox.shrink();
  }
}
