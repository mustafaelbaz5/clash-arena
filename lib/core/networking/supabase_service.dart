import 'package:im_legends/core/errors/exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static const _timeout = Duration(seconds: 15);

  SupabaseClient get client => Supabase.instance.client;
  User? get currentUser => client.auth.currentUser;

  Future<void> signOut() => execute(client.auth.signOut());

  Future<T> execute<T>(final Future<T> future) {
    return future.timeout(
      _timeout,
      onTimeout: () => throw RequestTimeoutException(),
    );
  }
}
