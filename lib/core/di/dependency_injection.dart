import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import '../networking/network_info.dart';
import '../networking/notification_remote_ds.dart';
import '../service/notification_service.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../events/event_bus.dart';
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
import '../../features/groups/data/remote/groups_remote_ds.dart';
import '../../features/groups/data/repo/groups_repo_impl.dart';
import '../../features/groups/domain/repo/groups_repo.dart';
import '../../features/groups/domain/use_cases/create_group_use_case.dart';
import '../../features/groups/domain/use_cases/get_active_group_id_use_case.dart';
import '../../features/groups/domain/use_cases/get_my_groups_use_case.dart';
import '../../features/groups/domain/use_cases/join_group_use_case.dart';
import '../../features/groups/domain/use_cases/set_active_group_use_case.dart';
import '../../features/groups/logic/cubit/groups_cubit.dart';
import '../../features/match_request/data/remote/match_request_remote_ds.dart';
import '../../features/match_request/data/repo/match_request_repo_impl.dart';
import '../../features/match_request/domain/repo/match_request_repo.dart';
import '../../features/match_request/domain/use_cases/approve_match_request_use_case.dart';
import '../../features/match_request/domain/use_cases/create_match_request_use_case.dart';
import '../../features/match_request/domain/use_cases/get_opponent_options_use_case.dart';
import '../../features/match_request/domain/use_cases/get_pending_requests_use_case.dart';
import '../../features/match_request/domain/use_cases/get_sent_requests_use_case.dart';
import '../../features/match_request/domain/use_cases/reject_match_request_use_case.dart';
import '../../features/match_request/logic/cubit/match_request_cubit.dart';
import '../../features/notification/data/remote/app_notification_remote_ds.dart';
import '../../features/notification/data/repo/notification_repo_impl.dart';
import '../../features/notification/domain/repo/notification_repo.dart';
import '../../features/notification/domain/use_cases/get_my_notifications_use_case.dart';
import '../../features/notification/domain/use_cases/mark_all_notifications_read_use_case.dart';
import '../../features/notification/domain/use_cases/mark_notification_read_use_case.dart';
import '../../features/notification/logic/cubit/notification_cubit.dart';
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
  getIt.registerLazySingleton<EventBus>(() => EventBus());

  // Remote Data Sources
  getIt.registerLazySingleton<StorageRemoteDs>(
    () => StorageRemoteDs(supabaseService: getIt<SupabaseService>()),
  );

  getIt.registerLazySingleton<UserRemoteDS>(
    () => UserRemoteDS(supabaseService: getIt<SupabaseService>()),
  );
  // 1. Register NotificationRemoteDs
  getIt.registerLazySingleton<NotificationRemoteDs>(
    () => NotificationRemoteDs(supabaseService: getIt<SupabaseService>()),
  );

  // 2. Register NotificationService
  getIt.registerLazySingleton<NotificationService>(
    () => NotificationService(
      notificationRemoteDs: getIt<NotificationRemoteDs>(),
    ),
  );
  getIt.registerLazySingleton<AuthRemoteDS>(
    () => AuthRemoteDS(
      notificationService: getIt<NotificationService>(),
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
  getIt.registerFactory<HomeCubit>(
    () => HomeCubit(
      repo: getIt<HomeRepo>(),
      getActiveGroupId: getIt<GetActiveGroupIdUseCase>(),
      eventBus: getIt<EventBus>(),
    ),
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
    () => MatchHistoryCubit(
      historyRepo: getIt<HistoryRepo>(),
      getActiveGroupId: getIt<GetActiveGroupIdUseCase>(),
      eventBus: getIt<EventBus>(),
    ),
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
    () => ChampionCubit(
      championRepo: getIt<ChampionRepo>(),
      getActiveGroupId: getIt<GetActiveGroupIdUseCase>(),
      eventBus: getIt<EventBus>(),
    ),
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
    () => ProfileCubit(
      profileRepo: getIt<ProfileRepo>(),
      getActiveGroupId: getIt<GetActiveGroupIdUseCase>(),
      eventBus: getIt<EventBus>(),
    ),
  );

  // ##### Notification Center Dependencies##################
  getIt.registerLazySingleton<AppNotificationRemoteDs>(
    () => AppNotificationRemoteDs(supabaseService: getIt<SupabaseService>()),
  );
  getIt.registerLazySingleton<NotificationRepo>(
    () => NotificationRepoImpl(
      remoteDs: getIt<AppNotificationRemoteDs>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );
  getIt.registerLazySingleton<GetMyNotificationsUseCase>(
    () => GetMyNotificationsUseCase(getIt<NotificationRepo>()),
  );
  getIt.registerLazySingleton<MarkNotificationReadUseCase>(
    () => MarkNotificationReadUseCase(getIt<NotificationRepo>()),
  );
  getIt.registerLazySingleton<MarkAllNotificationsReadUseCase>(
    () => MarkAllNotificationsReadUseCase(getIt<NotificationRepo>()),
  );
  // Lazy singleton: the same instance backs both the HomeAppBar unread
  // badge and the pushed NotificationsScreen route.
  getIt.registerLazySingleton<NotificationCubit>(
    () => NotificationCubit(
      getMyNotifications: getIt<GetMyNotificationsUseCase>(),
      markNotificationRead: getIt<MarkNotificationReadUseCase>(),
      markAllNotificationsRead: getIt<MarkAllNotificationsReadUseCase>(),
    ),
  );

  // ##### Groups Dependencies##################
  getIt.registerLazySingleton<GroupsRemoteDs>(
    () => GroupsRemoteDs(supabaseService: getIt<SupabaseService>()),
  );
  getIt.registerLazySingleton<GroupsRepo>(
    () => GroupsRepoImpl(
      remoteDs: getIt<GroupsRemoteDs>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );
  getIt.registerLazySingleton<GetMyGroupsUseCase>(
    () => GetMyGroupsUseCase(getIt<GroupsRepo>()),
  );
  getIt.registerLazySingleton<CreateGroupUseCase>(
    () => CreateGroupUseCase(getIt<GroupsRepo>()),
  );
  getIt.registerLazySingleton<JoinGroupUseCase>(
    () => JoinGroupUseCase(getIt<GroupsRepo>()),
  );
  getIt.registerLazySingleton<GetActiveGroupIdUseCase>(
    () => GetActiveGroupIdUseCase(getIt<GroupsRepo>()),
  );
  getIt.registerLazySingleton<SetActiveGroupUseCase>(
    () => SetActiveGroupUseCase(getIt<GroupsRepo>()),
  );
  // Lazy singleton (not a factory): active-group context must stay in sync
  // across every screen that reads it, not reset per navigation.
  getIt.registerLazySingleton<GroupsCubit>(
    () => GroupsCubit(
      getMyGroups: getIt<GetMyGroupsUseCase>(),
      createGroup: getIt<CreateGroupUseCase>(),
      joinGroup: getIt<JoinGroupUseCase>(),
      getActiveGroupId: getIt<GetActiveGroupIdUseCase>(),
      setActiveGroup: getIt<SetActiveGroupUseCase>(),
      eventBus: getIt<EventBus>(),
    ),
  );

  // ##### Match Request Dependencies##################
  getIt.registerLazySingleton<MatchRequestRemoteDs>(
    () => MatchRequestRemoteDs(supabaseService: getIt<SupabaseService>()),
  );
  getIt.registerLazySingleton<MatchRequestRepo>(
    () => MatchRequestRepoImpl(
      remoteDs: getIt<MatchRequestRemoteDs>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );
  getIt.registerLazySingleton<GetPendingRequestsUseCase>(
    () => GetPendingRequestsUseCase(getIt<MatchRequestRepo>()),
  );
  getIt.registerLazySingleton<GetSentRequestsUseCase>(
    () => GetSentRequestsUseCase(getIt<MatchRequestRepo>()),
  );
  getIt.registerLazySingleton<GetOpponentOptionsUseCase>(
    () => GetOpponentOptionsUseCase(getIt<MatchRequestRepo>()),
  );
  getIt.registerLazySingleton<CreateMatchRequestUseCase>(
    () => CreateMatchRequestUseCase(getIt<MatchRequestRepo>()),
  );
  getIt.registerLazySingleton<ApproveMatchRequestUseCase>(
    () => ApproveMatchRequestUseCase(getIt<MatchRequestRepo>()),
  );
  getIt.registerLazySingleton<RejectMatchRequestUseCase>(
    () => RejectMatchRequestUseCase(getIt<MatchRequestRepo>()),
  );
  // Lazy singleton: keeps its EventBus subscription alive for the whole
  // session, same rationale as GroupsCubit.
  getIt.registerLazySingleton<MatchRequestCubit>(
    () => MatchRequestCubit(
      getActiveGroupId: getIt<GetActiveGroupIdUseCase>(),
      getPendingRequests: getIt<GetPendingRequestsUseCase>(),
      getSentRequests: getIt<GetSentRequestsUseCase>(),
      getOpponentOptions: getIt<GetOpponentOptionsUseCase>(),
      createMatchRequest: getIt<CreateMatchRequestUseCase>(),
      approveMatchRequest: getIt<ApproveMatchRequestUseCase>(),
      rejectMatchRequest: getIt<RejectMatchRequestUseCase>(),
      eventBus: getIt<EventBus>(),
    ),
  );
}
