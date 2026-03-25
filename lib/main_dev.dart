import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:im_legends/core/config/app_config.dart';
import 'package:im_legends/core/config/firebase_options.dart';
import 'package:im_legends/core/di/dependency_injection.dart';
import 'package:im_legends/core/localization/localization_manager.dart';
import 'package:im_legends/core/widgets/error_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'im_legends_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  ErrorWidget.builder = (final details) => const ErrorScreen();
  await EasyLocalization.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );

  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
  );
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setUpDependencies();

  runApp(
    EasyLocalization(
      supportedLocales: LocalizationManager.supportedLocales,
      path: LocalizationManager.translationsPath,
      fallbackLocale: LocalizationManager.fallbackLocale,
      startLocale: LocalizationManager.fallbackLocale,
      child: const IMLegendsApp(),
    ),
  );
}
