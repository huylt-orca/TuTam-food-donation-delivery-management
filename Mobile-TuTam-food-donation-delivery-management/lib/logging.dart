import 'package:logger/logger.dart';

final logger = Logger();
// https://www.youtube.com/watch?v=GUi0n9c33os
// final logger = Logger(printer: CustomerPrinter());

// class CustomerPrinter extends LogPrinter {
//   @override
//   List<String> log(LogEvent event) {
//     final color = PrettyPrinter.defaultLevelColors[event.level];
//     final emoji = PrettyPrinter.defaultLevelEmojis[event.level];
//     final message = event.message;

//     return [color!('$emoji: $message')];
//   }

// }