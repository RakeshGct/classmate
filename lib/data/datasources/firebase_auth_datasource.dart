import 'package:classmate/data/models/user_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

abstract class FirebaseAuthDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register({
    required String email,
    required String password,
    required String fullName,
    required String studentId,
  });
  Future<void> logout();
  Future<UserModel> getCurrentUser();
  Stream<UserModel?> get authStateChanges;
}

class FirebaseAuthDataSourceImpl implements FirebaseAuthDataSource {
  final firebase_auth.FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  FirebaseAuthDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
  });

  // Helper method to safely get UID from Firebase Auth
  // This avoids the PigeonUserDetails error by waiting for auth state
  Future<String> _getUserIdSafely() async {
    // Wait for auth state to update
    await Future.delayed(const Duration(milliseconds: 300));

    // Try multiple times to get currentUser
    for (int i = 0; i < 5; i++) {
      final currentUser = firebaseAuth.currentUser;
      if (currentUser != null) {
        try {
          final uid = currentUser.uid;
          if (uid.isNotEmpty) {
            return uid;
          }
        } catch (e) {
          print('Attempt ${i + 1}: Error getting UID: $e');
          if (i < 4) {
            await Future.delayed(const Duration(milliseconds: 200));
          }
        }
      } else {
        await Future.delayed(const Duration(milliseconds: 200));
      }
    }

    throw Exception('Unable to get user ID after multiple attempts');
  }

  // Helper method to safely get user document
  Future<UserModel> _getUserFromFirestore(String uid, String email) async {
    try {
      final docRef = firestore.collection('users').doc(uid);
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null) {
          return UserModel.fromJson(data);
        }
      }

      // If document doesn't exist, create it
      print('Creating user document for $uid');
      final newUser = UserModel(
        uid: uid,
        email: email,
        fullName: email.split('@')[0], // Use email prefix as name
        studentId: uid.substring(0, 8).toUpperCase(),
        createdAt: DateTime.now(),
      );

      await docRef.set(newUser.toJson());
      return newUser;
    } catch (e) {
      print('Error getting user from Firestore: $e');
      rethrow;
    }
  }

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      print('Step 1: Attempting Firebase Authentication...');

      // Sign in with Firebase Auth
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      print(
        'Step 2: Firebase auth successful, waiting for user to be ready...',
      );

      // Get UID safely without accessing credential.user directly
      // This prevents the PigeonUserDetails error
      final uid = await _getUserIdSafely();
      print('Step 3: User UID obtained: $uid');

      print('Step 4: Fetching user data from Firestore...');
      final userModel = await _getUserFromFirestore(uid, email);

      print('Step 5: Login complete - ${userModel.email}');
      return userModel;
    } on firebase_auth.FirebaseAuthException catch (e) {
      print('Firebase Auth Error: ${e.code}');

      // Sign out if partially authenticated
      try {
        if (firebaseAuth.currentUser != null) {
          await firebaseAuth.signOut();
        }
      } catch (_) {}

      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No account found with this email';
          break;
        case 'wrong-password':
          message = 'Incorrect password';
          break;
        case 'invalid-email':
          message = 'Invalid email address';
          break;
        case 'user-disabled':
          message = 'This account has been disabled';
          break;
        case 'too-many-requests':
          message = 'Too many attempts. Try again later';
          break;
        case 'network-request-failed':
          message = 'Network error. Check your connection';
          break;
        default:
          message = e.message ?? 'Authentication failed';
      }
      throw Exception(message);
    } catch (e) {
      print('Login error: $e');

      // Sign out if partially authenticated
      try {
        if (firebaseAuth.currentUser != null) {
          await firebaseAuth.signOut();
        }
      } catch (_) {}

      throw Exception('Login failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> register({
    required String email,
    required String password,
    required String fullName,
    required String studentId,
  }) async {
    try {
      print('Step 1: Creating Firebase Auth account...');

      // Create user account
      await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      print(
        'Step 2: Firebase auth account created, waiting for user to be ready...',
      );

      // Get UID safely without accessing credential.user directly
      // This prevents the PigeonUserDetails error
      final uid = await _getUserIdSafely();
      print('Step 3: User UID obtained: $uid');

      print('Step 4: Creating user document in Firestore...');

      final user = UserModel(
        uid: uid,
        email: email,
        fullName: fullName,
        studentId: studentId,
        createdAt: DateTime.now(),
      );

      await firestore.collection('users').doc(uid).set(user.toJson());

      print('Step 5: Registration complete - ${user.email}');
      return user;
    } on firebase_auth.FirebaseAuthException catch (e) {
      print('Firebase Auth Error: ${e.code}');

      // Delete account if created but Firestore failed
      try {
        final currentUser = firebaseAuth.currentUser;
        if (currentUser != null) {
          await currentUser.delete();
        }
      } catch (_) {}

      String message;
      switch (e.code) {
        case 'weak-password':
          message = 'Password is too weak (min 6 characters)';
          break;
        case 'email-already-in-use':
          message = 'An account already exists with this email';
          break;
        case 'invalid-email':
          message = 'Invalid email address';
          break;
        case 'operation-not-allowed':
          message = 'Email/password sign-up is not enabled';
          break;
        case 'network-request-failed':
          message = 'Network error. Check your connection';
          break;
        default:
          message = e.message ?? 'Registration failed';
      }
      throw Exception(message);
    } catch (e) {
      print('Registration error: $e');

      // Delete account if created but Firestore failed
      try {
        final currentUser = firebaseAuth.currentUser;
        if (currentUser != null) {
          await currentUser.delete();
        }
      } catch (_) {}

      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await firebaseAuth.signOut();
      print('Logout successful');
    } catch (e) {
      print('Logout error: $e');
      throw Exception('Logout failed');
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final currentUser = firebaseAuth.currentUser;

      if (currentUser == null) {
        throw Exception('No user is currently logged in');
      }

      return await _getUserFromFirestore(
        currentUser.uid,
        currentUser.email ?? '',
      );
    } catch (e) {
      print('Get current user error: $e');
      throw Exception('Failed to get current user');
    }
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) {
        print('Auth state: User logged out');
        return null;
      }

      try {
        print('Auth state: User logged in - ${firebaseUser.uid}');
        return await _getUserFromFirestore(
          firebaseUser.uid,
          firebaseUser.email ?? '',
        );
      } catch (e) {
        print('Auth state error: $e');
        return null;
      }
    });
  }
}
