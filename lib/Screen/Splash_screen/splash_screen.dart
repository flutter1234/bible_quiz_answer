import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class splash_screen extends StatefulWidget {
  static const routeName = '/splash_screen';

  const splash_screen({super.key});

  @override
  State<splash_screen> createState() => _splash_screenState();
}

class _splash_screenState extends State<splash_screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Spacer(flex: 3),
          Center(
            child: Image(
              fit: BoxFit.cover,
              height: 150.sp,
              width: 200.w,
              image: AssetImage('assets/images/quiz_logo.png'),
            ),
          ),
          Spacer(flex: 2),
          Text(
            'Loading...',
            style: GoogleFonts.rubik(
              fontSize: 25.sp,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
