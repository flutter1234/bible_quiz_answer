import 'package:bible_quiz_answer/AdPlugin/Ads/Banner/BannerWrapper.dart';
import 'package:bible_quiz_answer/AdPlugin/Ads/FullScreen/Ads.dart';
import 'package:bible_quiz_answer/AdPlugin/MainJson/MainJson.dart';
import 'package:bible_quiz_answer/Provider/api_provider.dart';
import 'package:bible_quiz_answer/Screen/Category_screen/category_screen.dart';
import 'package:bible_quiz_answer/Screen/History_screen/history_screen.dart';
import 'package:bible_quiz_answer/Screen/Setting_screen/setting_screen.dart';
import 'package:bible_quiz_answer/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class home_screen extends StatefulWidget {
  static const routeName = '/home_screen';

  const home_screen({super.key});

  @override
  State<home_screen> createState() => _home_screenState();
}

class _home_screenState extends State<home_screen> {
  bool isLoading = true;

  @override
  void initState() {
    context.read<Api>().quizAnswerData(context.read<MainJson>().data!['assets']['bibleQuizAnswer']).then((value) {
      isLoading = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Api dataProvider = Provider.of<Api>(context, listen: true);
    return BannerWrapper(
      parentContext: context,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: isIpad ? 30.sp : 35.sp,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          leading: GestureDetector(
            onTap: () {
              AdsRN().showFullScreen(
                context: context,
                onComplete: () {
                  Navigator.pushNamed(context, setting_screen.routeName);
                },
              );
              setState(() {});
            },
            child: Padding(
              padding: EdgeInsets.only(left: isIpad ? 10.w : 0),
              child: Icon(
                Icons.settings,
                size: isIpad ? 25.sp : 30.sp,
                color: Colors.white,
              ),
            ),
          ),
          title: Text(
            'Bible Quiz',
            style: GoogleFonts.rubik(
              fontSize: isIpad
                  ? 24.sp
                  : isSmall
                      ? 26.sp
                      : 30.sp,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                AdsRN().showFullScreen(
                  context: context,
                  onComplete: () {
                    Navigator.pushNamed(context, history_screen.routeName);
                  },
                );
                setState(() {});
              },
              child: Padding(
                padding: EdgeInsets.only(right: 10.w),
                child: Icon(
                  Icons.history_outlined,
                  size: isIpad ? 25.sp : 30.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        body: isLoading
            ? Center(
                child: CupertinoActivityIndicator(
                  color: Colors.white,
                  radius: 10.r,
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(flex: 1),
                  Center(
                    child: Image(
                      fit: BoxFit.cover,
                      height: 150.sp,
                      width: 200.w,
                      image: AssetImage('assets/images/quiz_logo.png'),
                    ),
                  ),
                  Spacer(flex: 4),
                  Padding(
                    padding: EdgeInsets.all(5.sp),
                    child: GestureDetector(
                      onTap: () {
                        AdsRN().showFullScreen(
                          context: context,
                          onComplete: () {
                            Navigator.pushNamed(
                              context,
                              category_screen.routeName,
                              arguments: {
                                "data": dataProvider.quizListData[0]['Old Testament'],
                                "Testament": "Old Testament",
                              },
                            );
                          },
                        );
                        setState(() {});
                      },
                      child: Container(
                        height: 50.sp,
                        width: 200.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color: HexColor('006292'),
                          border: Border.all(width: 2.w, color: Colors.white),
                        ),
                        child: Center(
                          child: Text(
                            'Old Testament',
                            style: GoogleFonts.rubik(
                              fontSize: isIpad
                                  ? 20.sp
                                  : isSmall
                                      ? 20.sp
                                      : 24.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5.sp),
                    child: GestureDetector(
                      onTap: () {
                        AdsRN().showFullScreen(
                          context: context,
                          onComplete: () {
                            Navigator.pushNamed(
                              context,
                              category_screen.routeName,
                              arguments: {
                                "data": dataProvider.quizListData[1]['New Testament'],
                                "Testament": "New Testament",
                              },
                            );
                          },
                        );
                        setState(() {});
                      },
                      child: Container(
                        height: 50.sp,
                        width: 200.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color: HexColor('006292'),
                          border: Border.all(width: 2.w, color: Colors.white),
                        ),
                        child: Center(
                          child: Text(
                            'New Testament',
                            style: GoogleFonts.rubik(
                              fontSize: isIpad
                                  ? 20.sp
                                  : isSmall
                                      ? 20.sp
                                      : 24.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Spacer(flex: 2),
                ],
              ),
      ),
    );
  }
}
