import 'package:share_plus/share_plus.dart';

class ShareClass {
  static shareMethod({String message}) {

    Share.share(message);
  }
}
