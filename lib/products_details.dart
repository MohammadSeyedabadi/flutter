import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'models/product.dart';

class ProductsPage extends StatefulWidget {
  final String categoryName;
  const ProductsPage({Key? key, required this.categoryName}) : super(key: key);

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  List<dynamic> _categoryProducts = [];
  bool _isLoading = true;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    getCategoryProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.categoryName)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _isError
              ? const Center(child: Text("خطا در دریافت اطلاعات"))
              : ListView.builder(
                  itemCount: _categoryProducts.length,
                  itemBuilder: (BuildContext context, int index) {
                    Product product =
                        Product.fromJson(_categoryProducts[index]);
                    return Container(
                      color: Colors.amber[100],
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Title: ${product.title}'),
                          Text('Price: ${product.price}'),
                          Text('Description: ${product.description}'),
                          Text('Category: ${product.category}'),
                          Image.network(
                            product.image,
                            width: 200,
                            height: 200,
                          ),
                          Text(
                            'Rating: ${product.rating['rate']}   |   Count: ${product.rating['count']}',
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }

  Future<void> getCategoryProducts() async {
    try {
      final response = await http.get(Uri.parse(
          'https://fakestoreapi.com/products/category/${widget.categoryName}'));

      if (response.statusCode == 200) {
        final parsed = json.decode(response.body);
        setState(() {
          _categoryProducts = parsed;
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
}
