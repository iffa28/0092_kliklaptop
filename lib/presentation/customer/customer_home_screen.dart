import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliklaptop/data/repository/product_repository.dart';
import 'package:kliklaptop/presentation/admin/bloc/product/product_bloc.dart';
import 'package:kliklaptop/presentation/auth/login_view.dart';
import 'package:kliklaptop/presentation/customer/service_request_screen.dart';
import 'package:kliklaptop/presentation/customer/customer_product_screen.dart';
import 'package:kliklaptop/presentation/services/service_http_client.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  final String customerName = "Iffatuz Zahra";
  late ProductBloc _productBloc;

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginView()),
                (Route<dynamic> route) => false,
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _productBloc = ProductBloc(productRepo: ProductRepository(ServiceHttpClient()))
      ..add(ProductAllRequested());
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
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff1F509A), Color(0xff81BFDA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2.5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const CircleAvatar(
                        radius: 26,
                        backgroundImage: AssetImage('assets/profile.jpg'),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Selamat Datang,",
                          style: TextStyle(color: Colors.white70, fontSize: 15),
                        ),
                        Text(
                          customerName,
                          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.logout, color: Colors.white),
                      onPressed: _logout,
                      tooltip: 'Logout',
                    
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xff1F509A), Color(0xff4FA1D9)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ServiceRequestScreen()),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                        child: Row(
                          children: [
                            const Icon(Icons.build_circle, color: Colors.white, size: 32),
                            const SizedBox(width: 16),
                            const Text(
                              "Service Laptop",
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            const Icon(Icons.arrow_forward_ios, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Produk Terbaru",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CustomerProductScreen()),
                      );
                    },
                    child: const Text("Lihat Semua"),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 200,
              child: BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  if (state is ProductLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ProductListSuccess) {
                    final products = state.products.take(3).toList(); // ambil 3 produk

                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: products.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final product = products[index];

                        Uint8List? imageBytes;
                        if (product.fotoProduk != null && product.fotoProduk!.isNotEmpty) {
                          try {
                            imageBytes = base64Decode(product.fotoProduk!);
                          } catch (_) {}
                        }

                        return Container(
                          width: 140,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                child: imageBytes != null
                                    ? Image.memory(
                                        imageBytes,
                                        height: 120,
                                        fit: BoxFit.cover,
                                      )
                                    : Container(
                                        height: 120,
                                        color: Colors.grey[300],
                                        child: const Icon(Icons.image),
                                      ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.namaProduk ?? "-",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Rp ${product.harga ?? 0}",
                                      style: const TextStyle(color: Colors.green),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  } else if (state is ProductFailure) {
                    return Center(child: Text("Gagal memuat produk: ${state.error}"));
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}