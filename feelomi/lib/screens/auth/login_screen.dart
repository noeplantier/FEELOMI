import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/validators.dart';
import '../../utils/routes.dart';
import '../../widgets/common/feelomi_button.dart';
import '../../widgets/common/feelomi_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    _setLoading(true);
    
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.signInWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text,
      );
      
      if (success && mounted) {
        Navigator.pushReplacementNamed(context, Routes.home);
      }
    } catch (e) {
      _showErrorDialog('Échec de connexion', 'Veuillez vérifier vos identifiants et réessayer.');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _handleGoogleSignIn() async {
    _setLoading(true);
    
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.signInWithGoogle();
      
      if (success && mounted) {
        Navigator.pushReplacementNamed(context, Routes.home);
      }
    } catch (e) {
      _showErrorDialog('Échec de connexion', 'Impossible de se connecter avec Google. Veuillez réessayer.');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    if (mounted) setState(() => _isLoading = loading);
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _navigateToSignUp() {
    Navigator.pushNamed(context, Routes.register);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: size.height * 0.05),
                  _buildHeader(theme),
                  const SizedBox(height: 40),
                  _buildLoginFields(theme),
                  const SizedBox(height: 24),
                  const SizedBox(height: 24),
                  _buildDivider(theme),
                  const SizedBox(height: 24),
                  _buildGoogleButton(),
                  const SizedBox(height: 32),
                  _buildSignUpLink(theme),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      children: [
        // Logo et titre
        Hero(
          tag: 'app_logo',
          child: Image.asset(
            'assets/images/logo.png',
            height: 120,
          ),
        ),
        const SizedBox(height: 32),
        Text(
          'Bienvenue sur Feelomi',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Connectez-vous pour suivre votre bien-être émotionnel',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLoginFields(ThemeData theme) {
    return Column(
      children: [
        // Champ email
  
        
        // Champ mot de passe
        FeelomiTextField(
          controller: _passwordController,
          label: 'Mot de passe',
          prefixIcon: Icons.lock_outline,
          obscureText: _obscurePassword,
          validator: Validators.validatePassword,
          autofillHints: const [AutofillHints.password],
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _handleLogin(),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
              color: theme.colorScheme.primary,
            ),
            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            tooltip: _obscurePassword ? 'Afficher le mot de passe' : 'Masquer le mot de passe',
          ),
        ),
        
        // Se souvenir de moi et mot de passe oublié
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (value) => setState(() => _rememberMe = value!),
                  ),
                  Text('Se souvenir de moi', style: theme.textTheme.bodyMedium),
                ],
              ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, Routes.forgotPassword),
                child: const Text('Mot de passe oublié?'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return Row(
      children: [
        Expanded(child: Divider(color: theme.colorScheme.onSurface.withOpacity(0.3))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'ou',
            style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6)),
          ),
        ),
        Expanded(child: Divider(color: theme.colorScheme.onSurface.withOpacity(0.3))),
      ],
    );
  }

  Widget _buildGoogleButton() {
    return FeelomiButton(
      onPressed: _isLoading ? null : _handleGoogleSignIn,
      text: 'Continuer avec Google',
      leadingImage: Image.asset('assets/images/google_logo.png', height: 24),
      color: Colors.white,
      textColor: Colors.black87,
      borderColor: Colors.grey.shade300,
    );
  }

  Widget _buildSignUpLink(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Nouveau sur Feelomi? ',
          style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
        ),
        GestureDetector(
          onTap: _navigateToSignUp,
          child: Text(
            'Créer un compte',
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

extension on AuthProvider {
  Future<bool> signInWithGoogle() async {
    // Implement actual Google sign-in logic
    throw UnimplementedError('Google sign-in not implemented');
  }
}