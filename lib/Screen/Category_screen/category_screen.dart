import 'package:bible_quiz_answer/AdPlugin/Ads/Banner/BannerWrapper.dart';
import 'package:bible_quiz_answer/AdPlugin/Ads/FullScreen/Ads.dart';
import 'package:bible_quiz_answer/Provider/api_provider.dart';
import 'package:bible_quiz_answer/Screen/Quiz_screen/quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import '../../main.dart';

class category_screen extends StatefulWidget {
  static const routeName = '/category_screen';
  final List data;
  final Testament;

  const category_screen({super.key, required this.data, required this.Testament});

  @override
  State<category_screen> createState() => _category_screenState();
}

class _category_screenState extends State<category_screen> {
  @override
  void initState() {
    Api dataProvider = Provider.of<Api>(context, listen: false);
    dataProvider.passCategory = storage.read(widget.Testament) ?? [];
    dataProvider.keyList.clear();
    widget.data.forEach((element) {
      dataProvider.keyList.addAll(element.keys.toList());
    });
    dataProvider.passCategory.isEmpty ? dataProvider.passCategory.add(dataProvider.keyList[0]) : null;
    storage.write(widget.Testament, dataProvider.passCategory);
    print("passCategory ====>>>>>>>${dataProvider.passCategory}");
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
            '${widget.Testament}',
            style: GoogleFonts.rubik(
              fontSize: isIpad ? 20.sp : 25.sp,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: GridView.builder(
          padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 5.sp),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: isIpad ? 65.sp : 75.sp,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
          ),
          itemCount: dataProvider.keyList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: /*dataProvider.passCategory.contains(dataProvider.keyList[index])
                  ?*/
                  () {
                dataProvider.questionIndex = 0;
                dataProvider.rightAnswer = 0;
                dataProvider.correctAnswer = 0;
                dataProvider.wrongAnswer = 0;
                AdsRN().showFullScreen(
                  context: context,
                  onComplete: () {
                    Navigator.pushNamed(
                      context,
                      quiz_screen.routeName,
                      arguments: {
                        "oneCategory": widget.data[index][dataProvider.keyList[index]],
                        "oneCategoryName": index,
                        "CategoryName": widget.Testament,
                      },
                    ).then((value) {
                      dataProvider.passCategory = storage.read(widget.Testament) ?? [];
                      setState(() {});
                    });
                  },
                );
                setState(() {});
                // print("${widget.data[index][keyList[index]]}");
                // print("${keyList[index]}");
              },
              // : () {
              //     Fluttertoast.showToast(
              //       msg: "You Are Not Available For This Level",
              //       toastLength: Toast.LENGTH_SHORT,
              //       gravity: ToastGravity.BOTTOM,
              //       timeInSecForIosWeb: 1,
              //       backgroundColor: HexColor('006386'),
              //       textColor: Colors.white,
              //       fontSize: isIpad ? 10.sp : 12.sp,
              //     );
              //   },
              child: Stack(
                children: [
                  Container(
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
                          '${dataProvider.keyList[index]}',
                          style: GoogleFonts.rubik(
                            fontSize: isIpad
                                ? 16.sp
                                : isSmall
                                    ? 16.sp
                                    : 18.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (!dataProvider.passCategory.contains(dataProvider.keyList[index])) ...{
                    Container(
                      height: 1.sh,
                      width: 1.sw,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(width: 1.w, color: Colors.white),
                        color: Colors.black54,
                      ),
                      child: Icon(
                        Icons.lock,
                        size: 35.sp,
                        color: Colors.white,
                      ),
                    ),
                  }
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
