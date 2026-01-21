import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/auth/login_usecase.dart';
import '../../../domain/usecases/auth/logout_usecase.dart';
import '../../../domain/usecases/auth/register_usecase.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;
  final AuthRepository authRepository;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
    required this.authRepository,
  }) : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<LogoutEvent>(_onLogout);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);

    // Listen to auth state changes
    authRepository.authStateChanges.listen((user) {
      if (user != null && state is! AuthAuthenticated) {
        add(CheckAuthStatusEvent());
      } else if (user == null && state is! AuthUnauthenticated) {
        emit(AuthUnauthenticated());
      }
    });
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      final result = await loginUseCase(event.email, event.password);

      result.fold(
        (failure) {
          print('Login failure: ${failure.message}');
          emit(AuthError(failure.message));
        },
        (user) {
          print('Login success: ${user.email}');
          emit(AuthAuthenticated(user));
        },
      );
    } catch (e) {
      print('Login exception: $e');
      emit(AuthError('Login failed: $e'));
    }
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      final result = await registerUseCase(
        email: event.email,
        password: event.password,
        fullName: event.fullName,
        studentId: event.studentId,
      );

      result.fold(
        (failure) {
          print('Registration failure: ${failure.message}');
          emit(AuthError(failure.message));
        },
        (user) {
          print('Registration success: ${user.email}');
          emit(AuthAuthenticated(user));
        },
      );
    } catch (e) {
      print('Registration exception: $e');
      emit(AuthError('Registration failed: $e'));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      final result = await logoutUseCase();

      result.fold(
        (failure) {
          print('Logout failure: ${failure.message}');
          emit(AuthError(failure.message));
        },
        (_) {
          print('Logout success');
          emit(AuthUnauthenticated());
        },
      );
    } catch (e) {
      print('Logout exception: $e');
      emit(AuthError('Logout failed: $e'));
    }
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    print('Checking auth status...');
    emit(AuthLoading());

    try {
      // Get current user from repository
      final result = await authRepository.getCurrentUser();

      result.fold(
        (failure) {
          print('No user logged in: ${failure.message}');
          emit(AuthUnauthenticated());
        },
        (user) {
          print('User is logged in: ${user.email}');
          emit(AuthAuthenticated(user));
        },
      );
    } catch (e) {
      print('Check auth status error: $e');
      emit(AuthUnauthenticated());
    }
  }
}
