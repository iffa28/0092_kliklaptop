import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kliklaptop/data/repository/servicebyadmin_repository.dart';
import 'package:kliklaptop/presentation/admin/bloc/servicebyadmin/servicebyadmin_bloc.dart';
import 'package:kliklaptop/presentation/admin/pembayaran_service_admin.dart';
import 'package:kliklaptop/presentation/services/service_http_client.dart';

class DetailPerbaikanAdminScreen extends StatelessWidget {
  final int serviceRequestId;

  const DetailPerbaikanAdminScreen({super.key, required this.serviceRequestId});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');

    return BlocProvider(
      create: (_) => ServicebyadminBloc(
        serviceadminRepo: ServiceByAdminRepository(ServiceHttpClient()),
      )..add(GetServiceByAdminByServiceRequestId(serviceRequestId: serviceRequestId)),
      child: Scaffold(
        body: BlocBuilder<ServicebyadminBloc, ServiceByAdminState>(
          builder: (context, state) {
            if (state is ServiceByAdminLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ServiceByAdminFailure) {
              return Center(child: Text('❌ ${state.error}'));
            } else if (state is ServiceByAdminDetailSuccess) {
              final s = state.service;

              final belumDikonfirmasi = s.namaServis == null || s.namaServis!.isEmpty;

              if (belumDikonfirmasi) {
                return const Center(
                  child: Text(
                    "🔔 Belum dikonfirmasi admin",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                );
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Detail Perbaikan oleh Admin',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailItem('Nama Servis', s.namaServis ?? '-'),
                    _buildDetailItem('Biaya Servis', currencyFormat.format(s.biayaServis ?? 0)),
                    _buildDetailItem('Total Biaya', currencyFormat.format(s.totalBiaya ?? 0)),
                    _buildDetailItem(
                      'Tanggal',
                      s.createdAt != null
                          ? DateFormat('dd MMM yyyy').format(s.createdAt!)
                          : '-',
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Sparepart yang Digunakan',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    if (s.serviceSpareparts != null && s.serviceSpareparts!.isNotEmpty)
                      ...s.serviceSpareparts!.map((sp) {
                        final harga = int.tryParse(
                              sp.sparepart?.hargaSatuan
                                      ?.replaceAll('.', '')
                                      .replaceAll(',', '') ??
                                  '0',
                            ) ??
                            0;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(child: Text(sp.sparepart?.namaSparepart ?? '-')),
                              Text(currencyFormat.format(harga)),
                            ],
                          ),
                        );
                      }).toList()
                    else
                      const Text('-'),
                    const SizedBox(height: 30),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: s.id != null
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        PembayaranServiceAdmin(serviceId: serviceRequestId),
                                  ),
                                );
                              }
                            : null,
                        icon: const Icon(Icons.payment),
                        label: const Text('Lanjut ke Pembayaran'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox(); // Default fallback
          },
        ),
      ),
    );
  }

  Widget _buildDetailItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
