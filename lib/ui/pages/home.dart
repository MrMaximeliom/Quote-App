import 'package:flutter/material.dart';
import 'package:beautiful/ui/common/quote_card.dart';
import 'package:beautiful/ui/common/database.dart';
import 'package:beautiful/ui/common/quote.dart';
import 'package:beautiful/ui/pages/liked.dart';

class Home extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final dbHelper = DatabaseHelper.instance;
  var likedQuotes;

  List<Quote> quotes = [];
  @override
  void initState() {
    super.initState();
    queryAll();
  }

  void queryAll() async {
    final allRows = await dbHelper.queryAllRows();
    quotes.clear();
    allRows.forEach((row) => quotes.add(Quote.fromMap(row)));
    // _showMessageInScaffold('Query done.');
    setState(() {});
  }

  Map data = {};

  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty ? data : ModalRoute.of(context).settings.arguments;

    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              title: Text('Beautiful Quotes'),
              centerTitle: true,
              elevation: 0.0,
              // backgroundColor: _color,
              backgroundColor: Colors.redAccent,
              bottom: TabBar(
                tabs: [
                  Tab(
                    icon: Icon(Icons.calendar_today),
                  ),
                  Tab(
                    icon: Icon(Icons.favorite),
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                Center(
                  child: QuoteCard(),
                ),
                Center(
                  child: LikedQuotes(),
                  // child: Scaffold(
                  //   backgroundColor: _color,
                  //   // backgroundColor: Colors.redAccent[100],
                  //   body: ListView.builder(
                  //     itemCount: quotes.length,
                  //     itemBuilder: (context, index) {
                  //       return Padding(
                  //         padding: const EdgeInsets.symmetric(
                  //             vertical: 1.0, horizontal: 4.0),
                  //         child: Column(
                  //           children: <Widget>[
                  //             Padding(
                  //               padding: const EdgeInsets.all(8.0),
                  //               child: Text(
                  //                 quotes[index].quoteText,
                  //                 style: TextStyle(
                  //                   fontSize: 20.0,
                  //                   color: Colors.white,
                  //                 ),
                  //               ),
                  //             ),
                  //             Padding(
                  //               padding: const EdgeInsets.all(8.0),
                  //               child: Text(
                  //                 quotes[index].quoteAuthor,
                  //                 style: TextStyle(
                  //                   fontSize: 18.0,
                  //                   color: Colors.white,
                  //                   fontFamily: 'IndieFlower',
                  //                 ),
                  //               ),
                  //             ),
                  //             if (index != quotes.length - 1)
                  //               Divider(
                  //                 height: 60.0,
                  //                 color: Colors.grey[800],
                  //               ),
                  //           ],
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // ),
                ),
              ],
            )));
  }
}
