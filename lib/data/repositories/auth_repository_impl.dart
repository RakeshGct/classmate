import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/firebase_auth_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource dataSource;

  AuthRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      print('Repository: Starting login...');
      final user = await dataSource.login(email, password);
      print('Repository: Login successful');
      return Right(user.toEntity());
    } catch (e) {
      print('Repository: Login failed - $e');
      return Left(AuthFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String fullName,
    required String studentId,
  }) async {
    try {
      print('Repository: Starting registration...');
      final user = await dataSource.register(
        email: email,
        password: password,
        fullName: fullName,
        studentId: studentId,
      );
      print('Repository: Registration successful');
      return Right(user.toEntity());
    } catch (e) {
      print('Repository: Registration failed - $e');
      return Left(AuthFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      print('Repository: Starting logout...');
      await dataSource.logout();
      print('Repository: Logout successful');
      return const Right(null);
    } catch (e) {
      print('Repository: Logout failed - $e');
      return Left(AuthFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      print('Repository: Getting current user...');
      final user = await dataSource.getCurrentUser();
      print('Repository: Current user retrieved - ${user.email}');
      return Right(user.toEntity());
    } catch (e) {
      print('Repository: Get current user failed - $e');
      return Left(AuthFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Stream<User?> get authStateChanges {
    print('Repository: Setting up auth state changes listener');
    return dataSource.authStateChanges.map((user) {
      if (user != null) {
        print('Repository: Auth state changed - user logged in: ${user.email}');
        return user.toEntity();
      } else {
        print('Repository: Auth state changed - user logged out');
        return null;
      }
    });
  }
}
