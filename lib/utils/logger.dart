import 'package:logger/logger.dart';

final logger = Logger();

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
