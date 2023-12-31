// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:developer' as developer;

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:allergyp/util/cognito/user.dart';
import 'package:allergyp/util/cognito/user_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CognitoService {
  static final userPoolId = dotenv.env['USER_POOL_ID']!;
  static final clientId = dotenv.env['CLIENT_ID']!;

  static final userPool = CognitoUserPool(userPoolId, clientId);


  static Future<Map<String, dynamic>> login(
      String username, String password) async {
    final cognitoUser = CognitoUser(username, userPool);
    final authDetails = AuthenticationDetails(
      username: username,
      password: password,
    );
    CognitoUserSession? session;
    try {
      session = await cognitoUser.authenticateUser(authDetails);

      if (session != null) {
        User user = User.fromCognitoSession(session);
        UserPreferences().saveUser(user);
        developer.log("Successfully logged in");

        return {'status': true, 'message': 'Successful', 'user': user};
      } else {
        throw Exception('Session is null');
      }
    } on CognitoUserNewPasswordRequiredException catch (e) {
      print("An error occurred while authenticating user:  $e");
      return {
        'status': false,
        'message': 'New password required, please reset your password'
      };
    } on CognitoUserConfirmationNecessaryException catch (e) {
      print("An error occurred while authenticating user:  $e");
      return {
        'status': false,
        'message': 'Please confirm your email address.'
      };
    } on CognitoClientException catch (e) {
      print("An error occurred while authenticating user:  $e");
      if (e.code == 'UserNotConfirmedException') {
        await cognitoUser.resendConfirmationCode();
        return {
          'status': false,
          'message':
          'Account is unverified, please click the verification link sent to your email address.'
        };
      } else {
        return {
          'status': false,
          'message': 'Please ensure you entered the correct credentials.'
        };
      }
    } catch (e) {
      print("An error occurred while authenticating user:  $e");
      return {
        'status': false,
        'message':
        'Unsuccessful login, an unknown error occurred. Please try again.'
      };
    }
  }

  static Future<Map<String, dynamic>> signUp({
    required String username,
    required String password,
    required String fullName,
    required String email,
  }) async {
    final userAttributes = [
      AttributeArg(name: 'name', value: fullName),
      AttributeArg(name: 'email', value: email),
    ];
    CognitoUserPoolData data;
    try {
      data = await userPool.signUp(
        username,
        password,
        userAttributes: userAttributes,
      );
    } on CognitoClientException catch (e) {
      print("An error occurred while creating the user's account:  $e");
      if (e.message == 'User already exists') {
        return {
          'status': false,
          'message':
          'An account with the provided username already exists, please use a different username or login.'
        };
      }
    } catch (e) {
      print("An error occurred while creating the user's account:  $e");
      return {
        'status': false,
        'message': 'An error occurred while creating the account, please try again.'
      };
    }
    print("not bad news: data ");

    return {
      'status': true,
      'message':
      'Account created successfully, please click the verification link sent to your email address.'
    };
  }

  static Future<Map<String, dynamic>> passwordResetCode(
      {required String email}) async {
    final cognitoUser = CognitoUser(email, userPool);
    try {
      await cognitoUser.forgotPassword();
    } on CognitoClientException catch (e) {
      print("An error occurred while sending the password reset code:  $e");
      return {
        'status': false,
        'message': 'An error occurred while sending the password reset code, please try again.'
      };
    } catch (e) {
      print("An error occurred while sending the password reset code:  $e");
      return {
        'status': false,
        'message': 'An error occurred while sending the password reset code, please try again.'
      };
    }
    return {'status': true, 'message': 'A password reset code has been sent to your email.'};
  }

  static Future<Map<String, dynamic>> passwordReset(
      {required String email,
        required String code,
        required String password}) async {
    final cognitoUser = CognitoUser(email, userPool);
    bool passwordConfirmed = false;
    try {
      passwordConfirmed = await cognitoUser.confirmPassword(code, password);
    } on CognitoClientException catch (e) {
      print("An error occurred while resetting the password:  $e");
      return {
        'status': false,
        'message': 'Invalid verification code provided, please try again.'
      };
    } catch (e) {
      print("An error occurred while resetting the password:  $e");
      return {
        'status': false,
        'message': 'An error occurred while resetting the password, please try again.'
      };
    }
    print(passwordConfirmed);
    return {'status': true, 'message': 'Your password has been reset succesfully.'};
  }

  static Future<Map<String, dynamic>> refreshTokenIfExpired() async {
    User? userFromLocalStorage = await UserPreferences().getUser();

    if (userFromLocalStorage == null) {
      throw Exception('user is not found in localStorage is null');
    } else if (!isIdTokenExpired(userFromLocalStorage.idTokenExpiration)) {
      developer.log("Token is not expired, no need to refresh");
      return {'refreshed': false, 'user': userFromLocalStorage};
    }
    developer.log("Token is expired, refreshing...");

    final CognitoUser cognitoUser =
    CognitoUser(userFromLocalStorage.username, userPool);

    final session = await cognitoUser.refreshSession(
        CognitoRefreshToken(userFromLocalStorage.refreshToken));
    if (session != null) {
      User refreshedUser = User.fromCognitoSession(session);

      UserPreferences().saveUser(refreshedUser);
      return {'refreshed': true, 'user': refreshedUser};
    } else {
      throw Exception('Session is null');
    }
  }

  static bool isIdTokenExpired(int idTokenExpiration) {
    return DateTime.fromMillisecondsSinceEpoch(idTokenExpiration).isBefore(
      DateTime.now().add(
        const Duration(
            hours:
            1), //if token is going to expire in 1 hour, refresh it
      ),
    );
  }

  static Future<String?> getAuthToken() async {
    Map<String, dynamic> tokenMap = await refreshTokenIfExpired();
    if (tokenMap["user"] != null) {
      return tokenMap["user"].idToken;
    } else {
      return null;
    }
  }

  static Future<String?> getUserName() async {
    Map<String, dynamic> tokenMap = await refreshTokenIfExpired();
    if (tokenMap["user"] != null) {
      return tokenMap["user"].username;
    } else {
      return null;
    }
  }
}