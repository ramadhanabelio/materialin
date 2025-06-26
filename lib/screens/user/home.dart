import 'package:flutter/material.dart';
import '../../utils/session_manager.dart';
import '../../models/product.dart';
import '../../utils/theme.dart';
import '../../api/user.dart';
import 'detail.dart';
import 'login.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Konfirmasi"),
            content: const Text("Yakin ingin keluar?"),
            actions: [
              TextButton(
                style: TextButton.styleFrom(foregroundColor: AppColors.primary),
                onPressed: () => Navigator.pop(context),
                child: const Text("Batal"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  Navigator.pop(context);
                  await UserApi.logout();
                  await SessionManager.clearToken();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false,
                  );
                },
                child: const Text("Keluar"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
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
            centerTitle: true,
            title: const Text(
              "Daftar Produk",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.white),
                tooltip: "Keluar",
                onPressed: () => _confirmLogout(context),
              ),
            ],
          ),
        ),
      ),
      body: FutureBuilder<List<Product>>(
        future: UserApi.getProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Gagal memuat produk"));
          }

          final products = snapshot.data!;
          if (products.isEmpty) {
            return const Center(child: Text("Belum ada produk."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final p = products[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailPage(productId: p.id),
                    ),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child:
                              p.image != null
                                  ? Image.network(
                                    'http://materialin.polbeng.my.id/storage/${p.image}',
                                    height: 160,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  )
                                  : Container(
                                    height: 160,
                                    color: Colors.grey[300],
                                    child: const Center(
                                      child: Icon(
                                        Icons.image_not_supported,
                                        size: 50,
                                      ),
                                    ),
                                  ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          p.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Rp. ${p.price.toStringAsFixed(0)} - Stok: ${p.stock}",
                          style: const TextStyle(color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
