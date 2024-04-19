import 'package:auto_size_text/auto_size_text.dart';
import 'package:bible_quiz_answer/AdPlugin/Ads/Banner/BannerWrapper.dart';
import 'package:bible_quiz_answer/AdPlugin/Ads/FullScreen/Ads.dart';
import 'package:bible_quiz_answer/Provider/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class quiz_screen extends StatefulWidget {
  static const routeName = '/quiz_screen';
  final List oneData;
  final oneCategoryName;

  const quiz_screen({super.key, required this.oneData, required this.oneCategoryName});

  @override
  State<quiz_screen> createState() => _quiz_screenState();
}

class _quiz_screenState extends State<quiz_screen> {
  bool nextButton = false;
  bool colorChange = false;
  bool answerTap = false;
  String selectAnswer = "";
  String trueAnswer = "";

  @override
  Widget build(BuildContext context) {
    Api dataProvider = Provider.of<Api>(context, listen: true);
    return BannerWrapper(
      parentContext: context,
      child: Scaffold(
        extendBody: true,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
              setState(() {});
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 20.sp,
            ),
          ),
          title: Text(
            '${widget.oneCategoryName}',
            style: GoogleFonts.rubik(
              fontSize: 25.sp,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 15.sp),
              child: Material(
                color: HexColor('006292'),
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.circular(35.r),
                  side: BorderSide(width: 1.w, color: Colors.white),
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 25.sp),
                    child: Text(
                      textAlign: TextAlign.center,
                      '${widget.oneData[dataProvider.questionIndex]['Question']}',
                      style: GoogleFonts.rubik(
                        fontSize: 17.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ).animate().scaleXY(curve: Curves.bounceOut, duration: Duration(seconds: 2)),
            ),
            GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 20.sp),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 50.sp,
                mainAxisSpacing: 10.sp,
                crossAxisSpacing: 10.sp,
              ),
              itemCount: 4,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Bounce(
                  duration: Duration(milliseconds: 200),
                  onPressed: () {
                    if (!answerTap) {
                      selectAnswer = widget.oneData[dataProvider.questionIndex]['answers'][index];
                      colorChange = true;
                      answerTap = true;
                      nextButton = true;
                    }
                    setState(() {});
                  },
                  child: Material(
                    color: colorChange == true
                        ? index + 1 == widget.oneData[dataProvider.questionIndex]['answer']
                            ? Colors.green.shade700
                            : selectAnswer == widget.oneData[dataProvider.questionIndex]['answers'][index]
                                ? Colors.red.shade700
                                : HexColor('006292')
                        : HexColor('006292'),
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(18.r),
                      side: BorderSide(width: 1.w, color: Colors.white),
                    ),
                    child: Center(
                      child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.sp),
                          child: AutoSizeText(
                            textAlign: TextAlign.center,
                            '${widget.oneData[dataProvider.questionIndex]['answers'][index]}',
                            style: GoogleFonts.rubik(
                              fontSize: 18.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                            minFontSize: 12,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          )),
                    ),
                  ).animate().scaleXY(curve: Curves.bounceOut, duration: Duration(seconds: 2)),
                );
              },
            ),
            SizedBox(height: 10.h),
            nextButton == true
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.sp),
                    child: Material(
                      color: HexColor('006292'),
                      shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                        side: BorderSide(width: 1.w, color: Colors.white),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 12.sp),
                        child: Column(
                          children: [
                            Text(
                              textAlign: TextAlign.center,
                              'Note :',
                              style: GoogleFonts.rubik(
                                fontSize: 20.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 5.h),
                            Text(
                              textAlign: TextAlign.justify,
                              maxLines: 6,
                              overflow: TextOverflow.ellipsis,
                              '${widget.oneData[dataProvider.questionIndex]['Note']}',
                              style: GoogleFonts.rubik(
                                fontSize: 16.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : SizedBox(),
            Spacer(),
            nextButton == true
                ? dataProvider.questionIndex == widget.oneData.length - 1
                    ? Bounce(
                        duration: Duration(milliseconds: 300),
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {});
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 100.sp),
                          child: Material(
                            color: HexColor('006292'),
                            shape: BeveledRectangleBorder(
                              borderRadius: BorderRadius.circular(18.r),
                              side: BorderSide(width: 1.w, color: Colors.white),
                            ),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.sp),
                                child: Text(
                                  textAlign: TextAlign.center,
                                  'Back',
                                  style: GoogleFonts.rubik(
                                    fontSize: 25.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Bounce(
                        duration: Duration(milliseconds: 300),
                        onPressed: () {
                          AdsRN().showFullScreen(
                            context: context,
                            onComplete: () {
                              Navigator.pushReplacementNamed(
                                context,
                                quiz_screen.routeName,
                                arguments: {
                                  "oneCategory": widget.oneData,
                                  "oneCategoryName": widget.oneCategoryName,
                                },
                              );
                              if (dataProvider.questionIndex < widget.oneData.length - 1) {
                                dataProvider.questionIndex++;
                              }
                              nextButton = false;
                            },
                          );

                          setState(() {});
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 100.sp),
                          child: Material(
                            color: HexColor('006292'),
                            shape: BeveledRectangleBorder(
                              borderRadius: BorderRadius.circular(18.r),
                              side: BorderSide(width: 1.w, color: Colors.white),
                            ),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.sp),
                                child: Text(
                                  textAlign: TextAlign.center,
                                  'Next',
                                  style: GoogleFonts.rubik(
                                    fontSize: 25.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                : SizedBox(),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
