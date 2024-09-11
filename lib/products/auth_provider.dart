import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  Future<String> createdAccount(
      String email, String password, String name) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await FirebaseAuth.instance.currentUser!.updateDisplayName(name);
      return "Account Created";
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        return "Email account already exists.";
      } else if (e.code == "invalid-email") {
        return "The email address is not valid.";
      } else if (e.code == "weak-password") {
        return "The password is not strong enough.";
      } else if (e.code == "too-many-requests") {
        return "Too many user requests, please wait a while.";
      } else if (e.code == "network-request-failed") {
        return "User not connected to internet";
      }
      return e.code;
    } catch (ex) {
      return "$ex";
    }
  }

  Future<String> loginedAcount(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return "Login account";
    } on FirebaseException catch (e) {
      if (e.code == "invalid-credential" || e.code == "wrong-password") {
        return "Invalid email password or invalid account";
      } else if (e.code == "invalid-email") {
        return "Invalid email address";
      } else if (e.code == "user-disabled") {
        return "Email address has been disabled";
      } else if (e.code == "user-not-found") {
        return "No corresponding email";
      } else if (e.code == "too-many-requests") {
        return "User sending too many requests";
      } else if (e.code == "network-request-failed") {
        return "User is not connected to the internet";
      }
      return e.code;
    } catch (ex) {
      return "$ex";
    }
  }
}
