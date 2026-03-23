import 'package:flutter/material.dart';
import 'package:formation_flutter/api/pocketbase_api.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _acceptConditions = false;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _firstNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _onRegister() async {
    final name = _nameController.text.trim();
    final firstName = _firstNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (name.isEmpty ||
        firstName.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showError('Veuillez remplir tous les champs.');
      return;
    }

    if (password != confirmPassword) {
      _showError('Les mots de passe ne correspondent pas.');
      return;
    }

    if (password.length < 8) {
      _showError('Le mot de passe doit contenir au moins 8 caractères.');
      return;
    }

    if (!_acceptConditions) {
      _showError("Veuillez accepter les conditions d'utilisation.");
      return;
    }

    setState(() => _isLoading = true);

    try {
      await PocketBaseAPI().register(
        name: '$firstName $name',
        email: email,
        password: password,
        passwordConfirm: confirmPassword,
      );

      // Auto-login after registration
      await PocketBaseAPI().login(email, password);

      if (mounted) {
        context.go('/');
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = "Erreur lors de l'inscription.";
        if (e.toString().contains('validation_invalid_email')) {
          errorMessage = 'Adresse email invalide.';
        } else if (e.toString().contains('validation_not_unique')) {
          errorMessage = 'Un compte avec cet email existe déjà.';
        }
        _showError(errorMessage);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    IconData? prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
    bool obscure = true,
    VoidCallback? onToggleObscure,
  }) {
    return SizedBox(
      height: 50,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: isPassword ? obscure : false,
        decoration: InputDecoration(
          prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: AppColors.blue) : null,
          hintText: hint,
          hintStyle: TextStyle(
            color: AppColors.greyPlaceholder,
            fontFamily: 'Avenir',
            fontSize: 14,
          ),
          filled: true,
          fillColor: AppColors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 15,
          ),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscure ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.greyPlaceholder,
                    size: 20,
                  ),
                  onPressed: onToggleObscure,
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.greyBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.greyBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.yellow),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 1,
        centerTitle: true,
        toolbarHeight: 54,
        automaticallyImplyLeading: false,
        title: const Text(
          "S'inscrire",
          style: TextStyle(
            color: AppColors.blue,
            fontFamily: 'Avenir',
            fontWeight: FontWeight.w900,
            fontSize: 17,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 12.0),
            child: IconButton(
              onPressed: () => context.pop(),
              icon: Icon(Icons.close, color: AppColors.blue, size: 28),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 49),

              // Nom field
              _buildTextField(
                controller: _nameController,
                hint: 'Nom',
                prefixIcon: Icons.person_outline,
              ),

              const SizedBox(height: 20),

              // Prénom field
              _buildTextField(
                controller: _firstNameController,
                hint: 'Prénom',
                prefixIcon: Icons.person_outline,
              ),

              const SizedBox(height: 20),

              // Email field
              _buildTextField(
                controller: _emailController,
                hint: 'Email',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 20),

              // Password field
              _buildTextField(
                controller: _passwordController,
                hint: 'Mot de passe',
                prefixIcon: Icons.lock_outline,
                isPassword: true,
                obscure: _obscurePassword,
                onToggleObscure: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
              ),

              const SizedBox(height: 20),

              // Confirm password field
              _buildTextField(
                controller: _confirmPasswordController,
                hint: 'Confirmation mot de passe',
                prefixIcon: Icons.lock_outline,
                isPassword: true,
                obscure: _obscureConfirmPassword,
                onToggleObscure: () {
                  setState(() =>
                      _obscureConfirmPassword = !_obscureConfirmPassword);
                },
              ),

              const SizedBox(height: 20),

              // Conditions checkbox
              Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: Checkbox(
                      value: _acceptConditions,
                      activeColor: AppColors.yellow,
                      onChanged: (value) {
                        setState(() => _acceptConditions = value ?? false);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "J'accepte les conditions d'utilisation",
                      style: TextStyle(
                        color: AppColors.grey3,
                        fontFamily: 'Avenir',
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 90),

              // Register button
              SizedBox(
                width: 275,
                height: 45,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _onRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.yellow,
                    foregroundColor: AppColors.blue,
                    shape: const StadiumBorder(),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(AppColors.blue),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "S'inscrire",
                              style: TextStyle(
                                fontFamily: 'Avenir',
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward, size: 20),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 30),

              // Already have an account link
              GestureDetector(
                onTap: () => context.pop(),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      fontSize: 14,
                    ),
                    children: [
                      TextSpan(
                        text: 'Déjà un compte ? ',
                        style: TextStyle(color: AppColors.grey3),
                      ),
                      TextSpan(
                        text: 'Se connecter',
                        style: TextStyle(
                          color: AppColors.blueLink,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 50),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
