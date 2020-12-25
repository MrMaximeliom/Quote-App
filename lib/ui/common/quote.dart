import 'package:beautiful/ui/common/database.dart';

class Quote {
  int id;
  String quoteText;
  String quoteAuthor;
  Quote({this.id, this.quoteText, this.quoteAuthor});
  Quote.fromMap(Map<String, dynamic> map) {
    id = map['_id'];
    quoteText = map['quote_text'];
    quoteAuthor = map['quote_author'];
  }

  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.id: id,
      DatabaseHelper.quoteText: quoteText,
      DatabaseHelper.quoteAuthor: quoteAuthor,
    };
  }
}
