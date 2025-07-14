import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliklaptop/data/repository/product_repository.dart';
import 'package:kliklaptop/data/repository/service_request_repository.dart';
import 'package:kliklaptop/presentation/admin/bloc/product/product_bloc.dart';
import 'package:kliklaptop/presentation/admin/detail_product_screen.dart';
import 'package:kliklaptop/presentation/auth/login_view.dart';
import 'package:kliklaptop/presentation/customer/Transaksi_pembelian_screen.dart';
import 'package:kliklaptop/presentation/customer/customer_history_screen.dart';
import 'package:kliklaptop/presentation/customer/customer_product_screen.dart';
import 'package:kliklaptop/presentation/customer/customer_profile_screen.dart';
import 'package:kliklaptop/presentation/customer/list_service_laptop_screen.dart';
import 'package:kliklaptop/presentation/customer/service_request_screen.dart';
import 'package:kliklaptop/presentation/services/service_http_client.dart';
import 'package:kliklaptop/presentation/customer/bloc/servicer_request/service_request_bloc.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  final String customerName = "User";
  int _selectedIndex = 0;
  late ProductBloc _productBloc;
  late ServiceRequestBloc _serviceRequestBloc;

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _productBloc = ProductBloc(
      productRepo: ProductRepository(ServiceHttpClient()),
    )..add(ProductAllRequested());

    _serviceRequestBloc = ServiceRequestBloc(
      serviceRepo: ServiceRequestRepository(ServiceHttpClient()),
    )..add(GetUserService());

    _pages.addAll([
      _buildHomeContent(),
      const CustomerProductScreen(),
      const CustomerHistoryScreen(),
      const CustomerProfileScreen(),
    ]);
  }

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
                (route) => false,
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _onNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    _productBloc.close();
    _serviceRequestBloc.close();
    super.dispose();
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
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
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.white),
                  onPressed: _logout,
                  tooltip: 'Logout',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHomeContent() {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _productBloc),
        BlocProvider.value(value: _serviceRequestBloc),
      ],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildServiceCard(),
            const SizedBox(height: 12),
            _buildActiveServiceInfo(),
            const SizedBox(height: 24),
            Row(
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
                      MaterialPageRoute(
                        builder: (_) => const CustomerProductScreen(),
                      ),
                    );
                  },
                  child: const Text("Lihat Semua"),
                ),
              ],
            ),
            BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ProductFailure) {
                  return Center(
                    child: Text("Gagal memuat produk: ${state.error}"),
                  );
                } else if (state is ProductListSuccess) {
                  final products = state.products.take(3).toList();

                  if (products.isEmpty) {
                    return const Center(child: Text("Tidak ada produk."));
                  }

                  return Column(
                    children: products.map((product) {
                      Uint8List? imageBytes;
                      if (product.fotoProduk != null &&
                          product.fotoProduk!.isNotEmpty) {
                        try {
                          imageBytes = base64Decode(product.fotoProduk!);
                        } catch (_) {}
                      }

                      return GestureDetector(
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
                        child: Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
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
                                          child: const Icon(Icons.image_not_supported),
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
                                                builder: (_) => TransaksiPembelianScreen(
                                                  productId: product.id!,
                                                ),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xff1F509A),
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
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }

                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ServiceRequestScreen()),
        ).then((value) async {
          if (value == true) {
            await Future.delayed(const Duration(milliseconds: 500));
            _serviceRequestBloc.add(GetUserService()); // Re-fetch service
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
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
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: const [
            Icon(Icons.build_circle, size: 32, color: Colors.white),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                "Service Laptop",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveServiceInfo() {
    return BlocBuilder<ServiceRequestBloc, ServiceRequestState>(
      builder: (context, state) {
        if (state is ServiceRequestLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ServiceRequestListSuccess) {
          final data = state.serviceList;

          final statusCounts = <String, int>{};
          for (var service in data) {
            final status = service.status?.toLowerCase() ?? 'lainnya';
            statusCounts[status] = (statusCounts[status] ?? 0) + 1;
          }

          if (statusCounts.isEmpty) {
            return const Text(
              'Tidak ada servis aktif.',
              style: TextStyle(color: Colors.grey),
            );
          }

          final total = statusCounts.values.fold<int>(0, (a, b) => a + b);

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ListServiceLaptopScreen(),
                ),
              );
            },
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              margin: const EdgeInsets.only(bottom: 20),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ringkasan Status Servis',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    ...statusCounts.entries.map((entry) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(_getStatusIcon(entry.key), color: _getColorByStatus(entry.key)),
                              const SizedBox(width: 8),
                              Text(
                                '${_capitalize(entry.key)} (${entry.value})',
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: entry.value / total,
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                _getColorByStatus(entry.key),
                              ),
                              minHeight: 8,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
          );
        }

        return const SizedBox();
      },
    );
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  Color _getColorByStatus(String status) {
    switch (status) {
      case 'menunggu konfirmasi':
        return Colors.blue;
      case 'dikonfirmasi':
        return Colors.orange;
      case 'sedang diperbaiki':
        return Colors.purple;
      case 'perbaikan selesai':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'menunggu konfirmasi':
        return Icons.hourglass_empty;
      case 'dikonfirmasi':
        return Icons.check_circle_outline;
      case 'sedang diperbaiki':
        return Icons.build_circle;
      case 'perbaikan selesai':
        return Icons.verified;
      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 0 ? _buildAppBar() : null,
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTapped,
        selectedItemColor: const Color(0xff1F509A),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Produk'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
