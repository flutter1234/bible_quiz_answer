import 'package:bible_quiz_answer/AdPlugin/Ads/Banner/BannerWrapper.dart';
import 'package:bible_quiz_answer/AdPlugin/Ads/Native/NativeRN.dart';
import 'package:bible_quiz_answer/Provider/api_provider.dart';
import 'package:bible_quiz_answer/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class history_screen extends StatefulWidget {
  static const routeName = '/history_screen';

  const history_screen({super.key});

  @override
  State<history_screen> createState() => _history_screenState();
}

class _history_screenState extends State<history_screen> {
  String questionTrue = 'Correct';
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    Api dataProvider = Provider.of<Api>(context, listen: false);
    dataProvider.wrongAnswersDetailsList = storage.read("wrongAnswersDetailsList") ?? [];
    dataProvider.correctAnswersDetailsList = storage.read("correctAnswersDetailsList") ?? [];
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
          leading: Text(''),
          actions: [
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
          title: Text(
            'History',
            style: GoogleFonts.rubik(
              fontSize: isIpad
                  ? 20.sp
                  : isSmall
                      ? 22.sp
                      : 25.sp,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        scrollController.jumpTo(scrollController.position.minScrollExtent);
                        questionTrue = "Correct";
                      });
                    },
                    child: Container(
                      height: isSmall ? 40.sp : 45.sp,
                      width: 100.w,
                      decoration: BoxDecoration(
                        color: questionTrue == "Correct" ? Colors.green.shade700 : HexColor('006292'),
                        border: Border(
                          top: BorderSide(width: 1.w, color: Colors.white),
                          right: BorderSide(width: 1.w, color: Colors.white),
                          bottom: BorderSide(width: 1.w, color: Colors.white),
                        ),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(5.r),
                          bottomRight: Radius.circular(5.r),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.sp),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image(
                              height: isSmall
                                  ? 30.sp
                                  : isIpad
                                      ? 32.sp
                                      : 35.sp,
                              width: isSmall
                                  ? 30.w
                                  : isIpad
                                      ? 32.w
                                      : 35.w,
                              fit: BoxFit.fill,
                              color: Colors.white,
                              image: AssetImage('assets/images/correct.png'),
                            ),
                            Text(
                              '${dataProvider.correctAnswersDetailsList.length}',
                              style: GoogleFonts.rubik(
                                fontSize: isIpad
                                    ? 18.sp
                                    : isSmall
                                        ? 20.sp
                                        : 25.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        scrollController.jumpTo(scrollController.position.minScrollExtent);
                        questionTrue = "Wrong";
                      });
                    },
                    child: Container(
                      height: isSmall ? 40.sp : 45.sp,
                      width: 100.w,
                      decoration: BoxDecoration(
                        color: questionTrue == "Wrong" ? Colors.red : HexColor('006292'),
                        border: Border(
                          top: BorderSide(width: 1.w, color: Colors.white),
                          left: BorderSide(width: 1.w, color: Colors.white),
                          bottom: BorderSide(width: 1.w, color: Colors.white),
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(5.r),
                          topLeft: Radius.circular(5.r),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.sp),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image(
                              height: isSmall
                                  ? 30.sp
                                  : isIpad
                                      ? 32.sp
                                      : 35.sp,
                              width: isSmall
                                  ? 30.w
                                  : isIpad
                                      ? 32.w
                                      : 35.w,
                              fit: BoxFit.fill,
                              color: Colors.white,
                              image: AssetImage('assets/images/wrong.png'),
                            ),
                            Text(
                              '${dataProvider.wrongAnswersDetailsList.length}',
                              style: GoogleFonts.rubik(
                                fontSize: isIpad
                                    ? 18.sp
                                    : isSmall
                                        ? 20.sp
                                        : 25.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (questionTrue == "Correct") ...{
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: dataProvider.correctAnswersDetailsList.length,
                  padding: EdgeInsets.only(top: 20.h),
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        index == 2 ? NativeRN(parentContext: context) : SizedBox(),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 8.sp),
                          child: Container(
                            width: 1.sw,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.r),
                              color: Colors.black45,
                              // border: Border.all(width: 1.w, color: Colors.white),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.sp,
                                vertical: isSmall
                                    ? 15.sp
                                    : isIpad
                                        ? 10.sp
                                        : 20.sp,
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10.sp),
                                    child: Container(
                                      width: 1.sw,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.r),
                                        border: Border.all(width: 1.w, color: Colors.white),
                                        color: HexColor('006386'),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 10.sp),
                                        child: Text(
                                          textAlign: TextAlign.center,
                                          '${dataProvider.correctAnswersDetailsList[index]['question']}',
                                          style: GoogleFonts.rubik(
                                            fontSize: isIpad
                                                ? 13.sp
                                                : isSmall
                                                    ? 15.sp
                                                    : 17.sp,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10.w, top: 10.h),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Answer: ${dataProvider.correctAnswersDetailsList[index]['options'][dataProvider.correctAnswersDetailsList[index]['correctAnswerIndex'] - 1]}',
                                        style: GoogleFonts.rubik(
                                          fontSize: isIpad
                                              ? 14.sp
                                              : isSmall
                                                  ? 18.sp
                                                  : 20.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              )
            } else if (questionTrue == "Wrong") ...{
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: dataProvider.wrongAnswersDetailsList.length,
                  padding: EdgeInsets.only(top: 20.h),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 8.sp),
                      child: Column(
                        children: [
                          index == 2 ? NativeRN(parentContext: context) : SizedBox(),
                          Container(
                            width: 1.sw,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.r),
                              color: Colors.black45,
                              // border: Border.all(width: 1.w, color: Colors.white),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.sp,
                                vertical: isSmall
                                    ? 15.sp
                                    : isIpad
                                        ? 10.sp
                                        : 20.sp,
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10.sp),
                                    child: Container(
                                      width: 1.sw,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.r),
                                        border: Border.all(width: 1.w, color: Colors.white),
                                        color: HexColor('006386'),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 10.sp),
                                        child: Text(
                                          textAlign: TextAlign.center,
                                          '${dataProvider.wrongAnswersDetailsList[index]['question']}',
                                          style: GoogleFonts.rubik(
                                            fontSize: isIpad
                                                ? 13.sp
                                                : isSmall
                                                    ? 15.sp
                                                    : 17.sp,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10.w, top: 10.h),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Answer: ${dataProvider.wrongAnswersDetailsList[index]['options'][dataProvider.wrongAnswersDetailsList[index]['correctAnswerIndex'] - 1]}',
                                        style: GoogleFonts.rubik(
                                          fontSize: isIpad
                                              ? 14.sp
                                              : isSmall
                                                  ? 18.sp
                                                  : 20.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
            }
          ],
        ),
      ),
    );
  }
}
