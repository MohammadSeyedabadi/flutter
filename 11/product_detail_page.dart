import 'package:flutter/material.dart';
import 'models/product.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  List<Product> _categoryProducts = [];

  @override
  void initState() {
    super.initState();
    fetchCategoryProducts();
  }

  Future<void> fetchCategoryProducts() async {
    final url = Uri.parse(
      "https://fakestoreapi.com/products/category/${widget.product.category}",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      setState(() {
        _categoryProducts = data.map((e) => Product.fromJson(e)).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text(
                "Products in ${widget.product.category}",
                style: const TextStyle(fontSize: 20),
              ),
            ),
            ..._categoryProducts.map((p) {
              return ListTile(
                title: Text(p.title),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailPage(product: p),
                    ),
                  );
                },
              );
            }).toList(),
          ],
        ),
      ),

      appBar: AppBar(title: Text(widget.product.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Image.network(widget.product.image, height: 250)),
            const SizedBox(height: 20),
            Text(
              widget.product.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "\$${widget.product.price}",
              style: const TextStyle(fontSize: 20, color: Colors.green),
            ),
            const SizedBox(height: 20),
            Text(widget.product.description),
            const SizedBox(height: 20),
            Text("Rating: ★ ${widget.product.rating["rate"]}"),
            Text("Count: ${widget.product.rating["count"]}"),
          ],
        ),
      ),
    );
  }
}
