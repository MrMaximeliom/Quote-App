import 'package:flutter/material.dart';
import 'package:beautiful/ui/common/database.dart';
import 'package:beautiful/ui/common/quote.dart';

class LikedQuotes extends StatefulWidget {
  @override
  _LikedQuotesState createState() => _LikedQuotesState();
}

class _LikedQuotesState extends State<LikedQuotes> {
  int counter = 0;

  // create db instance
  final dbHelper = DatabaseHelper.instance;
  var likedQuotes;
  List<Quote> quotes = [];
  Future<List<Quote>> wholeQuotes;

  @override
  void initState() {
    super.initState();
    // queryAll();
    fetchDatafromTable();
  }

  void setLikedQuotes() {
    this.likedQuotes = dbHelper.queryAllRows();
  }

  void deleteQuote(int id, int index) {
    final snackbar = SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        'Removed from Liked Quotes',
        style: TextStyle(
          fontSize: 18.0,
          color: Colors.white,
        ),
      ),
    );
    Scaffold.of(context).showSnackBar(snackbar);
  }

  void queryAll() async {
    final allRows = await dbHelper.queryAllRows();
    quotes.clear();
    allRows.forEach((row) => quotes.add(Quote.fromMap(row)));
    print("dkdk");

    // _showMessageInScaffold('Query done.');
    setState(() {});
  }

  fetchDatafromTable() {
    setState(() {
      wholeQuotes = dbHelper.fetchSavedQuotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: wholeQuotes,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data.length);
            if (snapshot.data.length > 0) {
              return Container(
                color: Colors.redAccent[100],
                child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (builder, index) {
                      return Card(
                        color: Colors.redAccent[100],
                        child: ListTile(
                          title: Text(
                            snapshot.data[index].quoteText,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: 'Courgette',
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              snapshot.data[index].quoteAuthor,
                              style: TextStyle(
                                fontSize: 17.0,
                                fontFamily: 'IndieFlower',
                                color: Colors.white,
                              ),
                            ),
                          ),
                          trailing: IconButton(
                              icon: Icon(Icons.remove_circle),
                              color: Colors.red,
                              onPressed: () async {
                                print('hi');
                                await dbHelper.delete(snapshot.data[index].id);
                                fetchDatafromTable();
                                // setState(() {
                                //   wholeQuotes = dbHelper.fetchSavedQuotes();
                                // });
                                final removedSnackBar = SnackBar(
                                  backgroundColor: Colors.black,
                                  content: Text(
                                    'Removed from Favorites',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15.0),
                                  ),
                                );
                                Scaffold.of(context)
                                    .showSnackBar(removedSnackBar);
                              }),
                        ),
                      );
                    }),
              );
            } else {
              return Center(
                child: Text(
                  'No Data in the Favorites',
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'quoteScript'),
                ),
              );
            }
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Failed to Load Favorites'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });

    // return Scaffold(
    //   backgroundColor: Colors.redAccent[100],
    //   body: ListView.builder(
    //     itemCount: quotes.length,
    //     itemBuilder: (context, index) {
    //       return Padding(
    //         padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
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
    //             FlatButton.icon(
    //               onPressed: () {
    //                 print(quotes[index].id);
    //                 deleteQuote(quotes[index].id, index);
    //                 // dbHelper.delete(quotes[index].id);

    //                 setState(() {
    //                   queryAll();
    //                 });
    //               },
    //               icon: Icon(
    //                 Icons.delete,
    //                 color: Colors.white,
    //               ),
    //               label: Text(
    //                 'Remove',
    //                 style: TextStyle(
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
    // );
  }
}
