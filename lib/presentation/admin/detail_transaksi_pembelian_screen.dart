import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliklaptop/data/model/response/transaksi_pembelian_response_model.dart';
import 'package:kliklaptop/presentation/admin/edit_transaksi_pembelian_screen.dart';
import 'package:kliklaptop/presentation/customer/bloc/transaksipembelian/transaksipembelian_bloc.dart';

class DetailTransaksiPembelianScreen extends StatelessWidget {
  final Data transaksi;

  const DetailTransaksiPembelianScreen({super.key, required this.transaksi});

  @override
  Widget build(BuildContext context) {
    Uint8List? buktiImage;
    if (transaksi.buktiPembayaran != null) {
      try {
        buktiImage = base64Decode(transaksi.buktiPembayaran!);
      } catch (_) {}
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Wrap(
        runSpacing: 16,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text(
            transaksi.namaProduk ?? 'Produk tidak diketahui',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          buildRow("Pembeli", transaksi.namaUser ?? "-"),
          buildRow("Metode", transaksi.metodePembayaran ?? "-"),
          buildRow("Status", transaksi.status ?? "-"),
          const Divider(),

          // Bukti Pembayaran
          if (buktiImage != null) ...[
            const Text(
              "Bukti Pembayaran:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.memory(
                buktiImage,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ],

          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditTransaksiPembelianScreen(
                          transaksiId: transaksi.id!,
                          initialStatus: transaksi.status ?? '',
                          initialMetode: transaksi.metodePembayaran ?? '',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text("Edit"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade600,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    _showDeleteConfirmation(context);
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text("Hapus"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildRow(String label, String value) {
    return Row(
      children: [
        Text("$label: ",
            style: const TextStyle(fontWeight: FontWeight.bold)),
        Expanded(child: Text(value)),
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Konfirmasi Hapus"),
        content: const Text("Apakah Anda yakin ingin menghapus transaksi ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              // Lanjut hapus
              context.read<TransaksiPembelianBloc>().add(
                    DeleteTransaksiPembelian(id: transaksi.id!),
                  );
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
