import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kliklaptop/data/model/response/transaksi_pembelian_response_model.dart';
import 'package:kliklaptop/presentation/customer/bloc/transaksipembelian/transaksipembelian_bloc.dart';

class CustomerHistoryTransactionScreen extends StatefulWidget {
  const CustomerHistoryTransactionScreen({super.key});

  @override
  State<CustomerHistoryTransactionScreen> createState() =>
      _CustomerHistoryTransactionScreenState();
}

class _CustomerHistoryTransactionScreenState
    extends State<CustomerHistoryTransactionScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TransaksiPembelianBloc>().add(GetUserHistoryTransaction());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransaksiPembelianBloc, TransaksiPembelianState>(
      builder: (context, state) {
        if (state is TransaksiPembelianLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TransaksiPembelianFailure) {
          return Center(child: Text("❌ ${state.error}"));
        } else if (state is TransaksiPembelianListSuccess) {
          final transaksiList = state.transaksiList
              .where((item) =>
                  item.status?.toLowerCase() == 'transaksi berhasil')
              .toList();

          if (transaksiList.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    "Belum ada riwayat pembelian",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: transaksiList.length,
            itemBuilder: (context, index) {
              final item = transaksiList[index];
              return _buildTransactionCard(item);
            },
          );
        }

        return const SizedBox();
      },
    );
  }

  Widget _buildTransactionCard(Data item) {
    final createdAt = item.createdAt != null
        ? DateFormat('dd MMM yyyy').format(item.createdAt!)
        : '-';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        leading: const Icon(Icons.shopping_cart_checkout, color: Color(0xff1F509A)),
        title: Text(
          item.namaProduk ?? '-',
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Metode: ${item.metodePembayaran ?? '-'}",
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              "Tanggal: $createdAt",
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: _buildStatusChip(item.status ?? ''),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'transaksi berhasil':
        color = Colors.green;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
