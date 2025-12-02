import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'models/product.dart';
import 'product_detail_page.dart';

class CategoryPage extends StatefulWidget {
  final String categoryName;

  const CategoryPage({super.key, required this.categoryName});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<Product> _products = [];
  List<String> _categories = [];
  bool _isLoading = true;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    fetchCategoryProducts();
    fetchCategories(); // ← دریافت همه دسته‌بندی‌ها برای Drawer
  }

  Future<void> fetchCategories() async {
    try {
      final url = Uri.parse('https://fakestoreapi.com/products/categories');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        setState(() {
          _categories = data.map((e) => e.toString()).toList();
        });
      }
    } catch (e) {
      // نادیده بگیر
    }
  }

  Future<void> fetchCategoryProducts() async {
    try {
      final url = Uri.parse(
        'https://fakestoreapi.com/products/category/${widget.categoryName}',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        setState(() {
          _products = data.map((e) => Product.fromJson(e)).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _isError = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isError = true;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Text("Categories", style: TextStyle(fontSize: 20)),
            ),
            ..._categories.map((c) {
              return ListTile(
                title: Text(c),
                onTap: () {
                  Navigator.pop(context); // بستن Drawer
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CategoryPage(categoryName: c),
                    ),
                  );
                },
              );
            }).toList(),
          ],
        ),
      ),
      appBar: AppBar(title: Text(widget.categoryName)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _isError
          ? const Center(child: Text("خطا در دریافت اطلاعات"))
          : ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: Image.network(product.image, width: 60),
                    title: Text(product.title),
                    subtitle: Text("\$${product.price}"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductDetailPage(product: product),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
