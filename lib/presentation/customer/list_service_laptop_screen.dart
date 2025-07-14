import 'package:flutter/material.dart';
import 'package:kliklaptop/presentation/customer/customer_status_aktif_pembelian.dart';
import 'package:kliklaptop/presentation/customer/customer_status_aktif_service.dart';

class ListServiceLaptopScreen extends StatefulWidget {
  const ListServiceLaptopScreen({super.key});

  @override
  State<ListServiceLaptopScreen> createState() => _ListServiceLaptopScreenState();
}

class _ListServiceLaptopScreenState extends State<ListServiceLaptopScreen> {
  int selectedIndex = 0; // 0 = servis, 1 = pembelian

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildGradientAppBar(),
          _buildTabSelector(),
          Expanded(
            child: IndexedStack(
              index: selectedIndex,
              children: const [
                CustomerStatusAktifService(),     // halaman servis
                CustomerStatusAktifPembelian(), // halaman pembelian
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientAppBar() {
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
          children: [
             IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(width: 12),
            Text(
              "Status Layanan",
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

  Widget _buildTabSelector() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTabButton("Status Servis", 0),
          const SizedBox(width: 24),
          _buildTabButton("Status Pembelian", 1),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title, int index) {
    final isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? const Color(0xff1F509A) : Colors.grey,
            ),
          ),
          const SizedBox(height: 6),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 3,
            width: 60,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xff1F509A) : Colors.transparent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}
