import 'package:faxfy/feature/add_fax/data/repo/add_fax_repo.dart';
import 'package:faxfy/feature/add_fax/data/source/add_fax_data_source.dart';
import 'package:faxfy/feature/add_fax/domain/base_repo/base_add_fax_repo.dart';
import 'package:faxfy/feature/add_fax/domain/usecase/add_or_edit_fax_use_case.dart';
import 'package:faxfy/feature/add_fax/domain/usecase/get_address_fax_use_case.dart';
import 'package:faxfy/feature/add_fax/domain/usecase/get_all_fax_use_case.dart';
import 'package:faxfy/feature/add_fax/domain/usecase/get_fax_pdf_use_case.dart';
import 'package:faxfy/feature/add_fax/domain/usecase/get_index_last_fax_use_case.dart';
import 'package:faxfy/feature/add_fax/widgets/controller/add_fax_cubit.dart';
import 'package:faxfy/feature/auth/data/repo/auth_repository.dart';
import 'package:faxfy/feature/auth/data/source/auth_data_source.dart';
import 'package:faxfy/feature/auth/domain/usecase/login_use_case.dart';
import 'package:faxfy/feature/auth/widget/controller/auth_cubit.dart';
import 'package:faxfy/feature/calendar/controller/calendar_cubit.dart';
import 'package:faxfy/feature/fax_details/controller/fax_system_cubit.dart';
import 'package:faxfy/feature/view_fax/controller/FaxDetails_cubit.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

class ServiceLocator {
  Future<void> init() async {
    ///auth
    sl.registerFactory(() => LoginCubit(sl()));
    sl.registerLazySingleton<BaseAuthRemoteDataSource>(
      () => AuthRemoteDataSource(),
    );
    sl.registerLazySingleton<BaseAuthRepository>(() => AuthRepository(sl()));
    sl.registerLazySingleton(() => LoginUseCase(sl()));

    /// add or edit fax
    sl.registerFactory(() => AddFaxCubit(sl(), sl(), sl(),sl()));
    sl.registerLazySingleton<BaseAddFaxRemoteDataSource>(
      () => AddOrEditFaxRemoteDataSource(),
    );
    sl.registerLazySingleton<BaseAddFaxRepository>(() => AddFaxRepo(sl()));
    sl.registerLazySingleton(() => GetIndexLastFaxUseCase(sl()));
    sl.registerLazySingleton(() => GetAddressFaxUseCase(sl()));
    sl.registerLazySingleton(() => AddOrEditFaxUseCase(sl()));
    sl.registerLazySingleton(() => GetAllFaxUseCase(sl()));
    sl.registerLazySingleton(() => GetFaxPdfUseCase(sl()));

    ///calender
    sl.registerFactory(() => CalendarCubit(sl(), sl(), sl()));

    /// view faxs
    sl.registerFactory(() => FaxSystemCubit(sl()));
    sl.registerFactory(() => FaxDetailsCubit(sl(), sl()));
  }
}
