import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFF121312);
  static const Color primary = Color(0xFFF6BD00);
  static const Color fieldFill = Color(0xFF282A28);
  static const Color fieldBorder = Color(0xFF282A28);
  static const Color fieldBorderFocused = Color(0xFF2F80ED);
  static const Color textWhite = Colors.white;
  static const Color textGrey = Color(0xFF9E9E9E);
}

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  void _verifyEmail() {
    final email = _emailController.text.trim();

    if (!email.contains('@') || !email.contains('.')) {
      _showMessage('Enter a valid email');
      return;
    }

    _showMessage('Check your email to reset your password');
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
              const SizedBox(height: 16),

              // Header
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: AppColors.primary,
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Forget Password',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFF6BD00),
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),

              const SizedBox(height: 8),

              // Illustration
              SizedBox(
                width: double.infinity,
                height: 430,
                child: Image.asset(
                  'assets/images/forget_password.png',
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 24),

              _AuthTextField(
                controller: _emailController,
                hintText: 'Email',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 20),

              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _verifyEmail,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'Verify Email',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
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