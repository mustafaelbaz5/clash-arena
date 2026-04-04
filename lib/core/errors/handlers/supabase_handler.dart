import 'package:supabase_flutter/supabase_flutter.dart';

import '../exceptions.dart';

class SupabaseHandler {
  static AppException handle(final dynamic error) {
    if (error is AuthException) return _handleAuth(error);
    if (error is PostgrestException) return _handlePostgrest(error);
    if (error is StorageException) return _handleStorage(error);
    return ServerException(message: error.toString());
  }

  static AppException _handleAuth(final AuthException e) {
    final msg = e.message.toLowerCase();
    final code = int.tryParse(e.statusCode ?? '');

    if (msg.contains('invalid') &&
        (msg.contains('credentials') || msg.contains('password'))) {
      return UnauthorizedException(message: 'Invalid email or password.');
    }
    if (msg.contains('email') && msg.contains('already')) {
      return ConflictException(message: 'Email already registered.');
    }
    if (msg.contains('session') ||
        msg.contains('token') ||
        msg.contains('expired')) {
      return UnauthorizedException(
          message: 'Session expired. Please login again.');
    }
    if (msg.contains('too many') || msg.contains('rate limit')) {
      return TooManyRequestsException();
    }
    if (msg.contains('not found')) return NotFoundException();
    if (msg.contains('weak') || msg.contains('password')) {
      return ValidationException(message: 'Password is too weak.');
    }

    return _mapByCode(code, e.message);
  }

  static AppException _handlePostgrest(final PostgrestException e) {
    switch (e.code) {
      case '23505':
        return ConflictException(message: e.message);
      case '23503':
        return ServerException(message: e.message, statusCode: 400);
      case '23502':
      case '23514':
        return ValidationException(message: e.message);
      case '42501':
        return ForbiddenException(message: e.message);
      default:
        final code = int.tryParse(e.code ?? '');
        return _mapByCode(code, e.message);
    }
  }

  static AppException _handleStorage(final StorageException e) {
    final msg = e.message.toLowerCase();
    final code = int.tryParse(e.statusCode ?? '');

    if (msg.contains('not found')) return NotFoundException(message: e.message);
    if (msg.contains('too large') || msg.contains('size')) {
      return ValidationException(message: 'File is too large.');
    }
    if (msg.contains('permission') || msg.contains('unauthorized')) {
      return ForbiddenException(message: e.message);
    }

    return _mapByCode(code, e.message);
  }

  static AppException _mapByCode(final int? code, final String message) {
    switch (code) {
      case 400:
        return ServerException(message: message, statusCode: 400);
      case 401:
        return UnauthorizedException(message: message);
      case 403:
        return ForbiddenException(message: message);
      case 404:
        return NotFoundException(message: message);
      case 409:
        return ConflictException(message: message);
      case 422:
        return ValidationException(message: message);
      case 429:
        return TooManyRequestsException(message: message);
      case 500:
      case 502:
      case 503:
        return ServerException(message: message, statusCode: code);
      default:
        return ServerException(message: message);
    }
  }
}
