import 'package:flutter/material.dart';
import 'package:formation_flutter/api/pocketbase_api.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _stayConnected = false;
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showError('Veuillez remplir tous les champs.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await PocketBaseAPI().login(email, password);
      if (mounted) {
        context.go('/');
      }
    } catch (e) {
      if (mounted) {
        _showError('Email ou mot de passe incorrect.');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white, // Changed from greyBackground to match image
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 1,
        centerTitle: true,
        toolbarHeight: 54,
        leading: Padding(
          padding: const EdgeInsetsDirectional.only(start: 16.0),
          child: Icon(Icons.email_outlined, color: AppColors.black, size: 24),
        ),
        title: const Text(
          'Connexion',
          style: TextStyle(
            color: AppColors.blue, // Changed from green to Navy matching image
            fontFamily: 'Avenir',
            fontWeight: FontWeight.w900,
            fontSize: 17,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 12.0),
            child: IconButton(
              onPressed: () {},
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
              const SizedBox(height: 87),

              // Email field
              SizedBox(
                height: 50,
                child: TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email, color: AppColors.blue), // Added icon from image
                    hintText: 'Adresse email',
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
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12), // More rounded
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
              ),

              const SizedBox(height: 30),

              // Password field
              SizedBox(
                height: 50,
                child: TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock, color: AppColors.blue), // Added lock icon
                    hintText: 'Mot de passe',
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
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColors.greyPlaceholder,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
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
              ),

              const SizedBox(height: 22),

              // Stay connected checkbox
              Row(
                children: [
                  SizedBox(
                        width: 20,
                    height: 20,
                    child: Checkbox(
                      value: _stayConnected,
                      activeColor: AppColors.yellow,
                      onChanged: (value) {
                        setState(() => _stayConnected = value ?? false);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Rester connecté',
                    style: TextStyle(
                      color: AppColors.grey3,
                      fontFamily: 'Avenir',
                      fontSize: 14,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 70),

              // Create Account button (Top button in image)
              SizedBox(
                width: 275,
                height: 45,
                child: ElevatedButton(
                  onPressed: () => context.push('/register'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.yellow,
                    foregroundColor: AppColors.blue,
                    shape: const StadiumBorder(),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Créer un compte',
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

              const SizedBox(height: 20),

              // Login button (Bottom button in image)
              SizedBox(
                width: 275,
                height: 45,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _onLogin,
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
                              'Se connecter',
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
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
