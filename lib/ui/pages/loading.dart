import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:convert';
import 'package:beautiful/ui/common/database.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:beautiful/ui/common/connectivity_chick.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  String quoteText;
  String quoteAuthor;
  String quoteDate;
  ConnectivityCheck checker = ConnectivityCheck();

  final dbHelper = DatabaseHelper.instance;

  Future fetchQuote() async {
    String status;

    try {
      checker.checkConnectivity().then((String result) => status = result);
      if (status != "Unknown" ||
          status != "Failed to get connectivity." ||
          status != null) {
        final response = await http.get('https://favqs.com/api/qotd');

        if (response.statusCode == 200) {
          var results = jsonDecode(response.body);

          this.quoteText = results['quote']['body'];
          this.quoteAuthor = results['quote']['author'];
          this.quoteDate = results['qotd_date'];
        } else {
          try {
            final result = await dbHelper.queryRow(2);
            result.forEach((row) {
              this.quoteAuthor = row['quote_author'];
              this.quoteText = row['quote_text'];
            });
          } catch (e) {
            print(e);
            this.quoteAuthor = 'Try Again later';
            this.quoteText = 'Try Again later';
          }
        }
      }
    } catch (e) {
      print("iam here now loading");
      final result = await dbHelper.queryAllRows();
      result.forEach((row) {
        this.quoteAuthor = row['quote_author'];
        this.quoteText = row['quote_text'];
      });
      print(this.quoteAuthor);
    }

    Navigator.pushReplacementNamed(context, '/home', arguments: {
      'quoteText': this.quoteText,
      'quoteAuthor': this.quoteAuthor,
      'quoteDate': this.quoteDate,
    });
  }

  @override
  void initState() {
    super.initState();
    fetchQuote();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent[200],
      body: Center(
        child: SpinKitFoldingCube(
          color: Colors.white,
          size: 50.0,
        ),
      ),
    );
  }
}
