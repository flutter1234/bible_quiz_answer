// 📦 Package imports:
import 'package:google_mobile_ads/google_mobile_ads.dart';

class GoogleInit {
  onInit() async {
    await MobileAds.instance.initialize();
  }
}
