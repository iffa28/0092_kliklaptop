import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:kliklaptop/data/model/response/servicerequest_response_model.dart';
import 'package:kliklaptop/presentation/admin/detail_perbaikan_by_admin.dart';
import 'package:kliklaptop/presentation/admin/perbaikanbyadmin_screen.dart';
import 'package:kliklaptop/presentation/admin/tambah_sparepart_screen.dart';

class DetailServiceScreen extends StatefulWidget {
  final Data service;

  const DetailServiceScreen({super.key, required this.service});

  @override
  State<DetailServiceScreen> createState() => _DetailServiceScreenState();
}

class _DetailServiceScreenState extends State<DetailServiceScreen> {
  String? userRole;

  @override
  void initState() {
    super.initState();
    _loadRole();
  }

  Future<void> _loadRole() async {
    final storage = FlutterSecureStorage();
    final role = await storage.read(key: "userRole");
    setState(() {
      userRole = role;
    });
  }

  @override
  Widget build(BuildContext context) {
    final service = widget.service;

    Uint8List? imageBytes;
    if (service.photo != null && service.photo!.isNotEmpty) {
      try {
        imageBytes = base64Decode(service.photo!);
      } catch (e) {
        debugPrint("❌ Gagal decode foto: $e");
      }
    }

    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Servis'),
        backgroundColor: const Color(0xff1F509A),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageBytes != null)
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(
                    imageBytes,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            const SizedBox(height: 20),
            _buildDetailItem('Jenis Laptop', service.jenisLaptop ?? '-'),
            _buildDetailItem('Deskripsi Keluhan', service.deskripsiKeluhan ?? '-'),
            _buildDetailItem(
              'Status Servis',
              _capitalize(service.status ?? '-'),
              color: _getColorByStatus(service.status),
            ),
            _buildDetailItem(
              'Tanggal Pengajuan',
              service.createdAt != null
                  ? DateFormat('dd MMM yyyy • HH:mm').format(service.createdAt!)
                  : '-',
            ),
            const SizedBox(height: 30),

            /// ✅ Tombol hanya muncul jika admin
            if (userRole == 'admin') ...[
              Center(
                child: ElevatedButton.icon(
                  onPressed: service.id == null
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PerbaikanByAdminScreen(serviceId: service.id!),
                            ),
                          );
                        },
                  icon: const Icon(Icons.build),
                  label: const Text('Konfirmasi Perbaikan'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff1F509A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton.icon(
                  onPressed: service.id == null
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TambahSparepartScreen(serviceByAdminId: service.id!),
                            ),
                          );
                        },
                  icon: const Icon(Icons.settings),
                  label: const Text('Ganti Sparepart'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 20),
            const Divider(color: Colors.grey, thickness: 1),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                if (service.id != null) {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => Container(
                      height: MediaQuery.of(context).size.height * 0.8,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                      ),
                      child: DetailPerbaikanAdminScreen(
                        serviceRequestId: service.id!,
                      ),
                    ),
                  );
                }
              },
              child: const Text(
                'Lihat Detail Perbaikan oleh Admin',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String title, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: color ?? Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  String _capitalize(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1);
  }

  Color _getColorByStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'menunggu konfirmasi':
        return Colors.blue;
      case 'dikonfirmasi':
        return Colors.orange;
      case 'sedang diperbaiki':
        return Colors.purple;
      case 'perbaikan selesai':
        return Colors.green;
      default:
        return Colors.black;
    }
  }
}
