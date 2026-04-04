enum Environment { development, production }

class AppConfig {
  const AppConfig._();

  // Environment — driven by --dart-define at compile time
  static const String _env = String.fromEnvironment(
    'ENV',
    defaultValue: 'development',
  );

  static Environment get environment =>
      _env == 'production' ? Environment.production : Environment.development;

  static bool get isProduction => environment == Environment.production;
  static bool get isDevelopment => environment == Environment.development;
  static bool get enableLogging => !isProduction;

  // App Info
  static const String appName = String.fromEnvironment(
    'APP_NAME',
    defaultValue: 'IMLegend Dev',
  );
  static const String appVersion = '1.0.7';
  static const String buildNumber = '8';

  // Developer Info
  static const String developerName = 'Mustafa Elbaz';
  static const String developerGithub = 'https://github.com/mustafaelbaz5';
  static const String developerProfile =
      'https://mustafa-portfolio-eight.vercel.app/';
  static const String developerLinkedIn =
      'https://www.linkedin.com/in/mustafa-elbaz-725a6631a';
  static const String developerEmail = 'm9stafa05@gmail.com';

  // API
  static const String supabaseUrl = 'https://flutiryhpfdlpizyxqix.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZsdXRpcnlocGZkbHBpenl4cWl4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTYxNTQ3NzIsImV4cCI6MjA3MTczMDc3Mn0.UhojXOtOrnvbwDKvyBVZn3Cl1gdUkr-NYuGBLQXIRi0';
}
