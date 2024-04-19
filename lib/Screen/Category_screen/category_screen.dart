import 'package:bible_quiz_answer/AdPlugin/Ads/Banner/BannerWrapper.dart';
import 'package:bible_quiz_answer/AdPlugin/Ads/FullScreen/Ads.dart';
import 'package:bible_quiz_answer/Provider/api_provider.dart';
import 'package:bible_quiz_answer/Screen/Quiz_screen/quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class category_screen extends StatefulWidget {
  static const routeName = '/category_screen';
  final List data;
  final Testament;

  const category_screen({super.key, required this.data, required this.Testament});

  @override
  State<category_screen> createState() => _category_screenState();
}

class _category_screenState extends State<category_screen> {
  List keyList = [];

  @override
  void initState() {
    widget.data.forEach((element) {
      keyList.addAll(element.keys.toList());
    });
    super.initState();
  }

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
            '${widget.Testament}',
            style: GoogleFonts.rubik(
              fontSize: 25.sp,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        body: GridView.builder(
          padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 12.sp),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 75.sp,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
          ),
          itemCount: keyList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                dataProvider.questionIndex = 0;
                AdsRN().showFullScreen(
                  context: context,
                  onComplete: () {
                    Navigator.pushNamed(
                      context,
                      quiz_screen.routeName,
                      arguments: {
                        "oneCategory": widget.data[index][keyList[index]],
                        "oneCategoryName": keyList[index],
                      },
                    );
                  },
                );
                setState(() {});
                // print("${widget.data[index][keyList[index]]}");
                // print("${keyList[index]}");
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(width: 1.w, color: Colors.white),
                  color: HexColor('006292'),
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.sp),
                    child: Text(
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      '${keyList[index]}',
                      style: GoogleFonts.rubik(
                        fontSize: 18.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
