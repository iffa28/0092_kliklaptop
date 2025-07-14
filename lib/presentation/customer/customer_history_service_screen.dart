import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kliklaptop/data/model/response/servicerequest_response_model.dart';
import 'package:kliklaptop/presentation/customer/bloc/servicer_request/service_request_bloc.dart';

class CustomerHistoryServiceScreen extends StatefulWidget {
  const CustomerHistoryServiceScreen({super.key});

  @override
  State<CustomerHistoryServiceScreen> createState() => _CustomerHistoryServiceScreenState();
}

class _CustomerHistoryServiceScreenState extends State<CustomerHistoryServiceScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ServiceRequestBloc>().add(GetUserHistoryService());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceRequestBloc, ServiceRequestState>(
      builder: (context, state) {
        if (state is ServiceRequestLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ServiceRequestFailure) {
          return Center(child: Text("❌ ${state.error}"));
        } else if (state is ServiceRequestListSuccess) {
          final allList = state.serviceList;

          // Filter hanya status yang "perbaikan selesai" atau "berhasil"
          final filteredList = allList.where((item) {
            final status = item.status?.toLowerCase() ?? '';
            return status == 'berhasil' || status == 'perbaikan selesai';
          }).toList();

          if (filteredList.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    "Belum ada riwayat servis berhasil",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredList.length,
            itemBuilder: (context, index) {
              final item = filteredList[index];
              return _buildHistoryCard(item);
            },
          );
        }

        return const SizedBox(); // Fallback
      },
    );
  }

  Widget _buildHistoryCard(Data item) {
    final status = item.status?.toLowerCase() ?? '';
    final createdAt = item.createdAt != null
        ? DateFormat('dd MMM yyyy').format(item.createdAt!)
        : '-';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        leading: const Icon(Icons.build, color: Color(0xff1F509A)),
        title: Text(
          item.jenisLaptop ?? '-',
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Keluhan: ${item.deskripsiKeluhan ?? '-'}",
              style: const TextStyle(fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              "Tanggal: $createdAt",
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: _buildStatusChip(status),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status) {
      case 'berhasil':
      case 'perbaikan selesai':
        color = Colors.green;
        break;
      case 'gagal':
        color = Colors.red;
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
