import 'package:easy_extension/easy_extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:news_portal/api/auth_api.dart';
import 'package:news_portal/app/router/app_router.dart';
import 'package:news_portal/presentation/widgets/app_logo.dart';
import 'package:news_portal/presentation/widgets/app_scaffod.dart';
import 'package:news_portal/translations/app_trans.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    // 미리 선언
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // NOTE:
  void onLogin() async {
    // TOOD : 이메일, 패스워드 가져오기
    final email = _emailController.text;
    final password = _passwordController.text;

    debugPrint('이메일: $email');
    debugPrint('비밀번호: $password');

    // TOOD : 토큰 발행 API
    final auth = await AuthApi.login(email: email, password: password);

    if (auth == null) return;
    if (!mounted) return;

    context.goNamed(AppRoute.newsList.name);
  }

  TextField _textField({
    required TextEditingController controller,
    required String hintText,
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: hintText,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffod(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppLogo(),
              Container(
                height: 250,
                alignment: Alignment.center,
                child: Text(
                  AppTrans.login.welcome.tr(),
                  style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
                ),
              ),

              _textField(
                controller: _emailController,
                hintText: AppTrans.login.email.tr(),
              ),
              20.heightBox,

              _textField(
                controller: _passwordController,
                obscure: true,
                hintText: AppTrans.login.password.tr(),
              ),
              20.heightBox,

              SizedBox(
                height: 55,
                child: ElevatedButton(
                  onPressed: onLogin,
                  child: Text(AppTrans.login.login.tr()),
                ),
              ),

              Container(
                height: 70,
                alignment: Alignment.center,
                child: Row(
                  spacing: 10,
                  children: [
                    Expanded(child: Divider()),
                    Text(AppTrans.login.orUse.tr()),
                    Expanded(child: Divider()),
                  ],
                ),
              ),

              _buildSsoButton('Google'),
              10.heightBox,

              _buildSsoButton('Apple'),
              10.heightBox,
            ],
          ),
        ),
      ),
    );
  }

  OutlinedButton _buildSsoButton(String sso) {
    final logoUrl = {
      'Google':
          'https://api.apidog.com/api/v1/projects/866715/resources/354903/image-preview',
      'Apple':
          'https://api.apidog.com/api/v1/projects/866715/resources/354902/image-preview',
    };
    return OutlinedButton(
      onPressed: () {},
      child: Row(
        children: [
          Image.network(
            logoUrl[sso] ?? '',
            errorBuilder: (context, error, stackTrace) {
              return Icon(LucideIcons.x);
            },
          ),
          Expanded(
            child: Center(
              child: Text(
                AppTrans.login.signInWith.tr(namedArgs: {'sso': sso}),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
