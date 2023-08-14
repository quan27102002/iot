import 'package:bat_theme/bat_theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smarty/features/login/presentation/bloc/auth_cubit.dart';

import 'package:smarty/features/login/presentation/bloc/auth_error.dart';
import 'package:smarty/features/login/presentation/bloc/create_auth.dart';

import '../../../../core/navigation/navigator.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../login/presentation/bloc/app_cubit.dart';
import '../../../login/presentation/bloc/auth_state.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);
  final TextEditingController _emailController =
      TextEditingController(text: '');
  final TextEditingController _passwordControler =
      TextEditingController(text: '');

  void _signUp(BuildContext context) async {
    final email = _emailController.text;
    final passWord = _passwordControler.text;
    final authCubit = context.read<AuthCreate>();
    authCubit.register(email, passWord);
  }

  void _hideLoadingDialog(BuildContext context) {
    Navigator.pop(context);
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: SizedBox(
            height: 100,
            width: 100,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, AuthError error) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(error.title),
          content: Text(error.message),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _navigatorHome(BuildContext context, user) {
    print("Navigate to main screen");
    // update app state
    final appCubit = context.read<AppCubit>();
    appCubit.authenticate(user, "token 12345678");
    AppNavigator.pushNamedAndClear(loginRoute);
  }

  @override
  Widget build(BuildContext context) {
    var theme = BatThemeData.of(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: theme.colors.background,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.h),
          child:
              BlocConsumer<AuthCreate, AuthState>(listener: (context, state) {
            // debugPrint(state.toString());
            if (state is AuthStateInProgress) {
              print(" ==== LOAding");
              _showLoadingDialog(context);
            }
            if (state is AuthStateFailure) {
              _hideLoadingDialog(context);
              print('1');
              _showErrorDialog(context, state.error!);
              print('1');
            }
            if (state is AuthStateRegistrationSuccess) {
              print("aaaaa");
              _hideLoadingDialog(context);
              _navigatorHome(context, state.user!);
            }
          }, builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 109.h),
                Image.asset("assets/images/logo.png",
                    color: theme.colors.primary, width: 174.w),
                SizedBox(height: 64.h),
                Text(
                  'Create an account',
                  style: theme.typography.headline4
                      .copyWith(color: theme.colors.primary),
                ),
                SizedBox(height: 48.h),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email',
                      style: theme.typography.bodyCopyMedium
                          .copyWith(color: theme.colors.tertiary),
                    ),
                    SizedBox(height: 8.h),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter your email',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Password',
                      style: theme.typography.bodyCopyMedium
                          .copyWith(color: theme.colors.tertiary),
                    ),
                    SizedBox(height: 8.h),
                    TextField(
                      controller: _passwordControler,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter your password',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 64.h),
                AppButtonPrimary(
                    label: 'Sign up',
                    onPressed: () {
                      _signUp(context);
                    }),
                const Spacer(),
                RichText(
                  text: TextSpan(
                    text: 'Already have an account? ',
                    style: theme.typography.bodyCopyMedium.copyWith(
                        color: theme.colors.tertiary.withOpacity(0.6)),
                    children: [
                      TextSpan(
                          text: 'Log in',
                          style: theme.typography.bodyCopyMedium
                              .copyWith(color: theme.colors.primary),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              AppNavigator.pushNamed(loginRoute);
                            }),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).padding.bottom * 2),
              ],
            );
          }),
        ));
  }
}
