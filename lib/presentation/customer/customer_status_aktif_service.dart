import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliklaptop/data/model/response/servicerequest_response_model.dart';
import 'package:kliklaptop/presentation/admin/detail_service_screen.dart';
import 'package:kliklaptop/presentation/customer/bloc/servicer_request/service_request_bloc.dart';

class CustomerStatusAktifService extends StatefulWidget {
  const CustomerStatusAktifService({super.key});

  @override
  State<CustomerStatusAktifService> createState() => _CustomerStatusAktifServiceState();
}

class _CustomerStatusAktifServiceState extends State<CustomerStatusAktifService> {
  @override
  void initState() {
    super.initState();
    context.read<ServiceRequestBloc>().add(GetUserService());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceRequestBloc, ServiceRequestState>(
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
          final List<Data> activeServices = state.serviceList.where((service) {
            final status = service.status?.toLowerCase();
            return status == 'menunggu konfirmasi' ||
                status == 'dikonfirmasi' ||
                status == 'sedang diperbaiki';
          }).toList();

          if (activeServices.isEmpty) {
            return const Center(
              child: Text('Tidak ada servis aktif saat ini.'),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: activeServices.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final service = activeServices[index];

              return InkWell(
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
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.laptop_mac, color: Color(0xff1F509A), size: 26),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                service.jenisLaptop ?? 'Jenis tidak diketahui',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
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
                        const SizedBox(height: 6),
                        if (service.createdAt != null)
                          Text(
                            'Tanggal: ${service.createdAt!.toLocal().toString().split(' ')[0]}',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }

        return const SizedBox(); // default fallback
      },
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
