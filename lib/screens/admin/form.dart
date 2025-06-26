import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/product.dart';
import '../../api/admin.dart';

class FormProductPage extends StatefulWidget {
  final Product? product;
  const FormProductPage({super.key, this.product});

  @override
  State<FormProductPage> createState() => _FormProductPageState();
}

class _FormProductPageState extends State<FormProductPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _name;
  late TextEditingController _desc;
  late TextEditingController _price;
  late TextEditingController _stock;

  File? _imageFile;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.product?.name ?? '');
    _desc = TextEditingController(text: widget.product?.description ?? '');
    _price = TextEditingController(
      text: widget.product?.price.toString() ?? '',
    );
    _stock = TextEditingController(
      text: widget.product?.stock.toString() ?? '',
    );
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  void _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    final product = Product(
      id: widget.product?.id ?? 0,
      name: _name.text,
      description: _desc.text,
      price: double.parse(_price.text),
      stock: int.parse(_stock.text),
      imageFile: _imageFile,
    );

    setState(() => isSaving = true);
    final success = await AdminApi.saveProduct(product, id: widget.product?.id);
    setState(() => isSaving = false);

    if (success) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal menyimpan produk")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.product != null;

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
            title: Text(
              isEdit ? "Edit Produk" : "Tambah Produk",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _name,
                decoration: InputDecoration(
                  labelText: 'Nama Produk',
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF8D6E63)),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator:
                    (val) =>
                        val == null || val.isEmpty
                            ? "Tidak boleh kosong"
                            : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _desc,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Deskripsi',
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF8D6E63)),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _price,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Harga',
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF8D6E63)),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator:
                    (val) => val == null || val.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _stock,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Stok',
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF8D6E63)),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator:
                    (val) => val == null || val.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 20),
              TextButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image, color: Color(0xFF8D6E63)),
                label: const Text(
                  "Pilih Gambar",
                  style: TextStyle(color: Color(0xFF8D6E63)),
                ),
              ),
              if (_imageFile != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Image.file(_imageFile!, height: 120),
                )
              else if (isEdit && widget.product!.image != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Image.network(
                    'http://materialin.polbeng.my.id/storage/${widget.product!.image}',
                    height: 120,
                  ),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isSaving ? null : _saveProduct,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8D6E63),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  isSaving ? 'Menyimpan...' : 'SIMPAN',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
