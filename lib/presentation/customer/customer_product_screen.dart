import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliklaptop/data/repository/product_repository.dart';
import 'package:kliklaptop/presentation/admin/bloc/product/product_bloc.dart';
import 'package:kliklaptop/presentation/customer/Transaksi_pembelian_screen.dart';
import 'package:kliklaptop/presentation/services/service_http_client.dart';

class CustomerProductScreen extends StatefulWidget {
  const CustomerProductScreen({super.key});

  @override
  State<CustomerProductScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerProductScreen> {
  late ProductBloc _productBloc;

  @override
  void initState() {
    super.initState();
    _productBloc = ProductBloc(
      productRepo: ProductRepository(ServiceHttpClient()),
    )..add(ProductAllRequested()); // trigger ambil data
  }

  @override
  void dispose() {
    _productBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _productBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Daftar Produk"),
          backgroundColor: const Color(0xff1F509A),
          foregroundColor: Colors.white,
        ),
        body: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProductFailure) {
              return Center(child: Text("Gagal memuat produk: ${state.error}"));
            } else if (state is ProductListSuccess) {
              final products = state.products;

              if (products.isEmpty) {
                return const Center(child: Text("Tidak ada produk."));
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
                    } catch (_) {}
                  }

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                    child: const Icon(
                                      Icons.image_not_supported,
                                    ),
                                  ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.namaProduk ?? "-",
                                  style: const TextStyle(
                                    fontSize: 16,
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
                                Text("Stok: ${product.stok ?? 0}"),
                                Text(
                                  "Rp ${product.harga ?? 0}",
                                  style: const TextStyle(color: Colors.green),
                                ),
                                const SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              TransaksiPembelianScreen(productId: product.id!),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xff1F509A),
                                    ),
                                    child: const Text("Beli Sekarang"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
