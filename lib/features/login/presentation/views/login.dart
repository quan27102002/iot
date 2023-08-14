import 'package:bat_theme/bat_theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smarty/features/login/presentation/bloc/app_cubit.dart';
import 'package:smarty/features/login/presentation/bloc/auth_cubit.dart';
import 'package:smarty/features/login/presentation/bloc/auth_error.dart';
import 'package:smarty/features/login/presentation/bloc/auth_state.dart';

import '../../../../core/navigation/navigator.dart';

import '../../../../shared/res/res.dart';
import '../../../../shared/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  final TextEditingController _usernameController =
      TextEditingController(text: '');
  final _passwordController = TextEditingController(text: '');
  void _handleLoginButtonTap(BuildContext context) {
    print(
        "Login with ${_usernameController.text} - ${_passwordController.text} ");
    _login(context);
  }

  void _login(BuildContext context) async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    final authCubit = context.read<AuthCubit>();
    authCubit.login(username, password);
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

  void _navigatorHome(BuildContext context, user) {
    print("Navigate to main screen");
    // update app state
    final appCubit = context.read<AppCubit>();
    appCubit.authenticate(user, "token 12345678");
    AppNavigator.pushNamedAndClear(dashboardRoute);
  }

  void _hideLoadingDialog(BuildContext context) {
    Navigator.pop(context);
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
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = BatThemeData.of(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: theme.colors.background,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.h),
          child: BlocConsumer<AuthCubit, AuthState>(listener: (context, state) {
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
            if (state is AuthStateLoginSuccess) {
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
                  'Login to your account',
                  style: TextStyles.headline4.copyWith(
                      color: theme.colors.primary, fontWeight: FontWeight.w500),
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
                      controller: _usernameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter your email',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
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
                      controller: _passwordController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter your password',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 64.h),
                AppButtonPrimary(
                    label: 'Login',
                    onPressed: () {
                      _handleLoginButtonTap(context);
                    }),
                const Spacer(),
                RichText(
                  text: TextSpan(
                    text: 'Don\'t have an account? ',
                    style: theme.typography.bodyCopyMedium.copyWith(
                        color: theme.colors.tertiary.withOpacity(0.6)),
                    children: [
                      TextSpan(
                        text: 'Create account',
                        style: theme.typography.bodyCopyMedium
                            .copyWith(color: theme.colors.primary),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => AppNavigator.pushNamed(registerRoute),
                      ),
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
