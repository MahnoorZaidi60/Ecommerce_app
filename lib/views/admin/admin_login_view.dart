import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/routes.dart';
import '../../view_models/auth_vm.dart';
import '../shared/custom_button.dart';
import '../shared/custom_textfield.dart';

class AdminLoginView extends StatefulWidget {
  const AdminLoginView({super.key});

  @override
  State<AdminLoginView> createState() => _AdminLoginViewState();
}

class _AdminLoginViewState extends State<AdminLoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Background color logic
    final bgColor = isDark ? Colors.black : Colors.blueGrey.shade50;

    // Card color logic
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return Scaffold(
      backgroundColor: bgColor, // ✅ Dynamic Background
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 4,
            color: cardColor, // ✅ Dynamic Card Color
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                        Icons.admin_panel_settings,
                        size: 60,
                        color: isDark ? Colors.white70 : AppColors.secondary
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Admin Portal",
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.secondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Authorized Personnel Only",
                      style: TextStyle(color: isDark ? Colors.grey : Colors.black54),
                    ),
                    const SizedBox(height: 32),

                    CustomTextField(
                      controller: _emailController,
                      label: "Admin Email",
                      hint: "admin@windigo.com",
                      suffixIcon: const Icon(Icons.email),
                    ),
                    CustomTextField(
                      controller: _passwordController,
                      label: "Password",
                      hint: "********",
                      isPassword: true,
                      suffixIcon: const Icon(Icons.lock),
                    ),
                    const SizedBox(height: 24),

                    CustomButton(
                      text: "Access Dashboard",
                      isLoading: authVM.isLoading,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          // Login Logic (Email check removed for testing)
                          await authVM.login(
                            _emailController.text.trim(),
                            _passwordController.text.trim(),
                            context,
                          );
                          if (context.mounted) {
                            Navigator.pushReplacementNamed(context, AppRoutes.adminDashboard);
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Back to User App"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}