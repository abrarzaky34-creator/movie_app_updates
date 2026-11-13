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

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;


  int _selectedAvatarIndex = 1;

  final List<String> _avatars = const [
    'assets/images/avatar_1.png',
    'assets/images/avatar_2.png',
    'assets/images/avatar_3.png',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  void _createAccount() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    final phone = _phoneController.text.trim();

    if (name.isEmpty) {
      _showMessage('Enter your name');
      return;
    }
    if (!email.contains('@') || !email.contains('.')) {
      _showMessage('Enter a valid email');
      return;
    }
    if (password.length < 8) {
      _showMessage('Password must be at least 8 characters');
      return;
    }
    if (confirmPassword != password) {
      _showMessage('Passwords do not match');
      return;
    }
    if (phone.length != 11) {
      _showMessage('Phone number must be 11 digits');
      return;
    }

    _showMessage('Account created');
    Navigator.of(context).pop();
  }

  void _goToLogin() {
    Navigator.of(context).pop();
  }

  void _changeLanguage(bool english) {}

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
                      'Register',
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

              const SizedBox(height: 20),


              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(_avatars.length, (index) {
                  final bool isSelected = index == _selectedAvatarIndex;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: _AvatarOption(
                      assetPath: _avatars[index],
                      isSelected: isSelected,
                      onTap: () {
                        setState(() {
                          _selectedAvatarIndex = index;
                        });
                      },
                    ),
                  );
                }),
              ),

              const SizedBox(height: 8),

              const Center(
                child: Text(
                  'Avatar',
                  style: TextStyle(
                    color: AppColors.textWhite,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              _AuthTextField(
                controller: _nameController,
                hintText: 'Name',
                icon: Icons.badge_outlined,
                keyboardType: TextInputType.name,
              ),

              const SizedBox(height: 16),

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

              const SizedBox(height: 16),

              _AuthTextField(
                controller: _confirmPasswordController,
                hintText: 'Confirm Password',
                icon: Icons.lock_outline,
                obscureText: _obscureConfirmPassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.textWhite,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
              ),

              const SizedBox(height: 16),

              _AuthTextField(
                controller: _phoneController,
                hintText: 'Phone Number',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 24),

              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _createAccount,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'Create Account',
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
                  onTap: _goToLogin,
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
                        TextSpan(text: 'Already Have Account ? '),
                        TextSpan(
                          text: 'Login',
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

              Center(
                child: _LanguageSwitch(
                  onChanged: _changeLanguage,
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

class _AvatarOption extends StatelessWidget {
  final String assetPath;
  final bool isSelected;
  final VoidCallback onTap;

  const _AvatarOption({
    required this.assetPath,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    final double size = isSelected ? 94 : 78;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected
              ? AppColors.fieldBorderFocused.withOpacity(0.25)
              : Colors.transparent,
          border: isSelected
              ? Border.all(
            color: AppColors.fieldBorderFocused,
            width: 2,
          )
              : null,
        ),
        padding: const EdgeInsets.all(4),
        child: Image.asset(
          assetPath,
          fit: BoxFit.contain,
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

class _LanguageSwitch extends StatefulWidget {
  final ValueChanged<bool>? onChanged;

  const _LanguageSwitch({this.onChanged});

  @override
  State<_LanguageSwitch> createState() => _LanguageSwitchState();
}

class _LanguageSwitchState extends State<_LanguageSwitch> {
  bool isEnglishSelected = true;

  void _changeLanguage(bool english) {
    setState(() {
      isEnglishSelected = english;
    });
    widget.onChanged?.call(english);
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