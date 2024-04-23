import 'package:bible_quiz_answer/AdPlugin/Ads/Banner/BannerWrapper.dart';
import 'package:bible_quiz_answer/AdPlugin/MainJson/MainJson.dart';
import 'package:bible_quiz_answer/Provider/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../main.dart';

class setting_screen extends StatefulWidget {
  static const routeName = '/setting_screen';

  const setting_screen({super.key});

  @override
  State<setting_screen> createState() => _setting_screenState();
}

class _setting_screenState extends State<setting_screen> {
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
            'Setting',
            style: GoogleFonts.rubik(
              fontSize: isIpad ? 20.sp : 25.sp,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.sp),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 15.h),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      dataProvider.url = context.read<MainJson>().data!['assets']['privacyPolicy'];
                    });
                    dataProvider.launchurl();
                  },
                  child: Container(
                    height: 45.sp,
                    width: 1.sw,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.w, color: Colors.white),
                      borderRadius: BorderRadius.circular(8.r),
                      color: Colors.black45,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.sp),
                      child: Row(
                        children: [
                          Icon(
                            Icons.lock_person_rounded,
                            size: isIpad
                                ? 30.sp
                                : isSmall
                                    ? 30.sp
                                    : 32.sp,
                            color: Colors.grey.shade300,
                          ),
                          SizedBox(width: 20.w),
                          Text(
                            'Privacy Policy',
                            style: GoogleFonts.rubik(
                              fontSize: isIpad
                                  ? 20.sp
                                  : isSmall
                                      ? 20.sp
                                      : 24.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ), //1
              GestureDetector(
                onTap: () {
                  setState(() {
                    dataProvider.url = context.read<MainJson>().data!['assets']['contactUs'];
                  });
                  dataProvider.launchurl();
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 15.h),
                  child: Container(
                    height: 45.sp,
                    width: 1.sw,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.w, color: Colors.white),
                      borderRadius: BorderRadius.circular(8.r),
                      color: Colors.black45,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.sp),
                      child: Row(
                        children: [
                          Icon(
                            Icons.contact_page_rounded,
                            size: isIpad
                                ? 30.sp
                                : isSmall
                                    ? 30.sp
                                    : 32.sp,
                            color: Colors.grey.shade300,
                          ),
                          SizedBox(width: 20.w),
                          Text(
                            'Contactus',
                            style: GoogleFonts.rubik(
                              fontSize: isIpad
                                  ? 20.sp
                                  : isSmall
                                      ? 20.sp
                                      : 24.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ), //2
              GestureDetector(
                onTap: () {
                  setState(() {
                    dataProvider.url = context.read<MainJson>().data!['assets']['rateUs'];
                  });
                  dataProvider.launchurl();
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 15.h),
                  child: Container(
                    height: 45.sp,
                    width: 1.sw,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.w, color: Colors.white),
                      borderRadius: BorderRadius.circular(8.r),
                      color: Colors.black45,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.sp),
                      child: Row(
                        children: [
                          Icon(
                            Icons.star_rate,
                            size: isIpad
                                ? 30.sp
                                : isSmall
                                    ? 30.sp
                                    : 32.sp,
                            color: Colors.grey.shade300,
                          ),
                          SizedBox(width: 20.w),
                          Text(
                            'RateUs',
                            style: GoogleFonts.rubik(
                              fontSize: isIpad
                                  ? 20.sp
                                  : isSmall
                                      ? 20.sp
                                      : 24.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ), //3
              Padding(
                padding: EdgeInsets.only(top: 15.h),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      dataProvider.url = context.read<MainJson>().data!['assets']['shareApp'];
                    });
                    dataProvider.launchurl();
                  },
                  child: Container(
                    height: 45.sp,
                    width: 1.sw,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.w, color: Colors.white),
                      borderRadius: BorderRadius.circular(8.r),
                      color: Colors.black45,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.sp),
                      child: Row(
                        children: [
                          Icon(
                            Icons.feedback_sharp,
                            size: isIpad
                                ? 30.sp
                                : isSmall
                                    ? 30.sp
                                    : 32.sp,
                            color: Colors.grey.shade300,
                          ),
                          SizedBox(width: 20.w),
                          Text(
                            'Share App',
                            style: GoogleFonts.rubik(
                              fontSize: isIpad
                                  ? 20.sp
                                  : isSmall
                                      ? 20.sp
                                      : 24.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ), //4

              Spacer(
                flex: 5,
              ),
              Text(
                'V${context.read<MainJson>().version}',
                style: GoogleFonts.rubik(
                  fontSize: 22.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
