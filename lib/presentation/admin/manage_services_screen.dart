import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kliklaptop/data/model/response/servicerequest_response_model.dart';
import 'package:kliklaptop/presentation/admin/detail_service_screen.dart';
import 'package:kliklaptop/presentation/customer/bloc/servicer_request/service_request_bloc.dart';

class ManageServicesScreen extends StatefulWidget {
  const ManageServicesScreen({super.key});

  @override
  State<ManageServicesScreen> createState() => _ManageServicesScreenState();
}

class _ManageServicesScreenState extends State<ManageServicesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ServiceRequestBloc>().add(GetAllUserServiceRequests());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Permintaan Service'),
        backgroundColor: const Color(0xff1F509A),
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<ServiceRequestBloc, ServiceRequestState>(
        builder: (context, state) {
          if (state is ServiceRequestLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ServiceRequestFailure) {
            return Center(child: Text('❌ ${state.error}'));
          }

          if (state is ServiceRequestListSuccess) {
            final requests = state.serviceList;

            if (requests.isEmpty) {
              return const Center(child: Text('Belum ada permintaan service.'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final Data req = requests[index];
                final date = req.createdAt != null
                    ? DateFormat('dd MMM yyyy, HH:mm').format(req.createdAt!)
                    : '-';

                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      req.jenisLaptop ?? "Tanpa Nama",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text("Status: ${req.status ?? 'Tidak diketahui'}"),
                        const SizedBox(height: 4),
                        Text("Dibuat pada: $date"),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: () {
                        // TODO: Navigasi ke detail
                         Navigator.push(context, MaterialPageRoute(builder: (_) => DetailServiceScreen(service: req)));
                      },
                    ),
                  ),
                );
              },
            );
          }

          return const Center(child: Text('Terjadi kesalahan yang tidak diketahui.'));
        },
      ),
    );
  }
}
