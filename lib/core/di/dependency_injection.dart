import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:im_legends/core/networking/network_info.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../features/add_match/data/remote/add_match_remote_ds.dart';
import '../../features/add_match/data/repo/add_match_repo.dart';
import '../../features/add_match/data/repo/add_match_repo_impl.dart';
import '../../features/add_match/logic/cubit/add_match_cubit.dart';
import '../../features/auth/data/remote/auth_remote_ds.dart';
import '../../features/auth/data/repo/auth_repo.dart';
import '../../features/auth/data/repo/auth_repo_impl.dart';
import '../../features/auth/logic/cubit/auth_cubit.dart';
import '../../features/champion/data/model/champion_stat_calculator.dart';
import '../../features/champion/data/remote/champion_remote_ds.dart';
import '../../features/champion/data/repo/champion_repo.dart';
import '../../features/champion/data/repo/champion_repo_impl.dart';
import '../../features/champion/logic/cubit/champion_cubit.dart';
import '../../features/history/data/remote/history_remote_ds.dart';
import '../../features/history/data/repo/history_repo.dart';
import '../../features/history/data/repo/history_repo_impl.dart';
import '../../features/history/logic/cubit/match_history_cubit.dart';
import '../../features/home/data/remote/home_remote_ds.dart';
import '../../features/home/data/repo/home_repo.dart';
import '../../features/home/data/repo/home_repo_impl.dart';
import '../../features/home/logic/cubit/home_cubit.dart';
import '../../features/profile/data/remote/profile_remote_ds.dart';
import '../../features/profile/data/repo/profile_repo.dart';
import '../../features/profile/data/repo/profile_repo_impl.dart';
import '../../features/profile/logic/cubit/profile_cubit.dart';
import '../networking/storage_remote_ds.dart';
import '../networking/supabase_service.dart';
import '../networking/user_remote_ds.dart';
import '../service/secure_storage.dart';

final getIt = GetIt.instance;

Future<void> setUpDependencies() async {
  final FlutterSecureStorage flutterSecureStorage =
      const FlutterSecureStorage();

  // SecureStorage
  if (!getIt.isRegistered<SecureStorage>()) {
    getIt.registerLazySingleton<SecureStorage>(
      () => SecureStorage(flutterSecureStorage),
    );
  }
  // Core
  getIt.registerLazySingleton<InternetConnectionChecker>(
    () => InternetConnectionChecker.createInstance(
      checkTimeout: const Duration(seconds: 5),
      checkInterval: const Duration(seconds: 3),
    ),
  );
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt()));
  getIt.registerLazySingleton<SupabaseService>(() => SupabaseService());

  // Remote Data Sources
  getIt.registerLazySingleton<StorageRemoteDs>(
    () => StorageRemoteDs(supabaseService: getIt<SupabaseService>()),
  );

  getIt.registerLazySingleton<UserRemoteDS>(
    () => UserRemoteDS(supabaseService: getIt<SupabaseService>()),
  );

  getIt.registerLazySingleton<AuthRemoteDS>(
    () => AuthRemoteDS(
      supabaseService: getIt<SupabaseService>(),
      secureStorage: getIt<SecureStorage>(),
      storageRemoteDS: getIt<StorageRemoteDs>(),
      userRemoteDS: getIt<UserRemoteDS>(),
    ),
  );
  getIt.registerLazySingleton<AuthRepo>(
    () => AuthRepoImpl(
      remoteDS: getIt<AuthRemoteDS>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );
  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(authRepo: getIt<AuthRepo>()),
  );

  //##### Home Dependencies ##################
  getIt.registerLazySingleton<HomeRemoteDs>(
    () => HomeRemoteDs(supabaseService: getIt<SupabaseService>()),
  );
  getIt.registerLazySingleton<HomeRepo>(
    () => HomeRepoImpl(
      remoteDs: getIt<HomeRemoteDs>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );
  getIt.registerFactory<HomeCubit>(() => HomeCubit(repo: getIt<HomeRepo>()));

  // ##### Add Match Dependencies##################
  getIt.registerLazySingleton<AddMatchRemoteDs>(
    () => AddMatchRemoteDs(supabaseService: getIt<SupabaseService>()),
  );
  getIt.registerLazySingleton<AddMatchRepo>(
    () => AddMatchRepoImpl(
      addMatchService: getIt<AddMatchRemoteDs>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );
  getIt.registerFactory<AddMatchCubit>(
    () => AddMatchCubit(addMatchRepo: getIt<AddMatchRepo>()),
  );
  // ##### Add History Dependencies##################
  getIt.registerLazySingleton<HistoryRemoteDs>(
    () => HistoryRemoteDs(supabaseService: getIt<SupabaseService>()),
  );
  getIt.registerLazySingleton<HistoryRepo>(
    () => HistoryRepoImpl(
      historyRemoteDs: getIt<HistoryRemoteDs>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );
  getIt.registerFactory<MatchHistoryCubit>(
    () => MatchHistoryCubit(historyRepo: getIt<HistoryRepo>()),
  );

  //  Champion Dependencies
  getIt.registerLazySingleton<ChampionRemoteDs>(
    () => ChampionRemoteDs(subbaseService: getIt<SupabaseService>()),
  );
  getIt.registerLazySingleton<ChampionRepo>(
    () => ChampionRepoImpl(
      championRemoteDs: getIt<ChampionRemoteDs>(),
      calculator: ChampionStatCalculator(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );
  getIt.registerFactory<ChampionCubit>(
    () => ChampionCubit(championRepo: getIt<ChampionRepo>()),
  );

  //  Profile Dependencies
  getIt.registerLazySingleton<ProfileRemoteDs>(
    () => ProfileRemoteDs(
      secureStorage: getIt<SecureStorage>(),
      supabaseService: getIt<SupabaseService>(),
      storageRemoteDS: getIt<StorageRemoteDs>(),
    ),
  );
  getIt.registerLazySingleton<ProfileRepo>(
    () => ProfileRepoImpl(
      profileRemoteDs: getIt<ProfileRemoteDs>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );
  getIt.registerFactory<ProfileCubit>(
    () => ProfileCubit(profileRepo: getIt<ProfileRepo>()),
  );

  // // Notification Dependencies
  // getIt.registerLazySingleton<NotificationRepo>(() => NotificationRepo());
  // getIt.registerFactory<NotificationsCubit>(
  //   () => NotificationsCubit(notificationRepo: getIt<NotificationRepo>()),
  // );
}
