import 'package:logger/logger.dart';

final logger = Logger(
  printer: PrettyPrinter(colors: false, methodCount: 0),
);

void traceLog(String message) {
  logger.t(message);
}

void debugLog(String message) {
  logger.d(message);
}

void infoLog(String message) {
  logger.i(message);
}

void warningLog(String message) {
  logger.w(message);
}

void errorLog(String message) {
  logger.e(message);
}

void fatalLog(String message) {
  logger.f(message);
}
