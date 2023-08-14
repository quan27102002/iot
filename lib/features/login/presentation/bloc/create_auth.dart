import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smarty/features/login/presentation/bloc/auth_error.dart';

import 'auth_state.dart';
class AuthCreate extends Cubit<AuthState> {
  AuthCreate() : super(AuthState.initial());
final FirebaseAuth _auth=FirebaseAuth.instance;

Future<void> register(String email,String passWorld)async{
  try{
    UserCredential userCredential=await _auth.createUserWithEmailAndPassword(email: email, password:passWorld);
    User? user=userCredential.user;
     emit(AuthStateRegistrationSuccess(user: user!));
  }
  on FirebaseAuthException catch (e) {
      emit(AuthStateFailure(error: AuthError.from(e)));
  }
}
}