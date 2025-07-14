import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliklaptop/data/repository/transaksi_pembelian_repository.dart';
import 'package:kliklaptop/presentation/admin/detail_transaksi_pembelian_screen.dart';
import 'package:kliklaptop/presentation/customer/bloc/transaksipembelian/transaksipembelian_bloc.dart';
import 'package:kliklaptop/presentation/services/service_http_client.dart';

class ManageTransactionScreen extends StatefulWidget {
  const ManageTransactionScreen({super.key});

  @override
  State<ManageTransactionScreen> createState() =>
      _ManageTransactionScreenState();
}

class _ManageTransactionScreenState extends State<ManageTransactionScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TransaksiPembelianBloc>().add(GetAllTransaksiPembelian());
  }

  String _formatTanggal(DateTime tanggal) {
    final dateTime = tanggal.toLocal();
    return "${dateTime.day}-${dateTime.month}-${dateTime.year}";
  }

  Color _statusColor(String? status) {
    switch (status) {
      case 'transaksi berhasil':
        return Colors.green.shade50;
      case 'transaksi batal':
        return Colors.red.shade50;
      case 'menunggu penjemputan':
        return Colors.orange.shade50;
      default:
        return Colors.grey.shade200;
    }
  }

  void _showFullScreenModal(BuildContext context, transaksi) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Detail",
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Expanded(
                  child: DetailTransaksiPembelianScreen(transaksi: transaksi),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transaksi Pembelian"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: BlocConsumer<TransaksiPembelianBloc, TransaksiPembelianState>(
        listener: (context, state) {
          if (state is TransaksiPembelianFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("❌ ${state.error}")));
          }

          if (state is TransaksiPembelianDeleteSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("✅ Transaksi berhasil dihapus")),
            );

            // 🟢 Tambahkan ini untuk refresh data setelah hapus
            context.read<TransaksiPembelianBloc>().add(
              GetAllTransaksiPembelian(),
            );
          }
        },
        builder: (context, state) {
          if (state is TransaksiPembelianLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TransaksiPembelianListSuccess) {
            final transaksiList = state.transaksiList;

            if (transaksiList.isEmpty) {
              return const Center(child: Text("Belum ada transaksi."));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: transaksiList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final transaksi = transaksiList[index];

                return InkWell(
                  onTap: () => _showFullScreenModal(context, transaksi),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          transaksi.namaUser ?? "Pengguna",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          transaksi.namaProduk ?? "Produk tidak diketahui",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          transaksi.createdAt != null
                              ? "Tanggal: ${_formatTanggal(transaksi.createdAt!)}"
                              : "Tanggal tidak tersedia",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Chip(
                              label: Text(transaksi.metodePembayaran ?? "-"),
                              backgroundColor: Colors.blue.shade50,
                              labelStyle: const TextStyle(fontSize: 12),
                            ),
                            const SizedBox(width: 8),
                            Chip(
                              label: Text(transaksi.status ?? "-"),
                              backgroundColor: _statusColor(transaksi.status),
                              labelStyle: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox(); // For other states
        },
      ),
    );
  }
}
