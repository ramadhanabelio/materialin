import 'dart:io';

class Product {
  final int id;
  final String name;
  final String? description;
  final double price;
  final int stock;
  final String? image;

  File? imageFile;

  Product({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.stock,
    this.image,
    this.imageFile,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      stock: int.tryParse(json['stock'].toString()) ?? 0,
      image: json['image'],
    );
  }

  Map<String, String> toMap() => {
    'name': name,
    'description': description ?? '',
    'price': price.toStringAsFixed(2),
    'stock': stock.toString(),
  };
}
