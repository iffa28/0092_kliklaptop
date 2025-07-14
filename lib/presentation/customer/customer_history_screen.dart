import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kliklaptop/data/model/response/servicerequest_response_model.dart';
import 'package:kliklaptop/presentation/customer/bloc/servicer_request/service_request_bloc.dart';

class CustomerHistoryScreen extends StatefulWidget {
  const CustomerHistoryScreen({super.key});

  @override
  State<CustomerHistoryScreen> createState() => _CustomerHistoryScreenState();
}

class _CustomerHistoryScreenState extends State<CustomerHistoryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ServiceRequestBloc>().add(GetUserHistoryService());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Servis'),
        backgroundColor: const Color(0xff1F509A),
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<ServiceRequestBloc, ServiceRequestState>(
        builder: (context, state) {
          if (state is ServiceRequestLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ServiceRequestFailure) {
            return Center(child: Text("❌ ${state.error}"));
          } else if (state is ServiceRequestListSuccess) {
            final historyList = state.serviceList;

            if (historyList.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history, size: 80, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      "Belum ada riwayat servis",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: historyList.length,
              itemBuilder: (context, index) {
                final item = historyList[index];
                return _buildHistoryCard(item);
              },
            );
          }

          return const SizedBox(); // fallback
        },
      ),
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
