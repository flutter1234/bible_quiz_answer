import 'package:bible_quiz_answer/AdPlugin/Ads/Banner/BannerWrapper.dart';
import 'package:bible_quiz_answer/AdPlugin/Ads/FullScreen/Ads.dart';
import 'package:bible_quiz_answer/AdPlugin/MainJson/MainJson.dart';
import 'package:bible_quiz_answer/Provider/api_provider.dart';
import 'package:bible_quiz_answer/Screen/Category_screen/category_screen.dart';
import 'package:bible_quiz_answer/Screen/History_screen/history_screen.dart';
import 'package:bible_quiz_answer/main.dart';
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
  bool settingDialog = false;

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
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: isSmall ? 45.h : 50.h),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.sp),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(width: 30.w),
                              Text(
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
                                child: Icon(
                                  Icons.settings,
                                  size: 30.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
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
                        Spacer(),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
