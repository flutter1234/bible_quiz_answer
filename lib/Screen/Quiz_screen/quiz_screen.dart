import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bible_quiz_answer/AdPlugin/Ads/Banner/BannerWrapper.dart';
import 'package:bible_quiz_answer/AdPlugin/Ads/FullScreen/Ads.dart';
import 'package:bible_quiz_answer/Provider/api_provider.dart';
import 'package:bible_quiz_answer/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'dart:math' as math;

class quiz_screen extends StatefulWidget {
  static const routeName = '/quiz_screen';
  final List oneData;
  final oneCategoryName;
  final CategoryName;

  const quiz_screen({super.key, required this.oneData, required this.oneCategoryName, required this.CategoryName});

  @override
  State<quiz_screen> createState() => _quiz_screenState();
}

class _quiz_screenState extends State<quiz_screen> {
  bool nextButton = false;
  bool colorChange = false;
  bool answerTap = false;
  String selectAnswer = "";
  String trueAnswer = "";
  int wrongLife = 5;
  DateTime? lastRecordedTime;
  late Timer timer;
  int start = 30;
  int totalStepCount = 30;
  bool resetDialog = false;
  bool lifeDialog = false;
  late Timer timerHours;
  late int currentTime;
  bool resultDialog = false;

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  timeHandle() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (start == 0) {
        timer.cancel();
        resetDialog = true;
        setState(() {});
      } else {
        setState(() {
          start--;
        });
      }
    });
  }

  @override
  void initState() {
    Api dataProvider = Provider.of<Api>(context, listen: false);
    timeHandle();
    dataProvider.passCategory = storage.read(widget.CategoryName) ?? [];
    dataProvider.wrongAnswersDetailsList = storage.read("wrongAnswersDetailsList") ?? [];
    dataProvider.correctAnswersDetailsList = storage.read("correctAnswersDetailsList") ?? [];
    wrongLife = storage.read(dataProvider.keyList[widget.oneCategoryName]) ?? 5;
    String? lastRecordedTimeString = storage.read('lastRecordedTime');
    lastRecordedTime = lastRecordedTimeString != null ? DateTime.parse(lastRecordedTimeString) : null;
    wrongLifeGenerate();
    currentTime = storage.read('timer- ${dataProvider.keyList[widget.oneCategoryName]}') ?? 3600;
    // print("currentTime ======>>>>${currentTime}");
    startTimer();
    super.initState();
  }

  void startTimer() {
    Api dataProvider = Provider.of<Api>(context, listen: false);
    if (wrongLife == 0) {
      timerHours = Timer.periodic(Duration(seconds: 1), (timer) {
        if (mounted) {
          setState(() {
            if (currentTime > 0) {
              currentTime--;
              storage.write('timer- ${dataProvider.keyList[widget.oneCategoryName]}', currentTime);
            } else {
              timerHours.cancel();
            }
          });
        }
      });
    }
  }

  void wrongLifeGenerate() {
    Api dataProvider = Provider.of<Api>(context, listen: false);
    if (wrongLife < 5) {
      if (lastRecordedTime == null) {
        lastRecordedTime = DateTime.now();
        storage.write('lastRecordedTime', lastRecordedTime!.toIso8601String());
        // print("lastRecordedTime =====>>>>${lastRecordedTime}");
      }
    }

    if (lastRecordedTime != null) {
      String? lastRecordedTimeString = storage.read('lastRecordedTime');
      if (lastRecordedTimeString != null) {
        DateTime storedLastRecordedTime = DateTime.parse(lastRecordedTimeString);
        print("storedLastRecordedTime ==========>>${storedLastRecordedTime}");
        DateTime currentTime = DateTime.now();
        print("currentTime =======>>>${currentTime}");
        int timeDifference = currentTime.difference(storedLastRecordedTime).inMinutes;
        print("time difference: $timeDifference");
        if (timeDifference >= 5) {
          int increments = timeDifference ~/ 5;
          print("increment =======>>>${increments}");
          int updatedLife = wrongLife + increments;
          if (updatedLife <= 5) {
            setState(() {
              wrongLife = updatedLife;
              storage.write(dataProvider.keyList[widget.oneCategoryName], wrongLife);
              print("wrongLife updated: $wrongLife");
            });
          } else {
            setState(() {
              wrongLife = 5;
              storage.write(dataProvider.keyList[widget.oneCategoryName], wrongLife);
              print("wrongLife capped at 5: $wrongLife");
            });
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Api dataProvider = Provider.of<Api>(context, listen: true);
    int minutes = (currentTime ~/ 60) % 60;
    int seconds = currentTime % 60;
    return BannerWrapper(
      parentContext: context,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Scaffold(
            extendBody: true,
            appBar: AppBar(
              leadingWidth: 60.w,
              toolbarHeight: isIpad ? 30.sp : 35.sp,
              centerTitle: true,
              backgroundColor: Colors.transparent,
              leading: Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image(
                      fit: BoxFit.fill,
                      height: isSmall ? 35.sp : 40.sp,
                      width: isSmall ? 35.w : 40.w,
                      image: AssetImage('assets/images/heart.png'),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 2.h),
                      child: Text(
                        textAlign: TextAlign.center,
                        '${wrongLife}',
                        style: GoogleFonts.rubik(
                          fontSize: isIpad ? 14.sp : 18.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              title: Text(
                '${dataProvider.keyList[widget.oneCategoryName]}',
                style: GoogleFonts.rubik(
                  fontSize: isIpad
                      ? 18.sp
                      : isSmall
                          ? 20.sp
                          : 25.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              actions: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {});
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        size: 18.sp,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )
              ],
            ),
            body: Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 15.h),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 8.sp),
                        child: Stack(
                          alignment: Alignment.center,
                          clipBehavior: Clip.none,
                          children: [
                            Material(
                              color: HexColor('006292'),
                              shape: BeveledRectangleBorder(
                                borderRadius: BorderRadius.circular(35.r),
                                side: BorderSide(width: 1.w, color: Colors.white),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: isIpad ? 15.sp : 25.sp),
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    '${widget.oneData[dataProvider.questionIndex]['Question']}',
                                    style: GoogleFonts.rubik(
                                      fontSize: isIpad ? 14.sp : 17.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ).animate().scaleXY(curve: Curves.bounceOut, duration: Duration(seconds: 2)),
                            Positioned(
                              top: -20.h,
                              child: CircularStepProgressIndicator(
                                totalSteps: totalStepCount,
                                circularDirection: CircularDirection.counterclockwise,
                                currentStep: start,
                                padding: isSmall
                                    ? math.pi / 30
                                    : isIpad
                                        ? math.pi / 35
                                        : math.pi / 40,
                                unselectedColor: Colors.black87,
                                selectedColor: Colors.white,
                                selectedStepSize: 3.sp,
                                unselectedStepSize: 3.sp,
                                width: isSmall
                                    ? 35.sp
                                    : isIpad
                                        ? 30.sp
                                        : 45.sp,
                                height: isSmall
                                    ? 35.sp
                                    : isIpad
                                        ? 30.sp
                                        : 45.sp,
                                child: Container(
                                  height: 35.sp,
                                  width: 35.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: HexColor('006292'),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${start}',
                                      style: GoogleFonts.rubik(
                                        fontSize: isSmall
                                            ? 12.sp
                                            : isIpad
                                                ? 12.sp
                                                : 18.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ).animate().scaleXY(curve: Curves.bounceOut, duration: Duration(seconds: 2)),
                          ],
                        ),
                      ),
                      GridView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: isIpad ? 10.sp : 20.sp),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent: isIpad ? 45.sp : 50.sp,
                          mainAxisSpacing: 10.sp,
                          crossAxisSpacing: 10.sp,
                        ),
                        itemCount: 4,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Bounce(
                            duration: Duration(milliseconds: 200),
                            onPressed: wrongLife != 0
                                ? () {
                                    if (!answerTap) {
                                      selectAnswer = widget.oneData[dataProvider.questionIndex]['answers'][index];
                                      colorChange = true;
                                      answerTap = true;
                                      nextButton = true;
                                      timer.cancel();
                                      if (index + 1 == widget.oneData[dataProvider.questionIndex]['answer']) {
                                        dataProvider.rightAnswer++;
                                        storeCorrectAnswerDetails(widget.oneData[dataProvider.questionIndex]);
                                        dataProvider.correctAnswer++;
                                        print("correctAnswer =======>>>>>${dataProvider.correctAnswer}");
                                      } else {
                                        dataProvider.wrongAnswer++;
                                        print("wrongAnswer ========>>>>${dataProvider.wrongAnswer}");
                                        if (wrongLife != 0) {
                                          // wrongLife = wrongLife - 1;
                                          storage.write(dataProvider.keyList[widget.oneCategoryName], wrongLife);
                                          print("wrongLife ==========>>>${wrongLife}");
                                          storeWrongAnswerDetails(widget.oneData[dataProvider.questionIndex]);
                                        }
                                        lastRecordedTime = DateTime.now();
                                        storage.write('lastRecordedTime', lastRecordedTime!.toIso8601String());
                                      }
                                      if (dataProvider.passCategory.length != dataProvider.keyList.length) {
                                        if (dataProvider.rightAnswer >= ((widget.oneData.length * 60) / 100).round()) {
                                          if (!dataProvider.passCategory.contains(dataProvider.keyList[widget.oneCategoryName + 1])) {
                                            dataProvider.passCategory.add(dataProvider.keyList[widget.oneCategoryName + 1]);
                                            storage.write(widget.CategoryName, dataProvider.passCategory);
                                          }
                                        }
                                      }
                                      if (dataProvider.questionIndex == 2) {
                                        resultDialog = true;
                                        setState(() {});
                                      }
                                    }
                                    setState(() {});
                                  }
                                : () {
                              lifeDialog = true;
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
                                      fontSize: isIpad
                                          ? 14.sp
                                          : isSmall
                                              ? 16.sp
                                              : 18.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    minFontSize: 12,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ).animate().scaleXY(curve: Curves.bounceOut, duration: Duration(seconds: 3)),
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
                                  padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: isIpad ? 8.sp : 12.sp),
                                  child: Column(
                                    children: [
                                      Text(
                                        textAlign: TextAlign.center,
                                        'Note :',
                                        style: GoogleFonts.rubik(
                                          fontSize: isIpad ? 15.sp : 20.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: isIpad ? 2.h : 5.h),
                                      Text(
                                        textAlign: TextAlign.justify,
                                        maxLines: 6,
                                        overflow: TextOverflow.ellipsis,
                                        '${widget.oneData[dataProvider.questionIndex]['Note']}',
                                        style: GoogleFonts.rubik(
                                          fontSize: isIpad
                                              ? 12.sp
                                              : isSmall
                                                  ? 14.sp
                                                  : 16.sp,
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
                                          padding: EdgeInsets.symmetric(vertical: isIpad ? 5.sp : 8.sp),
                                          child: Text(
                                            textAlign: TextAlign.center,
                                            'Back',
                                            style: GoogleFonts.rubik(
                                              fontSize: isIpad ? 20.sp : 25.sp,
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
                                            "CategoryName": widget.CategoryName,
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
                                          padding: EdgeInsets.symmetric(vertical: isIpad ? 5.sp : 8.sp),
                                          child: Text(
                                            textAlign: TextAlign.center,
                                            'Next',
                                            style: GoogleFonts.rubik(
                                              fontSize: isIpad ? 20.sp : 25.sp,
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
              ],
            ),
          ),
          lifeDialog == true
              ? Scaffold(
                  backgroundColor: Colors.black54,
                  body: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30.sp),
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 10.h, right: 10.w),
                                width: 1.sw,
                                decoration: BoxDecoration(
                                  border: Border.all(width: 2.w, color: Colors.white),
                                  borderRadius: BorderRadius.circular(10.r),
                                  color: HexColor('006292'),
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(8.sp),
                                      child: Text(
                                        'OUT OF LIVES ',
                                        style: GoogleFonts.rubik(
                                          fontSize: isSmall
                                              ? 20.sp
                                              : isIpad
                                                  ? 20.sp
                                                  : 25.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    Image(
                                      height: isSmall
                                          ? 50.sp
                                          : isIpad
                                              ? 50.sp
                                              : 60.sp,
                                      width: isSmall
                                          ? 50.w
                                          : isIpad
                                              ? 50.w
                                              : 60.w,
                                      fit: BoxFit.fill,
                                      image: AssetImage('assets/images/heart.png'),
                                    ),
                                    Text(
                                      'TIME TO NEXT LIFE',
                                      style: GoogleFonts.rubik(
                                        fontSize: isIpad ? 12.sp : 15.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(5.sp),
                                      child: Container(
                                        height: 40.sp,
                                        width: 100.w,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5.r),
                                          color: Colors.black45,
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 2.sp),
                                          child: Row(
                                            children: [
                                              Image(
                                                height: isSmall
                                                    ? 50.sp
                                                    : isIpad
                                                        ? 50.sp
                                                        : 55.sp,
                                                width: isSmall
                                                    ? 30.w
                                                    : isSmall
                                                        ? 30.w
                                                        : 35.w,
                                                image: AssetImage('assets/images/stopwatch.png'),
                                              ),
                                              SizedBox(width: 8.w),
                                              TimerCountdown(
                                                format: CountDownTimerFormat.minutesSeconds,
                                                enableDescriptions: false,
                                                colonsTextStyle: GoogleFonts.rubik(
                                                  fontSize: isSmall
                                                      ? 12.sp
                                                      : isIpad
                                                          ? 12.sp
                                                          : 15.sp,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                timeTextStyle: GoogleFonts.rubik(
                                                  fontSize: isIpad ? 12.sp : 15.sp,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                spacerWidth: 2.w,
                                                endTime: DateTime.now().add(
                                                  Duration(
                                                    minutes: minutes,
                                                    seconds: seconds,
                                                  ),
                                                ),
                                                onTick: (remainingTime) {},
                                                onEnd: () {},
                                              ),
                                              Spacer(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 10.sp),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                              setState(() {});
                                            },
                                            child: Container(
                                              height: 40.sp,
                                              width: 100.w,
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius: BorderRadius.circular(8.r),
                                                border: Border.all(width: 1.w, color: Colors.white),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'Back',
                                                  style: GoogleFonts.rubik(
                                                    fontSize: isSmall
                                                        ? 20.sp
                                                        : isIpad
                                                            ? 20.sp
                                                            : 22.sp,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                              setState(() {});
                                            },
                                            child: Container(
                                              height: 40.sp,
                                              width: 100.w,
                                              decoration: BoxDecoration(
                                                color: Colors.green,
                                                borderRadius: BorderRadius.circular(8.r),
                                                border: Border.all(width: 1.w, color: Colors.white),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'Continue',
                                                  style: GoogleFonts.rubik(
                                                    fontSize: isSmall
                                                        ? 20.sp
                                                        : isIpad
                                                            ? 20.sp
                                                            : 22.sp,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      lifeDialog = false;
                                    });
                                  },
                                  child: Container(
                                    height: 25.sp,
                                    width: 25.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.r),
                                      color: Colors.red,
                                      border: Border.all(width: 1.w, color: Colors.white),
                                    ),
                                    child: Icon(
                                      Icons.close,
                                      size: 20.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : SizedBox(),
          resetDialog == true
              ? Scaffold(
                  backgroundColor: Colors.black54,
                  body: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30.sp),
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 10.w, right: 10.w),
                                width: 1.sw,
                                decoration: BoxDecoration(
                                  border: Border.all(width: 2.w, color: Colors.white),
                                  borderRadius: BorderRadius.circular(10.r),
                                  color: HexColor('006292'),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      'TIME \'OUT ',
                                      style: GoogleFonts.rubik(
                                        fontSize: isSmall
                                            ? 20.sp
                                            : isIpad
                                                ? 20.sp
                                                : 25.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Image(
                                      height: isIpad ? 50.sp : 60.sp,
                                      width: isIpad ? 50.sp : 60.w,
                                      fit: BoxFit.fill,
                                      image: AssetImage('assets/images/stopwatch.png'),
                                    ),
                                    Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(5.sp),
                                        child: Text(
                                          "Don't give up, try to start challenging your winning streak!",
                                          style: GoogleFonts.rubik(
                                            fontSize: 15.sp,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 10.sp),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                              setState(() {});
                                            },
                                            child: Container(
                                              height: 40.sp,
                                              width: 100.w,
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius: BorderRadius.circular(8.r),
                                                border: Border.all(width: 1.w, color: Colors.white),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'Give Up',
                                                  style: GoogleFonts.rubik(
                                                    fontSize: isSmall
                                                        ? 18.sp
                                                        : isIpad
                                                            ? 18.sp
                                                            : 22.sp,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              resetDialog = false;
                                              start = 30;
                                              timeHandle();
                                              setState(() {});
                                            },
                                            child: Container(
                                              height: 40.sp,
                                              width: 100.w,
                                              decoration: BoxDecoration(
                                                color: Colors.green,
                                                borderRadius: BorderRadius.circular(8.r),
                                                border: Border.all(width: 1.w, color: Colors.white),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'Try Again',
                                                  style: GoogleFonts.rubik(
                                                    fontSize: isSmall
                                                        ? 18.sp
                                                        : isIpad
                                                            ? 18.sp
                                                            : 22.sp,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      resetDialog = false;
                                    });
                                  },
                                  child: Container(
                                    height: 25.sp,
                                    width: 25.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.r),
                                      color: Colors.red,
                                      border: Border.all(width: 1.w, color: Colors.white),
                                    ),
                                    child: Icon(
                                      Icons.close,
                                      size: 20.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : SizedBox(),
          resultDialog == true
              ? Scaffold(
                  backgroundColor: Colors.black54,
                  body: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30.sp),
                          child: Container(
                            margin: EdgeInsets.only(top: 10.w, right: 10.w),
                            width: 1.sw,
                            decoration: BoxDecoration(
                              border: Border.all(width: 2.w, color: Colors.white),
                              borderRadius: BorderRadius.circular(10.r),
                              color: HexColor('006292'),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.sp),
                              child: Column(
                                children: [
                                  Text(
                                    dataProvider.correctAnswer > dataProvider.wrongAnswer ? 'Congratulations!' : 'Oh no!',
                                    style: GoogleFonts.rubik(
                                      fontSize: isSmall
                                          ? 20.sp
                                          : isIpad
                                              ? 20.sp
                                              : 28.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 30.h, bottom: 30.h),
                                    child: Image(
                                      height: isIpad ? 50.sp : 60.sp,
                                      width: isIpad ? 50.sp : 60.w,
                                      fit: BoxFit.fill,
                                      image: dataProvider.correctAnswer > dataProvider.wrongAnswer ? AssetImage('assets/images/checked.png') : AssetImage('assets/images/wrong_answer.png'),
                                    ),
                                  ),
                                  Text(
                                    "Correct Answer : ${dataProvider.correctAnswer}",
                                    style: GoogleFonts.rubik(
                                      fontSize: 24.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    "Wrong Answer    : ${dataProvider.wrongAnswer}",
                                    style: GoogleFonts.rubik(
                                      fontSize: 24.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 10.sp),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                            setState(() {});
                                          },
                                          child: Container(
                                            height: 40.sp,
                                            width: 100.w,
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius: BorderRadius.circular(8.r),
                                              border: Border.all(width: 1.w, color: Colors.white),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'Back',
                                                style: GoogleFonts.rubik(
                                                  fontSize: isSmall
                                                      ? 18.sp
                                                      : isIpad
                                                          ? 18.sp
                                                          : 22.sp,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            if (dataProvider.correctAnswer > dataProvider.wrongAnswer) {
                                              Navigator.pop(context);
                                            } else {
                                              resultDialog = false;
                                              colorChange = false;
                                              answerTap = false;
                                              nextButton = false;
                                              dataProvider.questionIndex = 0;
                                              start = 30;
                                              timeHandle();
                                            }
                                            setState(() {});
                                          },
                                          child: Container(
                                            height: 40.sp,
                                            width: 100.w,
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius: BorderRadius.circular(8.r),
                                              border: Border.all(width: 1.w, color: Colors.white),
                                            ),
                                            child: Center(
                                              child: Text(
                                                dataProvider.correctAnswer > dataProvider.wrongAnswer ? 'Next' : 'Try Again',
                                                style: GoogleFonts.rubik(
                                                  fontSize: isSmall
                                                      ? 18.sp
                                                      : isIpad
                                                          ? 18.sp
                                                          : 22.sp,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }

  void storeCorrectAnswerDetails(Map<String, dynamic> questionDetails) {
    Api dataProvider = Provider.of<Api>(context, listen: false);

    Map<String, dynamic> correctAnswerDetails = {
      'question': questionDetails['Question'],
      'options': List<String>.from(questionDetails['answers']),
      'correctAnswerIndex': questionDetails['answer'],
    };

    dataProvider.correctAnswersDetailsList.add(correctAnswerDetails);
    // print("correctAnswersDetailsList ======>>>>>>>${dataProvider.correctAnswersDetailsList}");
    storage.write("correctAnswersDetailsList", dataProvider.correctAnswersDetailsList);
  }

  void storeWrongAnswerDetails(Map<String, dynamic> questionDetails) {
    Api dataProvider = Provider.of<Api>(context, listen: false);

    Map<String, dynamic> wrongAnswerDetails = {
      'question': questionDetails['Question'],
      'options': List<String>.from(questionDetails['answers']),
      'correctAnswerIndex': questionDetails['answer'],
    };

    dataProvider.wrongAnswersDetailsList.add(wrongAnswerDetails);
    // print("wrongAnswersDetailsList ======>>>>>>>${dataProvider.wrongAnswersDetailsList}");
    storage.write("wrongAnswersDetailsList", dataProvider.wrongAnswersDetailsList);
  }
}
