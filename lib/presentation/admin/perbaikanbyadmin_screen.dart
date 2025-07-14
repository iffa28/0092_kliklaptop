import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliklaptop/data/model/response/servicebyadmin_response_model.dart';
import 'package:kliklaptop/presentation/admin/bloc/servicebyadmin/servicebyadmin_bloc.dart';

class PerbaikanByAdminScreen extends StatefulWidget {
  final int serviceId;

  const PerbaikanByAdminScreen({super.key, required this.serviceId});

  @override
  State<PerbaikanByAdminScreen> createState() => _PerbaikanByAdminScreenState();
}

class _PerbaikanByAdminScreenState extends State<PerbaikanByAdminScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaServisController = TextEditingController();
  final _biayaServisController = TextEditingController();

  @override
  void dispose() {
    _namaServisController.dispose();
    _biayaServisController.dispose();
    super.dispose();
  }

  void _submitPerbaikan() {
    if (_formKey.currentState!.validate()) {
      final serviceId = widget.serviceId;
      final namaServis = _namaServisController.text;
      final biayaServis = int.tryParse(_biayaServisController.text) ?? 0;

      final serviceData = DataServiceByAdmin(
        serviceId: serviceId,
        namaServis: namaServis,
        biayaServis: biayaServis,
      );

      context.read<ServicebyadminBloc>().add(
            AddServiceByAdminRequested(
              serviceData: serviceData,
              buktiPembayaran: null, // tambahkan file jika ada
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Input Perbaikan"),
        backgroundColor: const Color(0xff1F509A),
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<ServicebyadminBloc, ServiceByAdminState>(
        listener: (context, state) {
          if (state is ServiceByAdminSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("✅ Perbaikan berhasil disimpan")),
            );
            Navigator.pop(context, true);
          } else if (state is ServiceByAdminFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("❌ ${state.error}")),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is ServiceByAdminLoading;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'ID Permintaan Servis: ${widget.serviceId}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _namaServisController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Servis',
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _biayaServisController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Biaya Servis (Rp)',
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: isLoading ? null : _submitPerbaikan,
                    icon: const Icon(Icons.save),
                    label: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text("Simpan Perbaikan"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff1F509A),
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
