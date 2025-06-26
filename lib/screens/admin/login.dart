import 'package:flutter/material.dart';
import '../../utils/theme.dart';
import '../../api/admin.dart';
import '../user/login.dart';
import 'dashboard.dart';

class LoginAdminPage extends StatefulWidget {
  const LoginAdminPage({super.key});

  @override
  State<LoginAdminPage> createState() => _LoginAdminPageState();
}

class _LoginAdminPageState extends State<LoginAdminPage> {
  final _formKey = GlobalKey<FormState>();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();

  bool isLoading = false;
  bool obscurePassword = true;
  String? errorMessage;

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final result = await AdminApi.login(
      _loginController.text.trim(),
      _passwordController.text.trim(),
    );

    setState(() => isLoading = false);

    if (result['success']) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardPage()),
      );
    } else {
      setState(() => errorMessage = result['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const LoginPage()),
          );
        },
        child: const Icon(Icons.account_circle, color: AppColors.background),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Admin Panel Materialin",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Sistem Informasi Penjualan Material Bangunan",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Card(
                elevation: 8,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const Text(
                          "Admin",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _loginController,
                          decoration: InputDecoration(
                            labelText: "Email / Username",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: AppColors.primary,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            labelStyle: const TextStyle(
                              color: AppColors.primary,
                            ),
                          ),
                          validator:
                              (value) =>
                                  value == null || value.isEmpty
                                      ? "Email / Username wajib diisi"
                                      : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: obscurePassword,
                          decoration: InputDecoration(
                            labelText: "Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: AppColors.primary,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            labelStyle: const TextStyle(
                              color: AppColors.primary,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  obscurePassword = !obscurePassword;
                                });
                              },
                            ),
                          ),
                          validator:
                              (value) =>
                                  value == null || value.isEmpty
                                      ? "Password wajib diisi"
                                      : null,
                        ),
                        if (errorMessage != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child:
                              isLoading
                                  ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                  : ElevatedButton(
                                    onPressed: _login,
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      backgroundColor: AppColors.primary,
                                    ),
                                    child: const Text(
                                      "MASUK",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                        ),
                      ],
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
