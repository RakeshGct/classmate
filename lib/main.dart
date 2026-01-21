// import 'package:classmate/presentation/bloc/auth/auth_event.dart';
// import 'package:classmate/presentation/bloc/auth/auth_state.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'core/constants/app_colors.dart';
// import 'core/constants/app_strings.dart';
// import 'injection_container.dart' as di;
// import 'presentation/bloc/auth/auth_bloc.dart';
// import 'presentation/bloc/attendance/attendance_bloc.dart';
// import 'presentation/bloc/assignment/assignment_bloc.dart';
// import 'presentation/screens/auth/login_screen.dart';
// import 'presentation/screens/home/home_screen.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   try {
//     await Firebase.initializeApp();
//     print('Firebase initialized successfully');
//   } catch (e) {
//     print('Firebase initialization error: $e');
//   }

//   await di.init();
//   print('Dependency injection initialized');

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(
//           create: (_) => di.sl<AuthBloc>()..add(CheckAuthStatusEvent()),
//         ),
//         BlocProvider(create: (_) => di.sl<AttendanceBloc>()),
//         BlocProvider(create: (_) => di.sl<AssignmentBloc>()),
//       ],
//       child: MaterialApp(
//         title: AppStrings.appName,
//         debugShowCheckedModeBanner: false,
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//           primaryColor: AppColors.primaryColor,
//           scaffoldBackgroundColor: AppColors.backgroundColor,
//           appBarTheme: const AppBarTheme(
//             backgroundColor: AppColors.primaryColor,
//             foregroundColor: Colors.white,
//             elevation: 0,
//           ),
//         ),
//         home: BlocBuilder<AuthBloc, AuthState>(
//           builder: (context, state) {
//             if (state is AuthAuthenticated) {
//               return const HomeScreen();
//             }
//             return const LoginScreen();
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/constants/app_colors.dart';
import 'core/constants/app_strings.dart';
import 'injection_container.dart' as di;
import 'presentation/bloc/auth/auth_bloc.dart';
import 'presentation/bloc/auth/auth_event.dart';
import 'presentation/bloc/auth/auth_state.dart';
import 'presentation/bloc/attendance/attendance_bloc.dart';
import 'presentation/bloc/assignment/assignment_bloc.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
    print('Firebase initialized successfully');
  } catch (e) {
    print('Firebase initialization error: $e');
  }

  await di.init();
  print('Dependency injection initialized');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<AuthBloc>()..add(CheckAuthStatusEvent()),
        ),
        BlocProvider(create: (_) => di.sl<AttendanceBloc>()),
        BlocProvider(create: (_) => di.sl<AssignmentBloc>()),
      ],
      child: MaterialApp(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: AppColors.primaryColor,
          scaffoldBackgroundColor: AppColors.backgroundColor,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}

// New wrapper to handle auth state properly
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        print('Auth state in wrapper: ${state.runtimeType}');

        if (state is AuthLoading || state is AuthInitial) {
          // Show loading screen while checking auth status
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primaryColor,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Loading...',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is AuthAuthenticated) {
          print('User authenticated: ${state.user.email}');
          return const HomeScreen();
        }

        print('User not authenticated, showing login');
        return const LoginScreen();
      },
    );
  }
}
