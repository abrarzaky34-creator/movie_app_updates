import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'register_screen.dart';
import 'forget_password_screens.dart';
import 'home_screen.dart' show HomeScreen;

class AppColors {
  static const Color background = Color(0xFF121312);
  static const Color primary = Color(0xFFF6BD00);
  static const Color fieldFill = Color(0xFF282A28);
  static const Color fieldBorder = Color(0xFF282A28);
  static const Color fieldBorderFocused = Color(0xFF2F80ED);
  static const Color textWhite = Colors.white;
  static const Color textGrey = Color(0xFF9E9E9E);
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _obscurePassword = true;
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (!email.contains('@') || !email.contains('.')) {
      _showMessage('Enter a valid email');
      return;
    }
    if (password.length < 8) {
      _showMessage('Password must be at least 8 characters');
      return;
    }

    setState(() => _loading = true);
    try {
      await _authService.login(email: email, password: password);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (e) {
      _showMessage(AuthService.messageFor(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loginWithGoogle() async {
    setState(() => _loading = true);
    try {
      final result = await _authService.loginWithGoogle();
      if (result == null) return;
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (e) {
      _showMessage(AuthService.messageFor(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _goToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterScreen()),
    );
  }

  void _goToForgetPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ForgetPasswordScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 67),
              Center(
                child: SizedBox(
                  width: 121,
                  height: 118,
                  child: ClipRect(
                    child: OverflowBox(
                      alignment: Alignment.center,
                      maxWidth: 240,
                      maxHeight: 240,
                      child: Image.asset(
                        'assets/images/splash_logo.png',
                        width: 240,
                        height: 240,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              _AuthTextField(
                controller: _emailController,
                hintText: 'Email',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              _AuthTextField(
                controller: _passwordController,
                hintText: 'Password',
                icon: Icons.lock_outline,
                obscureText: _obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.textWhite,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _goToForgetPassword,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(50, 30),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Forget Password ?',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      height: 1.2,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _loading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: _loading
                      ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.black,
                    ),
                  )
                      : const Text(
                    'Login',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: GestureDetector(
                  onTap: _goToRegister,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        height: 1.2,
                        color: AppColors.textWhite,
                      ),
                      children: [
                        TextSpan(text: "Don't Have Account ? "),
                        TextSpan(
                          text: 'Create One',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  const Expanded(
                    child: Divider(
                      color: AppColors.primary,
                      thickness: 1,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'OR',
                      style: TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Divider(
                      color: AppColors.primary,
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _loading ? null : _loginWithGoogle,
                  icon: const _GoogleIcon(),
                  label: const Text(
                    'Login With Google',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Center(
                child: _LanguageSwitch(),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;

  const _AuthTextField({
    required this.controller,
    required this.hintText,
    required this.icon,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(
          color: AppColors.textWhite,
          fontSize: 14,
        ),
        cursorColor: AppColors.primary,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.fieldFill,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: AppColors.textWhite,
            fontSize: 14,
          ),
          prefixIcon: Icon(
            icon,
            color: AppColors.textWhite,
            size: 20,
          ),
          suffixIcon: suffixIcon,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              color: AppColors.fieldBorder,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              color: AppColors.fieldBorder,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              color: AppColors.fieldBorderFocused,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}

class _GoogleIcon extends StatelessWidget {
  const _GoogleIcon();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'G',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 28,
        color: Colors.black,
      ),
    );
  }
}

class _LanguageSwitch extends StatefulWidget {
  const _LanguageSwitch();

  @override
  State<_LanguageSwitch> createState() => _LanguageSwitchState();
}

class _LanguageSwitchState extends State<_LanguageSwitch> {
  bool isEnglishSelected = true;

  void _changeLanguage(bool english) {
    setState(() {
      isEnglishSelected = english;
    });
  }

  @override
  Widget build(BuildContext context) {
    const double switchWidth = 130;
    const double switchHeight = 60;
    const double flagSize = 48;
    const double selectedCircleSize = 70;

    return SizedBox(
      width: switchWidth,
      height: switchHeight,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            border: Border.all(
              color: AppColors.primary,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                left: isEnglishSelected
                    ? -5
                    : switchWidth - selectedCircleSize + 5,
                top: (switchHeight - selectedCircleSize) / 2,
                child: Container(
                  width: selectedCircleSize,
                  height: selectedCircleSize,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                left: 5,
                top: 6,
                child: GestureDetector(
                  onTap: () => _changeLanguage(true),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/usa_flag.png',
                      width: flagSize,
                      height: flagSize,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 5,
                top: 6,
                child: GestureDetector(
                  onTap: () => _changeLanguage(false),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/egypt_flag.png',
                      width: flagSize,
                      height: flagSize,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}