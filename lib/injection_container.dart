// import 'package:classmate/domain/usecases/assignment/get_assignment_usecase.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:get_it/get_it.dart';

// import 'data/datasources/firebase_auth_datasource.dart';
// import 'data/datasources/firestore_assignment_datasource.dart';
// import 'data/datasources/firestore_attendance_datasource.dart';
// import 'data/repositories/assignment_repository_impl.dart';
// import 'data/repositories/attendance_repository_impl.dart';
// import 'data/repositories/auth_repository_impl.dart';
// import 'domain/repositories/assignment_repository.dart';
// import 'domain/repositories/attendance_repository.dart';
// import 'domain/repositories/auth_repository.dart';

// import 'domain/usecases/assignment/submit_assignment_usecase.dart';
// import 'domain/usecases/assignment/upload_assignment_usecase.dart';
// import 'domain/usecases/attendance/get_attendance_by_date_usecase.dart';
// import 'domain/usecases/attendance/get_attendance_history_usecase.dart';
// import 'domain/usecases/attendance/mark_attendance_usecase.dart';
// import 'domain/usecases/auth/login_usecase.dart';
// import 'domain/usecases/auth/logout_usecase.dart';
// import 'domain/usecases/auth/register_usecase.dart';
// import 'presentation/bloc/assignment/assignment_bloc.dart';
// import 'presentation/bloc/attendance/attendance_bloc.dart';
// import 'presentation/bloc/auth/auth_bloc.dart';

// final sl = GetIt.instance;

// Future<void> init() async {
//   // Bloc
//   sl.registerFactory(
//     () => AuthBloc(
//       loginUseCase: sl(),
//       registerUseCase: sl(),
//       logoutUseCase: sl(),
//     ),
//   );

//   sl.registerFactory(
//     () => AttendanceBloc(
//       markAttendanceUseCase: sl(),
//       getAttendanceByDateUseCase: sl(),
//       getAttendanceHistoryUseCase: sl(),
//     ),
//   );

//   sl.registerFactory(
//     () => AssignmentBloc(
//       getAssignmentsUseCase: sl(),
//       uploadAssignmentUseCase: sl(),
//       submitAssignmentUseCase: sl(),
//     ),
//   );

//   // Use cases - Auth
//   sl.registerLazySingleton(() => LoginUseCase(sl()));
//   sl.registerLazySingleton(() => RegisterUseCase(sl()));
//   sl.registerLazySingleton(() => LogoutUseCase(sl()));

//   // Use cases - Attendance
//   sl.registerLazySingleton(() => MarkAttendanceUseCase(sl()));
//   sl.registerLazySingleton(() => GetAttendanceByDateUseCase(sl()));
//   sl.registerLazySingleton(() => GetAttendanceHistoryUseCase(sl()));

//   // Use cases - Assignment
//   sl.registerLazySingleton(() => GetAssignmentsUseCase(sl()));
//   sl.registerLazySingleton(() => UploadAssignmentUseCase(sl()));
//   sl.registerLazySingleton(() => SubmitAssignmentUseCase(sl()));

//   // Repository
//   sl.registerLazySingleton<AuthRepository>(
//     () => AuthRepositoryImpl(dataSource: sl()),
//   );

//   sl.registerLazySingleton<AttendanceRepository>(
//     () => AttendanceRepositoryImpl(dataSource: sl()),
//   );

//   sl.registerLazySingleton<AssignmentRepository>(
//     () => AssignmentRepositoryImpl(dataSource: sl()),
//   );

//   // Data sources
//   sl.registerLazySingleton<FirebaseAuthDataSource>(
//     () => FirebaseAuthDataSourceImpl(firebaseAuth: sl(), firestore: sl()),
//   );

//   sl.registerLazySingleton<FirestoreAttendanceDataSource>(
//     () => FirestoreAttendanceDataSourceImpl(firestore: sl()),
//   );

//   sl.registerLazySingleton<FirestoreAssignmentDataSource>(
//     () => FirestoreAssignmentDataSourceImpl(firestore: sl(), storage: sl()),
//   );

//   // External
//   sl.registerLazySingleton(() => FirebaseAuth.instance);
//   sl.registerLazySingleton(() => FirebaseFirestore.instance);
//   sl.registerLazySingleton(() => FirebaseStorage.instance);
// }

import 'package:classmate/domain/usecases/assignment/get_assignment_usecase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';

import 'data/datasources/firebase_auth_datasource.dart';
import 'data/datasources/firestore_assignment_datasource.dart';
import 'data/datasources/firestore_attendance_datasource.dart';
import 'data/repositories/assignment_repository_impl.dart';
import 'data/repositories/attendance_repository_impl.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/repositories/assignment_repository.dart';
import 'domain/repositories/attendance_repository.dart';
import 'domain/repositories/auth_repository.dart';

import 'domain/usecases/assignment/submit_assignment_usecase.dart';
import 'domain/usecases/assignment/upload_assignment_usecase.dart';
import 'domain/usecases/attendance/get_attendance_by_date_usecase.dart';
import 'domain/usecases/attendance/get_attendance_history_usecase.dart';
import 'domain/usecases/attendance/mark_attendance_usecase.dart';
import 'domain/usecases/auth/login_usecase.dart';
import 'domain/usecases/auth/logout_usecase.dart';
import 'domain/usecases/auth/register_usecase.dart';
import 'presentation/bloc/assignment/assignment_bloc.dart';
import 'presentation/bloc/attendance/attendance_bloc.dart';
import 'presentation/bloc/auth/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      registerUseCase: sl(),
      logoutUseCase: sl(),
      authRepository: sl(), // Added this
    ),
  );

  sl.registerFactory(
    () => AttendanceBloc(
      markAttendanceUseCase: sl(),
      getAttendanceByDateUseCase: sl(),
      getAttendanceHistoryUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => AssignmentBloc(
      getAssignmentsUseCase: sl(),
      uploadAssignmentUseCase: sl(),
      submitAssignmentUseCase: sl(),
    ),
  );

  // Use cases - Auth
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));

  // Use cases - Attendance
  sl.registerLazySingleton(() => MarkAttendanceUseCase(sl()));
  sl.registerLazySingleton(() => GetAttendanceByDateUseCase(sl()));
  sl.registerLazySingleton(() => GetAttendanceHistoryUseCase(sl()));

  // Use cases - Assignment
  sl.registerLazySingleton(() => GetAssignmentsUseCase(sl()));
  sl.registerLazySingleton(() => UploadAssignmentUseCase(sl()));
  sl.registerLazySingleton(() => SubmitAssignmentUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(dataSource: sl()),
  );

  sl.registerLazySingleton<AttendanceRepository>(
    () => AttendanceRepositoryImpl(dataSource: sl()),
  );

  sl.registerLazySingleton<AssignmentRepository>(
    () => AssignmentRepositoryImpl(dataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<FirebaseAuthDataSource>(
    () => FirebaseAuthDataSourceImpl(firebaseAuth: sl(), firestore: sl()),
  );

  sl.registerLazySingleton<FirestoreAttendanceDataSource>(
    () => FirestoreAttendanceDataSourceImpl(firestore: sl()),
  );

  sl.registerLazySingleton<FirestoreAssignmentDataSource>(
    () => FirestoreAssignmentDataSourceImpl(firestore: sl(), storage: sl()),
  );

  // External
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => FirebaseStorage.instance);
}
