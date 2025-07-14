import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliklaptop/data/model/response/transaksi_pembelian_response_model.dart';
import 'package:kliklaptop/presentation/customer/bloc/transaksipembelian/transaksipembelian_bloc.dart';

class CustomerStatusAktifPembelian extends StatefulWidget {
  const CustomerStatusAktifPembelian({super.key});

  @override
  State<CustomerStatusAktifPembelian> createState() => _CustomerStatusAktifPembelianState();
}

class _CustomerStatusAktifPembelianState extends State<CustomerStatusAktifPembelian> {
  @override
  void initState() {
    super.initState();
    context.read<TransaksiPembelianBloc>().add(GetUserTransaction());
  }

  Future<void> _refresh() async {
    context.read<TransaksiPembelianBloc>().add(GetUserTransaction());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: BlocBuilder<TransaksiPembelianBloc, TransaksiPembelianState>(
          builder: (context, state) {
            if (state is TransaksiPembelianLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is TransaksiPembelianFailure) {
              return Center(child: Text("❌ ${state.error}"));
            }

            if (state is TransaksiPembelianListSuccess) {
              final transaksiList = state.transaksiList;

              if (transaksiList.isEmpty) {
                return const Center(child: Text("Tidak ada transaksi aktif."));
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: transaksiList.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final transaksi = transaksiList[index];

                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      title: Text(
                        transaksi.namaProduk ?? "Produk tidak ditemukan",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 6),
                          Text("Metode: ${transaksi.metodePembayaran ?? "-"}"),
                          Text("Status: ${transaksi.status}"),
                          if (transaksi.createdAt != null)
                            Text("Dipesan: ${transaksi.createdAt!}"),
                        ],
                      ),
                      onTap: () {
                        // Bisa tambahkan navigasi ke detail di sini jika diperlukan
                      },
                    ),
                  );
                },
              );
            }

            return const SizedBox(); // Default kosong jika tidak ada state
          },
        ),
      ),
    );
  }
}
