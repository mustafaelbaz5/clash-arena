import 'package:im_legends/core/errors/failure.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'exceptions.dart';
import 'handlers/supabase_handler.dart';

class ErrorHandler {
  /// Call this in your data sources — throws AppException
  static Never handleException(final dynamic error) {
    if (error is AppException) throw error;

    if (error is AuthException ||
        error is PostgrestException ||
        error is StorageException) {
      throw SupabaseHandler.handle(error);
    }

    // Future: FirebaseHandler.handle(error)
    // Future: ApiHandler.handle(error)

    throw ServerException(message: error?.toString() ?? 'Unknown error.');
  }

  /// Call this in your repositories — converts exception to Failure
  static Failure handleFailure(final dynamic error) {
    if (error is Failure) return error;
    final exception = error is AppException ? error : _toException(error);
    return _toFailure(exception);
  }

  static AppException _toException(final dynamic error) {
    if (error is AuthException ||
        error is PostgrestException ||
        error is StorageException) {
      return SupabaseHandler.handle(error);
    }
    return ServerException(message: error?.toString() ?? 'Unknown error.');
  }

  static Failure _toFailure(final AppException e) {
    if (e is UnauthorizedException) {
      return UnauthorizedFailure(message: e.message);
    }
    if (e is ForbiddenException) return ForbiddenFailure(message: e.message);
    if (e is NotFoundException) return NotFoundFailure(message: e.message);
    if (e is ValidationException) {
      return ValidationFailure(message: e.message, errors: e.errors);
    }
    if (e is ConflictException) return ConflictFailure(message: e.message);
    if (e is NetworkException) return NetworkFailure(message: e.message);
    if (e is RequestTimeoutException) return TimeoutFailure(message: e.message);
    if (e is TooManyRequestsException) {
      return TooManyRequestsFailure(message: e.message);
    }
    if (e is CacheException) return CacheFailure(message: e.message);
    if (e is ServerException) {
      return ServerFailure(message: e.message, code: e.statusCode);
    }
    return const UnknownFailure();
  }
}
