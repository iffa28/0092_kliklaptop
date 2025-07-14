import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kliklaptop/data/model/response/product_response_model.dart';
import 'package:kliklaptop/presentation/admin/bloc/product/product_bloc.dart';
import 'package:kliklaptop/presentation/admin/detail_product_screen.dart';
import 'package:kliklaptop/presentation/admin/insert_product_screen.dart';

class ManageProductScreen extends StatefulWidget {
  const ManageProductScreen({super.key});

  @override
  State<ManageProductScreen> createState() => _ManageProductScreenState();
}

class _ManageProductScreenState extends State<ManageProductScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(ProductAllRequested());
  }

  void _showProductDetailDialog(Data product, Uint8List? imageBytes) {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(product.namaProduk ?? "Produk"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imageBytes != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.memory(
                    imageBytes,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 12),
              Text("Deskripsi:", style: TextStyle(fontWeight: FontWeight.bold)),
              Text(product.deskripsi ?? "-"),
              const SizedBox(height: 10),
              Text("Harga:", style: TextStyle(fontWeight: FontWeight.bold)),
              Text(formatter.format(product.harga ?? 0)),
              const SizedBox(height: 10),
              Text("Stok:", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("${product.stok ?? 0}"),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tutup"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Manajemen Produk"),
        backgroundColor: const Color(0xff1F509A),
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("❌ ${state.error}")));
          }

          if (state is ProductDeleteSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("✅ ${state.message}")));
            context.read<ProductBloc>().add(ProductAllRequested());
          }
          
        },
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProductListSuccess) {
            final products = state.products;

            if (products.isEmpty) {
              return const Center(child: Text("Belum ada produk"));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];

                Uint8List? imageBytes;
                if (product.fotoProduk != null &&
                    product.fotoProduk!.isNotEmpty) {
                  try {
                    imageBytes = base64Decode(product.fotoProduk!);
                  } catch (e) {
                    imageBytes = null;
                  }
                }

                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailScreen(
                          product: product,
                          imageBytes: imageBytes,
                          role: 'admin', // atau 'customer'
                        ),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: imageBytes != null
                                ? Image.memory(
                                    imageBytes,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    width: 100,
                                    height: 100,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.broken_image),
                                  ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.namaProduk ?? "-",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  product.deskripsi ?? "-",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text("Stok: ${product.stok ?? '-'}"),
                                Text(
                                  formatter.format(product.harga ?? 0),
                                  style: const TextStyle(color: Colors.green),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return const Center(child: Text("Gagal memuat data produk"));
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const InsertProductScreen()),
            );

            if (result == true) {
              context.read<ProductBloc>().add(ProductAllRequested());
            }
          },
          backgroundColor: const Color(0xff1F509A),
          child: const Icon(Icons.add, size: 32, color: Colors.white),
        ),
      ),
    );
  }
}
