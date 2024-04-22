import 'package:auto_size_text/auto_size_text.dart';
import 'package:bible_quiz_answer/AdPlugin/Ads/Banner/BannerWrapper.dart';
import 'package:bible_quiz_answer/AdPlugin/Ads/FullScreen/Ads.dart';
import 'package:bible_quiz_answer/Provider/api_provider.dart';
import 'package:bible_quiz_answer/main.dart';
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

  @override
  void initState() {
    Api dataProvider = Provider.of<Api>(context, listen: false);
    dataProvider.passCategory = storage.read(widget.CategoryName) ?? [];
    dataProvider.wrongAnswersDetailsList = storage.read("wrongAnswersDetailsList") ?? [];
    dataProvider.correctAnswersDetailsList = storage.read("correctAnswersDetailsList") ?? [];
    wrongLife = storage.read(dataProvider.keyList[widget.oneCategoryName]) ?? 5;
    String? lastRecordedTimeString = storage.read('lastRecordedTime');
    lastRecordedTime = lastRecordedTimeString != null ? DateTime.parse(lastRecordedTimeString) : null;
    // print("lastRecordTime ====>>>${lastRecordedTime}");
    wrongLifeGenerate();
    super.initState();
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

        if (timeDifference >= 1) {
          int increments = timeDifference ~/ 1;
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
    return BannerWrapper(
      parentContext: context,
      child: Scaffold(
        extendBody: true,
        appBar: AppBar(
          toolbarHeight: isIpad ? 30.sp : 35.sp,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          leading: Padding(
            padding: EdgeInsets.only(left: isIpad ? 10.w : 0),
            child: IconButton(
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
          ),
          title: Text(
            '${dataProvider.keyList[widget.oneCategoryName]}',
            style: GoogleFonts.rubik(
              fontSize: isIpad ? 20.sp : 25.sp,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 10.w),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image(
                    fit: BoxFit.fill,
                    height: 30.sp,
                    image: AssetImage('assets/images/heart.png'),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 2.h),
                    child: Text(
                      textAlign: TextAlign.center,
                      '${wrongLife}',
                      style: GoogleFonts.rubik(
                        fontSize: isIpad ? 14.sp : 20.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 8.sp),
              child: Material(
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
                  onPressed: () {
                    if (!answerTap) {
                      selectAnswer = widget.oneData[dataProvider.questionIndex]['answers'][index];
                      colorChange = true;
                      answerTap = true;
                      nextButton = true;
                      if (index + 1 == widget.oneData[dataProvider.questionIndex]['answer']) {
                        dataProvider.rightAnswer++;
                        storeCorrectAnswerDetails(widget.oneData[dataProvider.questionIndex]);
                      } else {
                        if (wrongLife != 0) {
                          wrongLife = wrongLife - 1;
                          storage.write(dataProvider.keyList[widget.oneCategoryName], wrongLife);
                          print("wrongLife ==========>>>${wrongLife}");
                          storeWrongAnswerDetails(widget.oneData[dataProvider.questionIndex]);
                        }
                        lastRecordedTime = DateTime.now();
                        storage.write('lastRecordedTime', lastRecordedTime!.toIso8601String());
                      }
                      if (dataProvider.passCategory.length != dataProvider.keyList.length) {
                        if (dataProvider.rightAnswer == ((widget.oneData.length * 60) / 100).round()) {
                          if (!dataProvider.passCategory.contains(dataProvider.keyList[widget.oneCategoryName + 1])) {
                            dataProvider.passCategory.add(dataProvider.keyList[widget.oneCategoryName + 1]);
                            storage.write(widget.CategoryName, dataProvider.passCategory);
                          }
                        }
                      }
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
