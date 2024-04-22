
import 'package:care_app_flutter/core/failure/failure.dart';

class ServerError extends Failure {
  final String message;

  ServerError({this.message = 'Server Error'}) : super(error: message);
}
