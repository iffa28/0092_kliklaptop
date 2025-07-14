import 'package:flutter/material.dart';
import 'package:kliklaptop/presentation/admin/manage_product_screen.dart';
import 'package:kliklaptop/presentation/admin/manage_services_screen.dart';
import 'package:kliklaptop/presentation/admin/manage_transaction_screen.dart';
import 'package:kliklaptop/presentation/auth/login_view.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final String adminName = "Admin";

  void _logout() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Yakin ingin keluar?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Tambahkan aksi logout sebenarnya di sini
            },
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(icon, size: 40, color: const Color(0xff1F509A)),
              const SizedBox(width: 20),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff1F509A),
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 20,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff1F509A),
        elevation: 4,
        toolbarHeight: 100,
        titleSpacing: 20,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Selamat Datang,",
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              adminName,
              style: const TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginView()),
                (Route<dynamic> route) => false,
              );
              // Navigator.pushReplacementNamed(context, '/login'); // contoh redirect
            },
            color: Colors.white,
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          _buildCard(
            icon: Icons.receipt_long,
            title: "Manajemen Transaksi",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ManageTransactionScreen(),
                ),
              );
            },
          ),
          _buildCard(
            icon: Icons.inventory_2_outlined,
            title: "Manajemen Produk",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ManageProductScreen()),
              );
            },
          ),
          _buildCard(
            icon: Icons.build_circle_outlined,
            title: "Manajemen Service",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ManageServicesScreen()),
              );
            },
          ),
          _buildCard(
            icon: Icons.build_circle_outlined,
            title: "Laporan",
            onTap: () {
              // TODO: Navigasi ke halaman manajemen service
            },
          ),
        ],
      ),
    );
  }
}
