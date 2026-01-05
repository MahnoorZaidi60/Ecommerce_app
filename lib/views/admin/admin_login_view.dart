import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/utils/validators.dart';
import '../../view_models/auth_vm.dart';

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
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);

    return Scaffold(
      // AppTheme handles Background Color (White/Black) automatically
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. HEADER (Windigo Style)
                const Icon(Icons.admin_panel_settings_outlined, size: 60),
                const SizedBox(height: 10),
                Text(
                  "ADMIN PORTAL",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                Text(
                  "Restricted Access Only",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade600),
                ),

                const SizedBox(height: 40),

                // 2. EMAIL INPUT
                TextFormField(
                  controller: _emailController,
                  validator: AppValidators.validateEmail,
                  decoration: const InputDecoration(
                    labelText: "Admin Email",
                    prefixIcon: Icon(Icons.email_outlined),
                    hintText: "admin@windigo.com",
                  ),
                ),
                const SizedBox(height: 16),

                // 3. PASSWORD INPUT
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  validator: AppValidators.validatePassword,
                  decoration: const InputDecoration(
                    labelText: "Secure Password",
                    prefixIcon: Icon(Icons.lock_outline),
                    hintText: "••••••",
                  ),
                ),
                const SizedBox(height: 30),

                // 4. LOGIN BUTTON
                SizedBox(
                  height: 55,
                  child: ElevatedButton(
                    onPressed: authVM.isLoading
                        ? null
                        : () async {
                      if (_formKey.currentState!.validate()) {
                        // ✅ Let AuthVM handle the logic & navigation
                        await authVM.login(
                          _emailController.text.trim(),
                          _passwordController.text.trim(),
                          context,
                        );
                      }
                    },
                    child: authVM.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("ACCESS DASHBOARD"),
                  ),
                ),

                const SizedBox(height: 20),

                // 5. BACK TO SHOP
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Not an Admin? Go Back"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}