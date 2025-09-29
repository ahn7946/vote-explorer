import 'package:logger/logger.dart';

final Logger logger = Logger(
  printer: PrettyPrinter(
    colors: true,
    printEmojis: true,
    methodCount: 0,
    errorMethodCount: 2,
  ),
);
