import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliklaptop/data/model/response/servicerequest_response_model.dart';
import 'package:kliklaptop/presentation/customer/bloc/servicer_request/service_request_bloc.dart';
import 'package:kliklaptop/presentation/admin/detail_service_screen.dart'; // pastikan impor ini sesuai path

class ListServiceLaptopScreen extends StatefulWidget {
  const ListServiceLaptopScreen({super.key});

  @override
  State<ListServiceLaptopScreen> createState() =>
      _ListServiceLaptopScreenState();
}

class _ListServiceLaptopScreenState extends State<ListServiceLaptopScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ServiceRequestBloc>().add(
          GetUserService(),
        ); // gunakan event yang ambil data aktif
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Servis Laptop Aktif'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: BlocBuilder<ServiceRequestBloc, ServiceRequestState>(
        builder: (context, state) {
          if (state is ServiceRequestLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ServiceRequestFailure) {
            return Center(
              child: Text(
                'Gagal memuat data: ${state.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (state is ServiceRequestListSuccess) {
            final List<Data> services = state.serviceList;

            if (services.isEmpty) {
              return const Center(
                child: Text('Belum ada servis aktif saat ini.'),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: services.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final service = services[index];

                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailServiceScreen(service: service),
                        ),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.laptop_mac,
                                  size: 28,
                                  color: Colors.indigo,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    service.jenisLaptop ?? 'Jenis tidak diketahui',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                _buildStatusChip(service.status),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Keluhan: ${service.deskripsiKeluhan ?? '-'}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 8),
                            if (service.createdAt != null)
                              Text(
                                'Tanggal: ${service.createdAt!.toLocal().toString().split(' ')[0]}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox(); // fallback
        },
      ),
    );
  }

  Widget _buildStatusChip(String? status) {
    Color color;
    switch (status?.toLowerCase()) {
      case 'menunggu konfirmasi':
        color = Colors.blue;
        break;
      case 'dikonfirmasi':
        color = Colors.orange;
        break;
      case 'sedang diperbaiki':
        color = Colors.purple;
        break;
      case 'perbaikan selesai':
        color = Colors.green;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status ?? '-',
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
