import 'package:logger/logger.dart';

final Logger logger = Logger(
  printer: PrettyPrinter(
    colors: true,
    printEmojis: true,
    methodCount: 1,
    errorMethodCount: 1,
  ),
);
