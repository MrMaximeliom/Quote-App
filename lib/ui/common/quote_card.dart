import 'package:flutter/material.dart';
import 'dart:async';
import 'package:like_button/like_button.dart';
import 'package:beautiful/ui/common/database.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:beautiful/ui/common/connectivity_chick.dart';

class QuoteCard extends StatefulWidget {
  @override
  _QuoteCardState createState() => _QuoteCardState();
}

class _QuoteCardState extends State<QuoteCard> {
  String quoteText;
  String quoteAuthor;
  String quoteDate;
  ConnectivityCheck checker = ConnectivityCheck();

  final dbHelper = DatabaseHelper.instance;

  void insert() async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.quoteText: this.quoteText,
      DatabaseHelper.quoteAuthor: this.quoteAuthor,
    };
    final id = await dbHelper.insert(row);
    print('inserted row id: $id');
  }

  Future<bool> changedata(status) async {
    //your code
    insert();
    return Future.value(!status);
  }

  Future<void> fetchQuote() async {
    String status;
    try {
      checker.checkConnectivity().then((String result) => status = result);
      if (status != null ||
          status != "Unknown" ||
          status != "Failed to get connectivity.") {
        final response = await http.get('https://favqs.com/api/qotd');
        // String tempQuoteText = this.quoteText;
        // String tempQouteAuthor = this.quoteDate;
        // String tempQuoteDAte = this.quoteDate;

        if (response.statusCode == 200) {
          var results = jsonDecode(response.body);
          print(results['quote']['body']);
          setState(() {
            this.quoteText = results['quote']['body'];
            this.quoteAuthor = results['quote']['author'];
            this.quoteDate = results['qotd_date'];
          });
        } else {
          getDataOffline();
        }
      } else {
        getDataOffline();
      }
    } catch (r) {
      print("fjjssf");

      getDataOffline();
    }
  }

  void getDataOffline() async {
    final result = await dbHelper.queryAllRows();
    setState(() {
      result.forEach((row) {
        this.quoteAuthor = row['quote_author'];
        this.quoteText = row['quote_text'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print(this.quoteText);
    if (this.quoteText == null ||
        this.quoteText == null ||
        this.quoteText == "loading" ||
        this.quoteText == "loading") {
      setState(() {
        getDataOffline();
      });
    }

    // handleData();
    return RefreshIndicator(
        onRefresh: fetchQuote,
        child: Container(
          color: Colors.redAccent[100],
          child: ListView(
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Image.asset(
                      'assets/quote.png',
                      width: 60.0,
                      height: 60.0,
                      alignment: Alignment.bottomRight,
                    )
                  ]),
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        quoteText != null ? quoteText : "loading",
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                          fontFamily: 'Courgette',
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Align(
                    child: Image.asset(
                      'assets/quote.png',
                      width: 60.0,
                      height: 60.0,
                      alignment: FractionalOffset.bottomCenter,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 4.0,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Text(
                    quoteAuthor != null ? quoteAuthor : "loading",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontFamily: 'IndieFlower',
                    ),
                  ),
                ),
              ),
              LikeButton(
                size: 30.0,
                circleColor: CircleColor(
                    start: Color(0xff00ddff), end: Color(0xff0099cc)),
                bubblesColor: BubblesColor(
                  dotPrimaryColor: Color(0xff33b5e5),
                  dotSecondaryColor: Color(0xff0099cc),
                ),
                onTap: (isLiked) {
                  final snackbar = SnackBar(
                    backgroundColor: Colors.black,
                    content: Text(
                      'Added To Liked Quotes',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                    duration: Duration(seconds: 1),
                  );
                  Scaffold.of(context).showSnackBar(snackbar);
                  return changedata(
                    isLiked,
                  );
                },
                likeBuilder: (bool isLiked) {
                  return Icon(
                    Icons.favorite,
                    color: isLiked ? Colors.redAccent[400] : Colors.white,
                    size: 30.0,
                  );
                },
                likeCount: 0,
                countBuilder: (int count, bool isLiked, String text) {
                  var color = isLiked ? Colors.redAccent[400] : Colors.white;
                  Widget result;
                  result = Text(
                    "love it",
                    style: TextStyle(
                      color: color,
                      fontSize: 20.0,
                    ),
                  );
                  return result;
                },
              ),
              SizedBox(
                height: 8.0,
              ),
            ],
          ),
        ));
    //       ],
    //     ),
    //   ),

    // );
  }
}
