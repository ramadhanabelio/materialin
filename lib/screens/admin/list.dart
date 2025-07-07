import 'package:flutter/material.dart';
import '../../api/admin.dart';
import '../../models/product.dart';
import '../../utils/theme.dart';
import 'form.dart';

class ListProductPage extends StatefulWidget {
  @override
  State<ListProductPage> createState() => _ListProductPageState();
}

class _ListProductPageState extends State<ListProductPage> {
  late Future<List<Product>> _futureProducts;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    setState(() {
      _futureProducts = AdminApi.getProducts();
    });
  }

  void _openForm({Product? product}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FormProductPage(product: product)),
    );

    if (result == true) {
      _loadProducts();
    }
  }

  void _confirmDelete(Product product) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: Colors.white,
            title: Text('Hapus Produk'),
            content: Text('Yakin ingin menghapus "${product.name}"?'),
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
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  "Hapus",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );

    if (confirm == true) {
      final success = await AdminApi.deleteProduct(product.id);
      if (success) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Produk berhasil dihapus")));
        _loadProducts();
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Gagal menghapus produk")));
      }
    }
  }

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
              "Daftar Produk",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
            actions: [
              IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: () => _openForm(),
                tooltip: "Tambah Produk",
              ),
            ],
          ),
        ),
      ),
      body: FutureBuilder<List<Product>>(
        future: _futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            print('ERROR: ${snapshot.error}');
            return Center(child: Text("Gagal memuat produk"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Belum ada produk"));
          }

          final products = snapshot.data!;
          return ListView.separated(
            itemCount: products.length,
            separatorBuilder: (_, __) => Divider(height: 1),
            itemBuilder: (context, index) {
              final p = products[index];
              final imageUrl =
                  p.image != null
                      ? 'http://192.168.25.157:8000/storage/${p.image}'
                      : null;

              return ListTile(
                leading:
                    imageUrl != null
                        ? Image.network(
                          imageUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (_, __, ___) => Icon(Icons.broken_image),
                        )
                        : Icon(Icons.image_not_supported),
                title: Text(p.name),
                subtitle: Text(
                  "Rp. ${p.price.toStringAsFixed(0)} - Stok: ${p.stock}",
                ),
                trailing: PopupMenuButton<String>(
                  onSelected: (val) {
                    if (val == 'edit') {
                      _openForm(product: p);
                    } else if (val == 'delete') {
                      _confirmDelete(p);
                    }
                  },
                  itemBuilder:
                      (context) => [
                        PopupMenuItem(value: 'edit', child: Text('Edit')),
                        PopupMenuItem(value: 'delete', child: Text('Hapus')),
                      ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
