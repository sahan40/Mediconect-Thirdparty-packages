import 'package:flutter/material.dart';
import '../../core/navigation/navigation_extensions.dart';
import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';
import '../../core/app_dimensions.dart';
import '../../core/app_routes.dart';
import '../state/login_provider.dart';
import '../state/login_state.dart';
import '../widgets/login_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  final _identifierFocus = FocusNode();
  final _passwordFocus = FocusNode();

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    _identifierFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _handleLogin(LoginState state) async {
    FocusScope.of(context).unfocus();
    final success = await state.login(
      identifier: _identifierController.text,
      password: _passwordController.text,
    );
    if (success && mounted) {
      context.go(AppRoutes.dashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = LoginProvider.of(context).state;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textPrimary,
            size: AppDimensions.appBarIconSize,
          ),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text('Login', style: AppTextStyles.appBarTitle),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingXL,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: AppDimensions.paddingXXL),

              // Brand icon
              const MedicalIconBox(),
              const SizedBox(height: 28),

              // Heading
              const Text('Welcome Back', style: AppTextStyles.heading),
              const SizedBox(height: 10),

              // Subtitle
              const Text(
                'Please sign in to manage your\nappointments and health records.',
                style: AppTextStyles.subtitle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 36),

              // Error banner
              if (state.status == LoginStatus.error &&
                  state.errorMessage != null) ...[
                _ErrorBanner(
                  message: state.errorMessage!,
                  onDismiss: state.clearError,
                ),
                const SizedBox(height: AppDimensions.paddingL),
              ],

              // Email / phone field
              const FieldLabel(text: 'Email or Phone Number'),
              const SizedBox(height: AppDimensions.paddingS),
              AppInputField(
                controller: _identifierController,
                hintText: 'Enter your email or phone',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                onSubmitted: (_) => _passwordFocus.requestFocus(),
              ),
              const SizedBox(height: AppDimensions.paddingL),

              // Password field
              const FieldLabel(text: 'Password'),
              const SizedBox(height: AppDimensions.paddingS),
              AppPasswordField(
                controller: _passwordController,
                obscureText: state.obscurePassword,
                onToggleVisibility: state.togglePasswordVisibility,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _handleLogin(state),
              ),
              const SizedBox(height: 14),

              // Forgot password
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => context.push(AppRoutes.forgotPassword),
                  child: const Text(
                    'Forgot Password?',
                    style: AppTextStyles.link,
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.paddingXXL),

              // Login button
              GradientButton(
                label: 'Login',
                isLoading: state.isLoading,
                onPressed: () => _handleLogin(state),
              ),
              const SizedBox(height: 28),

              SignUpFooter(
                onSignUpTap: () {
                  context.push(AppRoutes.signup);
                },
              ),
              const SizedBox(height: AppDimensions.paddingL),

              // Secure footer
              const SecureConnectionFooter(),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  final VoidCallback onDismiss;
  const _ErrorBanner({required this.message, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.08),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: AppColors.error.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(fontSize: 13, color: AppColors.error),
            ),
          ),
          GestureDetector(
            onTap: onDismiss,
            child: const Icon(Icons.close, color: AppColors.error, size: 16),
          ),
        ],
      ),
    );
  }
}
