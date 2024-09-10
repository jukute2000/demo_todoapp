import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  Future<String> createdAccount(String email, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return "Account Created";
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password") {
        return "Weak Password";
      } else if (e.code == "email-alrealy-in-use") {
        return "Email alrealy exist Login Please !";
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
      if (e.code == "user-not-found") {
        return "Email id dose not exist";
      } else if (e.code == "wrong-password") {
        return "Wrong password";
      }
      return e.code;
    } catch (ex) {
      return "$ex";
    }
  }
}
