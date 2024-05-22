import 'dart:html' deferred as html;

import 'package:club_model/club_model.dart';

Future<void> checkPageLoad() async {
  MyPrint.printOnConsole("Loading Library:${DateFormat("dd/MM/yyyy hh:mm:ss.SSS aa").format(DateTime.now())}");
  await html.loadLibrary();
  MyPrint.printOnConsole("Loaded Library:${DateFormat("dd/MM/yyyy hh:mm:ss.SSS aa").format(DateTime.now())}");

  var myElement = html.querySelector('#datetime');
  String? innerText = myElement?.innerHtml;
  MyPrint.printOnConsole("myElement:$myElement");
  MyPrint.printOnConsole("innerText:$innerText");

  DateTime? parsedHtmlTime = ParsingHelper.parseDateTimeMethod(innerText);
  MyPrint.printOnConsole("parsed datetime:${parsedHtmlTime != null ? DateFormat("dd/MM/yyyy hh:mm:ss.SSS aa").format(parsedHtmlTime) : null}");

  DateTime now = DateTime.now();
  MyPrint.printOnConsole("Current Time in main.dart:${DateFormat("dd/MM/yyyy hh:mm:ss.SSS aa").format(now)}");

  if (parsedHtmlTime != null) {
    Duration difference = now.difference(parsedHtmlTime);
    MyPrint.printOnConsole("Took ${difference.inMilliseconds / 1000} Seconds to Load Dart Code");
  }
}
