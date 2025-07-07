import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../api/user.dart';

class ProductDetailPage extends StatelessWidget {
  final int productId;
  const ProductDetailPage({required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
            centerTitle: true,
            title: const Text(
              "Detail Produk",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
        ),
      ),
      body: FutureBuilder<Product>(
        future: UserApi.getProductDetail(productId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Gagal memuat detail produk"));
          }

          final p = snapshot.data!;
          final imageUrl =
              p.image != null
                  ? 'http://192.168.25.157:8000/storage/${p.image}'
                  : null;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (imageUrl != null)
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        imageUrl,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (_, __, ___) =>
                                const Icon(Icons.broken_image, size: 100),
                      ),
                    ),
                  )
                else
                  const Center(
                    child: Icon(Icons.image_not_supported, size: 100),
                  ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    p.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 8),
                Text("Harga: Rp. ${p.price.toStringAsFixed(0)}"),
                Text("Stok: ${p.stock}"),
                const SizedBox(height: 10),
                Text(p.description ?? '-'),
              ],
            ),
          );
        },
      ),
    );
  }
}
