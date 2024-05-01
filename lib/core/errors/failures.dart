import 'package:equatable/equatable.dart';
import 'package:uniberry2/core/errors/exceptions.dart';

abstract class Failure extends Equatable {
  Failure({required this.message, required this.statusCode})
      : assert(
          statusCode is String || statusCode is int,
          'StatusCode cannot be a ${statusCode.runtimeType}',
        );

  final String message;
  final dynamic statusCode;

  String get errorMessage =>
      '$statusCode ${statusCode is String ? '' : 'Error'} Error: $message';

  @override
  List<dynamic> get props => [message, statusCode];
}

class ServerFailure extends Failure {
  ServerFailure({required super.message, required super.statusCode});

  ServerFailure.fromException(ServerException exception)
      : this(message: exception.message, statusCode: exception.statusCode);
}

class CacheFailure extends Failure {
  CacheFailure({required super.message, required super.statusCode});
}
