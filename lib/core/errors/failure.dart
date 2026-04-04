import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? code;

  const Failure({required this.message, this.code});

  @override
  List<Object?> get props => [message, code];
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.code});
}

class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Failed to load cached data.'});
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'No internet connection. Please check your network.',
  });
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    super.message = 'Unauthorized. Please login again.',
    super.code = 401,
  });
}

class ForbiddenFailure extends Failure {
  const ForbiddenFailure({
    super.message = 'Access forbidden.',
    super.code = 403,
  });
}

class NotFoundFailure extends Failure {
  // renamed from NotFoundException
  const NotFoundFailure({
    super.message = 'Resource not found.',
    super.code = 404,
  });
}

class ValidationFailure extends Failure {
  final Map<String, dynamic>? errors;
  const ValidationFailure({
    super.message = 'Validation failed.',
    this.errors,
    super.code = 422,
  });

  @override
  List<Object?> get props => [message, code, errors];
}

class ConflictFailure extends Failure {
  const ConflictFailure({
    super.message = 'Resource already exists.',
    super.code = 409,
  });
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({super.message = 'Request timeout. Please try again.'});
}

class TooManyRequestsFailure extends Failure {
  const TooManyRequestsFailure({
    super.message = 'Too many requests. Please slow down.',
    super.code = 429,
  });
}

class UnknownFailure extends Failure {
  const UnknownFailure({super.message = 'An unexpected error occurred.'});
}
