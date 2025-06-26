import 'package:flutter/material.dart';
import '../../utils/theme.dart';
import '../../api/admin.dart';
import 'list.dart';
import 'login.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Konfirmasi"),
            content: const Text("Yakin ingin keluar?"),
            actions: [
              TextButton(
                child: const Text(
                  "Batal",
                  style: TextStyle(color: AppColors.primary),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                onPressed: () async {
                  Navigator.pop(context);
                  await AdminApi.logout();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginAdminPage()),
                    (route) => false,
                  );
                },
                child: const Text(
                  "Keluar",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF8D6E63), Color(0xFF4E342E)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: const Text(
              "Dashboard Admin",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () => _confirmLogout(context),
                icon: const Icon(Icons.logout, color: Colors.white),
                tooltip: 'Keluar',
              ),
            ],
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              width: MediaQuery.of(context).size.width * 0.5,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF8D6E63), Color(0xFF4E342E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ListProductPage()),
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.inventory, color: Colors.white, size: 40),
                    SizedBox(height: 8),
                    Text(
                      "Kelola Produk",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
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
