import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliklaptop/data/repository/product_repository.dart';
import 'package:kliklaptop/presentation/admin/bloc/product/product_bloc.dart';
import 'package:kliklaptop/presentation/admin/detail_product_screen.dart';
import 'package:kliklaptop/presentation/customer/Transaksi_pembelian_screen.dart';
import 'package:kliklaptop/presentation/services/service_http_client.dart';

class CustomerProductScreen extends StatefulWidget {
  const CustomerProductScreen({super.key});

  @override
  State<CustomerProductScreen> createState() => _CustomerProductScreenState();
}

class _CustomerProductScreenState extends State<CustomerProductScreen> {
  late ProductBloc _productBloc;

  @override
  void initState() {
    super.initState();
    _productBloc = ProductBloc(
      productRepo: ProductRepository(ServiceHttpClient()),
    )..add(ProductAllRequested());
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
        body: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  if (state is ProductLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ProductFailure) {
                    return Center(child: Text("Gagal memuat produk: ${state.error}"));
                  } else if (state is ProductListSuccess) {
                    final products = state.products;

                    if (products.isEmpty) {
                      return const Center(child: Text("Tidak ada produk tersedia."));
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];

                        Uint8List? imageBytes;
                        if (product.fotoProduk != null && product.fotoProduk!.isNotEmpty) {
                          try {
                            imageBytes = base64Decode(product.fotoProduk!);
                          } catch (_) {}
                        }

                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.only(bottom: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              if (product.id != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ProductDetailScreen(
                                      product: product,
                                      imageBytes: imageBytes,
                                      role: 'customer',
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: imageBytes != null
                                        ? Image.memory(
                                            imageBytes,
                                            width: 150,
                                            height: 130,
                                            fit: BoxFit.cover,
                                          )
                                        : Container(
                                            width: 100,
                                            height: 100,
                                            color: Colors.grey[300],
                                            child: const Icon(Icons.image_not_supported),
                                          ),
                                  ),
                                  const SizedBox(width: 40),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          product.namaProduk ?? "-",
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          product.deskripsi ?? "-",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(color: Colors.black54),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            const Icon(Icons.price_change, size: 18, color: Colors.green),
                                            const SizedBox(width: 4),
                                            Text(
                                              "Rp ${product.harga ?? 0}",
                                              style: const TextStyle(
                                                color: Colors.green,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) => TransaksiPembelianScreen(
                                                    productId: product.id!,
                                                  ),
                                                ),
                                              );
                                            },
                                            borderRadius: BorderRadius.circular(8),
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 18,
                                                vertical: 10,
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8),
                                                gradient: const LinearGradient(
                                                  colors: [Color(0xff1F509A), Color(0xff4FA1D9)],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                ),
                                              ),
                                              child: const Text(
                                                "Beli Sekarang",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
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

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff1F509A), Color(0xff81BFDA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "DAFTAR PRODUK",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
