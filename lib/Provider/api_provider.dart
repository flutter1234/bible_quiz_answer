import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class Api extends ChangeNotifier {
  Map mainData = {};
  List quizListData = [];
  late String url;
  int questionIndex = 0;

  Future<void> quizAnswerData(var Url) async {
    var url = Uri.parse(Url);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var quizList = jsonDecode(response.body);
      quizListData = quizList['data'];
      notifyListeners();
    }
    notifyListeners();
    // print('quizListData ==========>>>>>>${quizListData}');
  }

  Future<void> launchurl() async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch ${Uri.parse(url)}');
    }
  }
}
