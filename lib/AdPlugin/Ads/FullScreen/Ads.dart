// 🎯 Dart imports:
import 'dart:async';

// 🐦 Flutter imports:
import 'package:flutter/cupertino.dart';

// 📦 Package imports:
import 'package:ironsource_adpluginx/ironsource_adpluginx.dart';
import 'package:provider/provider.dart';

// 🌎 Project imports:
import '../../AdLoader/AdLoaderProvider.dart';
import '../../AdsWidget/AppLovin/Interstitial/AppLovinInterstitial.dart';
import '../../AdsWidget/Google/Interstitial/GoogleInterstitial.dart';
import '../../AdsWidget/Google/Rewarded Interstitial/GoogleRewardedInterstitial.dart';
import '../../AdsWidget/Google/Rewarded/GoogleRewarded.dart';
import '../../AdsWidget/IronSource/Interstitial/IronSourceInterstitial.dart';
import '../../AdsWidget/Unity/UnityInterstitial.dart';
import '../../MainJson/MainJson.dart';

class AdsRN {
  static final AdsRN _singleton = AdsRN._internal();

  factory AdsRN() {
    return _singleton;
  }

  AdsRN._internal();

  Map routeIndex = {};
  int currentAdIndex = 0;
  int failCounter = 0;

  indexIncrement(String? route, int arrayLength) {
    if (route != null) {
      if (routeIndex[route] == null) {
        if ((arrayLength + 1) == 1) {
          routeIndex[route] = 0;
        } else {
          routeIndex[route] = 1;
        }
      } else {
        if (routeIndex[route] != arrayLength &&
            routeIndex[route] < arrayLength) {
          routeIndex[route]++;
        } else {
          routeIndex[route] = 0;
        }
      }
    } else {
      if (currentAdIndex < arrayLength && currentAdIndex != arrayLength) {
        currentAdIndex++;
      } else {
        currentAdIndex = 0;
      }
    }
  }

  bool loopBreaker(int retry) {
    if (failCounter < retry) {
      failCounter++;
      return false;
    }
    failCounter = 0;
    return true;
  }

  showFullScreen(
      {required BuildContext context, required Function() onComplete}) async {
    MainJson mainJson = context.read<MainJson>();
    AdLoaderProvider loaderProvider = context.read<AdLoaderProvider>();
    loaderProvider.isAdLoading = true;
    String? route = ModalRoute.of(context)?.settings.name;
    int index = route != null ? (routeIndex[route] ?? 0) : currentAdIndex;

    Timer timer = Timer.periodic(
        Duration(
            seconds: mainJson.data![mainJson.version]['globalConfig']
                ['overrideTimer']), (timer) {
      loaderProvider.isAdLoading = false;
      onComplete();
      timer.cancel();
      return;
    });

    if ((mainJson.data![mainJson.version]['globalConfig']['globalAdFlag'] ??
            false) ==
        false) {
      loaderProvider.isAdLoading = false;
      timer.cancel();

      onComplete();
      return;
    }
    if ((mainJson.data![mainJson.version]['screens']
                [ModalRoute.of(context)?.settings.name]['localAdFlag'] ??
            false) ==
        false) {
      loaderProvider.isAdLoading = false;
      timer.cancel();

      onComplete();
      return;
    }
    switch (mainJson.data![mainJson.version]['screens']
        [ModalRoute.of(context)?.settings.name]['localClick'][index]) {
      case 0:
        GoogleInterstitial().loadAd(
          context: context,
          onLoaded: () {
            timer.cancel();
          },
          onComplete: () {
            indexIncrement(
                route,
                mainJson.data![mainJson.version]['screens'][route]['localClick']
                        .length -
                    1);
            loaderProvider.isAdLoading = false;
            onComplete();
            timer.cancel();
          },
          onFailed: () {
            failedFullScreen(
              from: 0,
              context: context,
              onComplete: () {
                loaderProvider.isAdLoading = false;

                onComplete();
                timer.cancel();
              },
            );
          },
        );
        break;
      case 1:
        AppLovinInterstitial().loadAd(
          onLoaded: () {
            timer.cancel();
          },
          context: context,
          onComplete: () {
            indexIncrement(
                route,
                mainJson.data![mainJson.version]['screens'][route]['localClick']
                        .length -
                    1);
            loaderProvider.isAdLoading = false;
            timer.cancel();

            onComplete();
          },
          onFailed: () {
            failedFullScreen(
              from: 1,
              context: context,
              onComplete: () {
                loaderProvider.isAdLoading = false;
                timer.cancel();

                onComplete();
              },
            );
          },
        );
        break;
      case 2:
        print("Is Turn Logic 2 =====================>");
        IronSourceFullScreenX ironSourceFullScreenX =
            IronSourceFullScreenX.onInit(
          onLoaded: () {
            timer.cancel();
            IronSource.showInterstitial();
          },
          onComplete: () {
            indexIncrement(
                route,
                mainJson.data![mainJson.version]['screens'][route]['localClick']
                        .length -
                    1);
            loaderProvider.isAdLoading = false;
            timer.cancel();

            onComplete();
          },
          onFailed: () {
            print("iron failed");
            failedFullScreen(
              from: 2,
              context: context,
              onComplete: () {
                loaderProvider.isAdLoading = false;
                timer.cancel();
                onComplete();
              },
            );
          },
        );
        IronSource.setLevelPlayInterstitialListener(ironSourceFullScreenX);
        IronSource.loadInterstitial();
        // IronSource.loadInterstitial();
        break;
      case 3:
        UnityInterstitial().loadAd(
            onLoaded: () {
              timer.cancel();
            },
            context: context,
            onComplete: () {
              indexIncrement(
                  route,
                  mainJson
                          .data![mainJson.version]['screens'][route]
                              ['localClick']
                          .length -
                      1);
              loaderProvider.isAdLoading = false;
              timer.cancel();

              onComplete();
            },
            onFailed: () {
              failedFullScreen(
                from: 3,
                context: context,
                onComplete: () {
                  loaderProvider.isAdLoading = false;
                  timer.cancel();

                  onComplete();
                },
              );
            });
        break;
      case 4:
        GoogleRewarded().loadAd(
            context: context,
            onLoaded: () {
              timer.cancel();
            },
            onComplete: () {
              indexIncrement(
                  route,
                  mainJson
                          .data![mainJson.version]['screens'][route]
                              ['localClick']
                          .length -
                      1);
              loaderProvider.isAdLoading = false;
              timer.cancel();

              onComplete();
            },
            onFailed: () {
              failedFullScreen(
                from: 4,
                context: context,
                onComplete: () {
                  loaderProvider.isAdLoading = false;
                  timer.cancel();

                  onComplete();
                },
              );
            });
        break;
      case 5:
        GoogleRewardedInterstitial().loadAd(
            context: context,
            onLoaded: () {
              timer.cancel();
            },
            onComplete: () {
              indexIncrement(
                  route,
                  mainJson
                          .data![mainJson.version]['screens'][route]
                              ['localClick']
                          .length -
                      1);
              loaderProvider.isAdLoading = false;
              timer.cancel();

              onComplete();
            },
            onFailed: () {
              failedFullScreen(
                from: 5,
                context: context,
                onComplete: () {
                  loaderProvider.isAdLoading = false;
                  timer.cancel();

                  onComplete();
                },
              );
            });
        break;
      default:
        indexIncrement(
            route,
            mainJson.data![mainJson.version]['screens'][route]['localClick']
                    .length -
                1);
        loaderProvider.isAdLoading = false;
        timer.cancel();

        onComplete();
        break;
    }
  }

  showActionBasedAds(
      {required BuildContext context,
      required String actionName,
      required Function() onComplete}) {
    print("splash");
    MainJson mainJson = context.read<MainJson>();
    AdLoaderProvider loaderProvider = context.read<AdLoaderProvider>();
    loaderProvider.isAdLoading = true;
    int index =
        actionName != null ? (routeIndex[actionName] ?? 0) : currentAdIndex;
    if ((mainJson.data![mainJson.version]['globalConfig']['globalAdFlag'] ??
            false) ==
        false) {
      loaderProvider.isAdLoading = false;

      onComplete();
      return;
    }
    print("splash1");

    if ((mainJson.data![mainJson.version]['actions'][actionName]
                ['localAdFlag'] ??
            false) ==
        false) {
      loaderProvider.isAdLoading = false;

      onComplete();
      return;
    }
    print("splash2");

    Timer timer = Timer.periodic(
        Duration(
            seconds: mainJson.data![mainJson.version]['globalConfig']
                ['overrideTimer']), (timer) {
      loaderProvider.isAdLoading = false;
      onComplete();
      timer.cancel();
      return;
    });

    switch (mainJson.data![mainJson.version]['actions'][actionName]
        ['localClick'][index]) {
      case 0:
        GoogleInterstitial().loadAd(
          context: context,
          onLoaded: () {
            timer.cancel();
          },
          onComplete: () {
            indexIncrement(
                actionName,
                mainJson
                        .data![mainJson.version]['actions'][actionName]
                            ['localClick']
                        .length -
                    1);
            loaderProvider.isAdLoading = false;
            timer.cancel();
            onComplete();
          },
          onFailed: () {
            print("google failed");
            failedActionBasedAds(
              actionName: actionName,
              from: 0,
              context: context,
              onComplete: () {
                loaderProvider.isAdLoading = false;
                timer.cancel();
                onComplete();
              },
            );
          },
        );
        break;
      case 1:
        AppLovinInterstitial().loadAd(
          context: context,
          onLoaded: () {
            timer.cancel();
          },
          onComplete: () {
            indexIncrement(
                actionName,
                mainJson
                        .data![mainJson.version]['actions'][actionName]
                            ['localClick']
                        .length -
                    1);
            loaderProvider.isAdLoading = false;
            timer.cancel();
            onComplete();
          },
          onFailed: () {
            print("applovin failed");

            failedActionBasedAds(
              actionName: actionName,
              from: 1,
              context: context,
              onComplete: () {
                loaderProvider.isAdLoading = false;
                timer.cancel();
                onComplete();
              },
            );
          },
        );
        break;
      case 2:
        print("Show ============================>");
        IronSourceFullScreenX ironSourceFullScreenX =
            IronSourceFullScreenX.onInit(
          onLoaded: () {
            timer.cancel();
            IronSource.showInterstitial();
          },
          onComplete: () {
            indexIncrement(
                actionName,
                mainJson
                        .data![mainJson.version]['actions'][actionName]
                            ['localClick']
                        .length -
                    1);
            loaderProvider.isAdLoading = false;
            timer.cancel();
            onComplete();
          },
          onFailed: () {
            print("ironsource failed11");
            failedActionBasedAds(
              actionName: actionName,
              from: 2,
              context: context,
              onComplete: () {
                loaderProvider.isAdLoading = false;
                timer.cancel();
                onComplete();
              },
            );
          },
        );

        IronSource.setLevelPlayInterstitialListener(ironSourceFullScreenX);
        IronSource.loadInterstitial();
        break;
      case 3:
        UnityInterstitial().loadAd(
            context: context,
            onLoaded: () {
              timer.cancel();
            },
            onComplete: () {
              indexIncrement(
                  actionName,
                  mainJson
                          .data![mainJson.version]['actions'][actionName]
                              ['localClick']
                          .length -
                      1);
              loaderProvider.isAdLoading = false;
              timer.cancel();
              onComplete();
            },
            onFailed: () {
              print("unity failed");
              failedActionBasedAds(
                actionName: actionName,
                from: 3,
                context: context,
                onComplete: () {
                  loaderProvider.isAdLoading = false;
                  timer.cancel();
                  onComplete();
                },
              );
            });
        break;
      case 4:
        GoogleRewarded().loadAd(
            context: context,
            onLoaded: () {
              timer.cancel();
            },
            onComplete: () {
              indexIncrement(
                  actionName,
                  mainJson
                          .data![mainJson.version]['actions'][actionName]
                              ['localClick']
                          .length -
                      1);
              loaderProvider.isAdLoading = false;
              timer.cancel();
              onComplete();
            },
            onFailed: () {
              print("google reward failed");
              failedActionBasedAds(
                actionName: actionName,
                from: 4,
                context: context,
                onComplete: () {
                  loaderProvider.isAdLoading = false;
                  timer.cancel();
                  onComplete();
                },
              );
            });
        break;
      case 5:
        GoogleRewardedInterstitial().loadAd(
            context: context,
            onLoaded: () {
              timer.cancel();
            },
            onComplete: () {
              indexIncrement(
                  actionName,
                  mainJson
                          .data![mainJson.version]['actions'][actionName]
                              ['localClick']
                          .length -
                      1);
              loaderProvider.isAdLoading = false;
              timer.cancel();
              onComplete();
            },
            onFailed: () {
              print("google reward inter failed");
              failedActionBasedAds(
                actionName: actionName,
                from: 5,
                context: context,
                onComplete: () {
                  loaderProvider.isAdLoading = false;
                  timer.cancel();
                  onComplete();
                },
              );
            });
        break;

      default:
        indexIncrement(
            actionName,
            mainJson
                    .data![mainJson.version]['actions'][actionName]
                        ['localClick']
                    .length -
                1);
        loaderProvider.isAdLoading = false;
        timer.cancel();
        onComplete();
        break;
    }
  }

  showScreenActionBasedAds(
      {required BuildContext context,
      required String actionName,
      required Function() onComplete}) {
    print("splash");
    MainJson mainJson = context.read<MainJson>();
    String? route = ModalRoute.of(context)?.settings.name;
    AdLoaderProvider loaderProvider = context.read<AdLoaderProvider>();
    loaderProvider.isAdLoading = true;
    int index = actionName != null
        ? (routeIndex['$route/$actionName'] ?? 0)
        : currentAdIndex;
    if ((mainJson.data![mainJson.version]['globalConfig']['globalAdFlag'] ??
            false) ==
        false) {
      loaderProvider.isAdLoading = false;

      onComplete();
      return;
    }

    if ((mainJson.data![mainJson.version]['screens'][route]['localAdFlag'] ??
            false) ==
        false) {
      loaderProvider.isAdLoading = false;

      onComplete();
      return;
    }
    if ((mainJson.data![mainJson.version]['screens'][route]['actions']
                [actionName]['localAdFlag'] ??
            false) ==
        false) {
      loaderProvider.isAdLoading = false;

      onComplete();
      return;
    }
    print("splash2");

    Timer timer = Timer.periodic(
        Duration(
            seconds: mainJson.data![mainJson.version]['globalConfig']
                ['overrideTimer']), (timer) {
      loaderProvider.isAdLoading = false;
      onComplete();
      timer.cancel();
      return;
    });

    switch (mainJson.data![mainJson.version]['screens'][route]['actions']
        [actionName]['localClick'][index]) {
      case 0:
        GoogleInterstitial().loadAd(
          context: context,
          onLoaded: () {
            timer.cancel();
          },
          onComplete: () {
            indexIncrement(
                '$route/$actionName',
                mainJson
                        .data![mainJson.version]['screens'][route]['actions']
                            [actionName]['localClick']
                        .length -
                    1);
            loaderProvider.isAdLoading = false;
            timer.cancel();
            onComplete();
          },
          onFailed: () {
            print("google failed");
            failedScreenActionBasedAds(
              actionName: actionName,
              from: 0,
              context: context,
              onComplete: () {
                loaderProvider.isAdLoading = false;
                timer.cancel();
                onComplete();
              },
            );
          },
        );
        break;
      case 1:
        AppLovinInterstitial().loadAd(
          context: context,
          onLoaded: () {
            timer.cancel();
          },
          onComplete: () {
            indexIncrement(
                '$route/$actionName',
                mainJson
                        .data![mainJson.version]['screens'][route]['actions']
                            [actionName]['localClick']
                        .length -
                    1);
            loaderProvider.isAdLoading = false;
            timer.cancel();
            onComplete();
          },
          onFailed: () {
            print("applovin failed");

            failedScreenActionBasedAds(
              actionName: actionName,
              from: 1,
              context: context,
              onComplete: () {
                loaderProvider.isAdLoading = false;
                timer.cancel();
                onComplete();
              },
            );
          },
        );
        break;
      case 2:
        print("Show ============================>");
        IronSourceFullScreenX ironSourceFullScreenX =
            IronSourceFullScreenX.onInit(
          onLoaded: () {
            timer.cancel();
            IronSource.showInterstitial();
          },
          onComplete: () {
            indexIncrement(
                '$route/$actionName',
                mainJson
                        .data![mainJson.version]['screens'][route]['actions']
                            [actionName]['localClick']
                        .length -
                    1);
            loaderProvider.isAdLoading = false;
            timer.cancel();
            onComplete();
          },
          onFailed: () {
            print("ironsource failed11");
            failedScreenActionBasedAds(
              actionName: actionName,
              from: 2,
              context: context,
              onComplete: () {
                loaderProvider.isAdLoading = false;
                timer.cancel();
                onComplete();
              },
            );
          },
        );

        IronSource.setLevelPlayInterstitialListener(ironSourceFullScreenX);
        IronSource.loadInterstitial();
        break;
      case 3:
        UnityInterstitial().loadAd(
            context: context,
            onLoaded: () {
              timer.cancel();
            },
            onComplete: () {
              indexIncrement(
                  '$route/$actionName',
                  mainJson
                          .data![mainJson.version]['screens'][route]['actions']
                              [actionName]['localClick']
                          .length -
                      1);
              loaderProvider.isAdLoading = false;
              timer.cancel();
              onComplete();
            },
            onFailed: () {
              print("unity failed");
              failedScreenActionBasedAds(
                actionName: actionName,
                from: 3,
                context: context,
                onComplete: () {
                  loaderProvider.isAdLoading = false;
                  timer.cancel();
                  onComplete();
                },
              );
            });
        break;
      case 4:
        GoogleRewarded().loadAd(
            context: context,
            onLoaded: () {
              timer.cancel();
            },
            onComplete: () {
              indexIncrement(
                  '$route/$actionName',
                  mainJson
                          .data![mainJson.version]['screens'][route]['actions']
                              [actionName]['localClick']
                          .length -
                      1);
              loaderProvider.isAdLoading = false;
              timer.cancel();
              onComplete();
            },
            onFailed: () {
              print("google reward failed");
              failedScreenActionBasedAds(
                actionName: actionName,
                from: 4,
                context: context,
                onComplete: () {
                  loaderProvider.isAdLoading = false;
                  timer.cancel();
                  onComplete();
                },
              );
            });
        break;
      case 5:
        GoogleRewardedInterstitial().loadAd(
            context: context,
            onLoaded: () {
              timer.cancel();
            },
            onComplete: () {
              indexIncrement(
                  '$route/$actionName',
                  mainJson
                          .data![mainJson.version]['screens'][route]['actions']
                              [actionName]['localClick']
                          .length -
                      1);
              loaderProvider.isAdLoading = false;
              timer.cancel();
              onComplete();
            },
            onFailed: () {
              print("google reward inter failed");
              failedScreenActionBasedAds(
                actionName: actionName,
                from: 5,
                context: context,
                onComplete: () {
                  loaderProvider.isAdLoading = false;
                  timer.cancel();
                  onComplete();
                },
              );
            });
        break;

      default:
        indexIncrement(
            '$route/$actionName',
            mainJson
                    .data![mainJson.version]['screens'][route]['actions']
                        [actionName]['localClick']
                    .length -
                1);
        loaderProvider.isAdLoading = false;
        timer.cancel();
        onComplete();
        break;
    }
  }

  failedFullScreen(
      {required int from,
      required BuildContext context,
      required Function() onComplete}) {
    MainJson mainJson = context.read<MainJson>();
    String? route = ModalRoute.of(context)?.settings.name;
    Map? failedMapArray = mainJson.data![mainJson.version]['screens']
        [ModalRoute.of(context)?.settings.name]['localFail'];
    int caseIndex = failedMapArray![from.toString()] ?? 0;
    print("point1");
    if (failedMapArray[from.toString()] == null) {
      print("null in map");
      print(failedMapArray[from].toString());
      onComplete();
      return;
    }

    if (loopBreaker(
        mainJson.data![mainJson.version]['globalConfig']['maxFailed'])) {
      onComplete();
    } else {
      Timer timer = Timer.periodic(
          Duration(
              seconds: mainJson.data![mainJson.version]['globalConfig']
                  ['overrideTimer']), (timer) {
        onComplete();
        timer.cancel();
        return;
      });
      print("point2");
      switch (caseIndex) {
        case 0:
          GoogleInterstitial().loadAd(
            context: context,
            onLoaded: () {
              timer.cancel();
            },
            onComplete: () {
              indexIncrement(
                  route,
                  mainJson
                          .data![mainJson.version]['screens'][route]
                              ['localClick']
                          .length -
                      1);
              timer.cancel();
              onComplete();
            },
            onFailed: () {
              failedFullScreen(
                from: 0,
                context: context,
                onComplete: () {
                  timer.cancel();
                  onComplete();
                },
              );
            },
          );
          break;
        case 1:
          AppLovinInterstitial().loadAd(
            context: context,
            onLoaded: () {
              timer.cancel();
            },
            onComplete: () {
              indexIncrement(
                  route,
                  mainJson
                          .data![mainJson.version]['screens'][route]
                              ['localClick']
                          .length -
                      1);
              timer.cancel();
              onComplete();
            },
            onFailed: () {
              failedFullScreen(
                from: 1,
                context: context,
                onComplete: () {
                  timer.cancel();
                  onComplete();
                },
              );
            },
          );
          break;
        case 2:
          IronSourceFullScreenX ironSourceFullScreenX =
              IronSourceFullScreenX.onInit(
            onLoaded: () {
              timer.cancel();
              IronSource.showInterstitial();
            },
            onComplete: () {
              indexIncrement(
                  route,
                  mainJson
                          .data![mainJson.version]['screens'][route]
                              ['localClick']
                          .length -
                      1);
              timer.cancel();

              onComplete();
            },
            onFailed: () {
              print("iron failed");
              failedFullScreen(
                from: 2,
                context: context,
                onComplete: () {
                  timer.cancel();
                  onComplete();
                },
              );
            },
          );
          IronSource.setLevelPlayInterstitialListener(ironSourceFullScreenX);
          IronSource.loadInterstitial();
          break;
        case 3:
          print("case unity");
          UnityInterstitial().loadAd(
              onLoaded: () {
                timer.cancel();
              },
              context: context,
              onComplete: () {
                indexIncrement(
                    route,
                    mainJson
                            .data![mainJson.version]['screens'][route]
                                ['localClick']
                            .length -
                        1);
                timer.cancel();
                onComplete();
              },
              onFailed: () {
                print("unity failed");

                failedFullScreen(
                  from: 3,
                  context: context,
                  onComplete: () {
                    timer.cancel();
                    onComplete();
                  },
                );
              });
          break;
        case 4:
          GoogleRewarded().loadAd(
              context: context,
              onLoaded: () {
                timer.cancel();
              },
              onComplete: () {
                indexIncrement(
                    route,
                    mainJson
                            .data![mainJson.version]['screens'][route]
                                ['localClick']
                            .length -
                        1);
                timer.cancel();
                onComplete();
              },
              onFailed: () {
                failedFullScreen(
                  from: 4,
                  context: context,
                  onComplete: () {
                    timer.cancel();
                    onComplete();
                  },
                );
              });
          break;
        case 5:
          GoogleRewardedInterstitial().loadAd(
              context: context,
              onLoaded: () {
                timer.cancel();
              },
              onComplete: () {
                indexIncrement(
                    route,
                    mainJson
                            .data![mainJson.version]['screens'][route]
                                ['localClick']
                            .length -
                        1);
                timer.cancel();
                onComplete();
              },
              onFailed: () {
                failedFullScreen(
                  from: 5,
                  context: context,
                  onComplete: () {
                    timer.cancel();
                    onComplete();
                  },
                );
              });
          break;
        default:
          indexIncrement(
              route,
              mainJson.data![mainJson.version]['screens'][route]['localClick']
                      .length -
                  1);
          timer.cancel();
          onComplete();
          break;
      }
    }
  }

  failedActionBasedAds(
      {required int from,
      required String actionName,
      required BuildContext context,
      required Function() onComplete}) {
    MainJson mainJson = context.read<MainJson>();
    Map? failedMapArray =
        mainJson.data![mainJson.version]['actions'][actionName]['localFail'];
    int caseIndex = failedMapArray![from.toString()];

    if (loopBreaker(
        mainJson.data![mainJson.version]['globalConfig']['maxFailed'])) {
      onComplete();
    } else {
      Timer timer = Timer.periodic(
          Duration(
              seconds: mainJson.data![mainJson.version]['globalConfig']
                  ['overrideTimer']), (timer) {
        onComplete();
        timer.cancel();
        return;
      });
      switch (caseIndex) {
        case 0:
          GoogleInterstitial().loadAd(
            context: context,
            onLoaded: () {
              timer.cancel();
            },
            onComplete: () {
              indexIncrement(
                  actionName,
                  mainJson
                          .data![mainJson.version]['actions'][actionName]
                              ['localClick']
                          .length -
                      1);
              timer.cancel();
              onComplete();
            },
            onFailed: () {
              print("google failed");
              failedActionBasedAds(
                actionName: actionName,
                from: 0,
                context: context,
                onComplete: () {
                  timer.cancel();
                  onComplete();
                },
              );
            },
          );
          break;
        case 1:
          AppLovinInterstitial().loadAd(
            context: context,
            onLoaded: () {
              timer.cancel();
            },
            onComplete: () {
              indexIncrement(
                  actionName,
                  mainJson
                          .data![mainJson.version]['actions'][actionName]
                              ['localClick']
                          .length -
                      1);
              timer.cancel();
              onComplete();
            },
            onFailed: () {
              print("applovin failed");

              failedActionBasedAds(
                actionName: actionName,
                from: 1,
                context: context,
                onComplete: () {
                  timer.cancel();
                  onComplete();
                },
              );
            },
          );
          break;
        case 2:
          IronSourceFullScreenX ironSourceFullScreenX =
              IronSourceFullScreenX.onInit(
            onLoaded: () {
              timer.cancel();
              IronSource.showInterstitial();
            },
            onComplete: () {
              indexIncrement(
                  actionName,
                  mainJson
                          .data![mainJson.version]['actions'][actionName]
                              ['localClick']
                          .length -
                      1);
              timer.cancel();
              onComplete();
            },
            onFailed: () {
              print("ironsource failed11");
              failedActionBasedAds(
                actionName: actionName,
                from: 2,
                context: context,
                onComplete: () {
                  timer.cancel();
                  onComplete();
                },
              );
            },
          );

          IronSource.setLevelPlayInterstitialListener(ironSourceFullScreenX);
          IronSource.loadInterstitial();
          break;

        case 3:
          UnityInterstitial().loadAd(
              context: context,
              onLoaded: () {
                timer.cancel();
              },
              onComplete: () {
                indexIncrement(
                    actionName,
                    mainJson
                            .data![mainJson.version]['actions'][actionName]
                                ['localClick']
                            .length -
                        1);
                timer.cancel();
                onComplete();
              },
              onFailed: () {
                print("unity failed");

                failedActionBasedAds(
                  actionName: actionName,
                  from: 3,
                  context: context,
                  onComplete: () {
                    timer.cancel();
                    onComplete();
                  },
                );
              });
          break;
        case 4:
          GoogleRewarded().loadAd(
              context: context,
              onLoaded: () {
                timer.cancel();
              },
              onComplete: () {
                indexIncrement(
                    actionName,
                    mainJson
                            .data![mainJson.version]['actions'][actionName]
                                ['localClick']
                            .length -
                        1);
                timer.cancel();
                onComplete();
              },
              onFailed: () {
                print("google reward failed");

                failedActionBasedAds(
                  actionName: actionName,
                  from: 4,
                  context: context,
                  onComplete: () {
                    timer.cancel();

                    onComplete();
                  },
                );
              });
          break;
        case 5:
          GoogleRewardedInterstitial().loadAd(
              context: context,
              onLoaded: () {
                timer.cancel();
              },
              onComplete: () {
                indexIncrement(
                    actionName,
                    mainJson
                            .data![mainJson.version]['actions'][actionName]
                                ['localClick']
                            .length -
                        1);
                timer.cancel();

                onComplete();
              },
              onFailed: () {
                print("google reward inter failed");

                failedActionBasedAds(
                  actionName: actionName,
                  from: 5,
                  context: context,
                  onComplete: () {
                    timer.cancel();

                    onComplete();
                  },
                );
              });
          break;

        default:
          indexIncrement(
              actionName,
              mainJson
                      .data![mainJson.version]['actions'][actionName]
                          ['localClick']
                      .length -
                  1);
          timer.cancel();

          onComplete();
          break;
      }
    }
  }

  failedScreenActionBasedAds(
      {required int from,
      required String actionName,
      required BuildContext context,
      required Function() onComplete}) {
    MainJson mainJson = context.read<MainJson>();
    String? route = ModalRoute.of(context)?.settings.name;

    Map? failedMapArray = mainJson.data![mainJson.version]['screens'][route]
        ['actions'][actionName]['localFail'];
    int caseIndex = failedMapArray![from.toString()];

    if (loopBreaker(
        mainJson.data![mainJson.version]['globalConfig']['maxFailed'])) {
      onComplete();
    } else {
      Timer timer = Timer.periodic(
          Duration(
              seconds: mainJson.data![mainJson.version]['globalConfig']
                  ['overrideTimer']), (timer) {
        onComplete();
        timer.cancel();
        return;
      });
      switch (caseIndex) {
        case 0:
          GoogleInterstitial().loadAd(
            context: context,
            onLoaded: () {
              timer.cancel();
            },
            onComplete: () {
              indexIncrement(
                  '$route/$actionName',
                  mainJson
                          .data![mainJson.version]['screens'][route]['actions']
                              [actionName]['localClick']
                          .length -
                      1);
              timer.cancel();
              onComplete();
            },
            onFailed: () {
              print("google failed");
              failedActionBasedAds(
                actionName: actionName,
                from: 0,
                context: context,
                onComplete: () {
                  timer.cancel();
                  onComplete();
                },
              );
            },
          );
          break;
        case 1:
          AppLovinInterstitial().loadAd(
            context: context,
            onLoaded: () {
              timer.cancel();
            },
            onComplete: () {
              indexIncrement(
                  '$route/$actionName',
                  mainJson
                          .data![mainJson.version]['screens'][route]['actions']
                              [actionName]['localClick']
                          .length -
                      1);
              timer.cancel();
              onComplete();
            },
            onFailed: () {
              print("applovin failed");

              failedActionBasedAds(
                actionName: actionName,
                from: 1,
                context: context,
                onComplete: () {
                  timer.cancel();
                  onComplete();
                },
              );
            },
          );
          break;
        case 2:
          IronSourceFullScreenX ironSourceFullScreenX =
              IronSourceFullScreenX.onInit(
            onLoaded: () {
              timer.cancel();
              IronSource.showInterstitial();
            },
            onComplete: () {
              indexIncrement(
                  '$route/$actionName',
                  mainJson
                          .data![mainJson.version]['screens'][route]['actions']
                              [actionName]['localClick']
                          .length -
                      1);
              timer.cancel();
              onComplete();
            },
            onFailed: () {
              print("ironsource failed11");
              failedActionBasedAds(
                actionName: actionName,
                from: 2,
                context: context,
                onComplete: () {
                  timer.cancel();
                  onComplete();
                },
              );
            },
          );

          IronSource.setLevelPlayInterstitialListener(ironSourceFullScreenX);
          IronSource.loadInterstitial();
          break;

        case 3:
          UnityInterstitial().loadAd(
              context: context,
              onLoaded: () {
                timer.cancel();
              },
              onComplete: () {
                indexIncrement(
                    '$route/$actionName',
                    mainJson
                            .data![mainJson.version]['screens'][route]
                                ['actions'][actionName]['localClick']
                            .length -
                        1);
                timer.cancel();
                onComplete();
              },
              onFailed: () {
                print("unity failed");

                failedActionBasedAds(
                  actionName: actionName,
                  from: 3,
                  context: context,
                  onComplete: () {
                    timer.cancel();
                    onComplete();
                  },
                );
              });
          break;
        case 4:
          GoogleRewarded().loadAd(
              context: context,
              onLoaded: () {
                timer.cancel();
              },
              onComplete: () {
                indexIncrement(
                    '$route/$actionName',
                    mainJson
                            .data![mainJson.version]['screens'][route]
                                ['actions'][actionName]['localClick']
                            .length -
                        1);
                timer.cancel();
                onComplete();
              },
              onFailed: () {
                print("google reward failed");

                failedActionBasedAds(
                  actionName: actionName,
                  from: 4,
                  context: context,
                  onComplete: () {
                    timer.cancel();

                    onComplete();
                  },
                );
              });
          break;
        case 5:
          GoogleRewardedInterstitial().loadAd(
              context: context,
              onLoaded: () {
                timer.cancel();
              },
              onComplete: () {
                indexIncrement(
                    '$route/$actionName',
                    mainJson
                            .data![mainJson.version]['screens'][route]
                                ['actions'][actionName]['localClick']
                            .length -
                        1);
                timer.cancel();

                onComplete();
              },
              onFailed: () {
                print("google reward inter failed");

                failedActionBasedAds(
                  actionName: actionName,
                  from: 5,
                  context: context,
                  onComplete: () {
                    timer.cancel();

                    onComplete();
                  },
                );
              });
          break;

        default:
          indexIncrement(
              '$route/$actionName',
              mainJson
                      .data![mainJson.version]['screens'][route]['actions']
                          [actionName]['localClick']
                      .length -
                  1);
          timer.cancel();

          onComplete();
          break;
      }
    }
  }
}
