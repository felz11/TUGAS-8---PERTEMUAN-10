import 'package:flutter/material.dart';
import '../model/produk.dart';
import '../api/api_service.dart';

class ProdukForm extends StatefulWidget {
  final Produk? produk;
  final Function()? onSaved;

  const ProdukForm({super.key, this.produk, this.onSaved});

  @override
  State<ProdukForm> createState() => _ProdukFormState();
}

class _ProdukFormState extends State<ProdukForm> {
  final formKey = GlobalKey<FormState>();
  TextEditingController kodeCtrl = TextEditingController();
  TextEditingController namaCtrl = TextEditingController();
  TextEditingController hargaCtrl = TextEditingController();

  bool get isUpdate => widget.produk != null;

  @override
  void initState() {
    super.initState();
    if (isUpdate) {
      kodeCtrl.text = widget.produk!.kodeProduk!;
      namaCtrl.text = widget.produk!.namaProduk!;
      hargaCtrl.text = widget.produk!.hargaProduk.toString();
    }
  }

  Future<void> simpan() async {
    if (formKey.currentState!.validate()) {
      Produk p = Produk(
        id: isUpdate ? widget.produk!.id : null,
        kodeProduk: kodeCtrl.text,
        namaProduk: namaCtrl.text,
        hargaProduk: int.parse(hargaCtrl.text),
      );

      bool success;

      if (isUpdate) {
        success = await ApiService.updateProduk(p);
      } else {
        success = await ApiService.tambahProduk(p);
      }

      if (success) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Berhasil disimpan")));
        widget.onSaved?.call();
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Gagal menyimpan")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isUpdate ? "Ubah Produk" : "Tambah Produk")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: kodeCtrl,
                decoration: const InputDecoration(labelText: "Kode Produk"),
                validator: (v) => v!.isEmpty ? "Kode tidak boleh kosong" : null,
              ),
              TextFormField(
                controller: namaCtrl,
                decoration: const InputDecoration(labelText: "Nama Produk"),
                validator: (v) => v!.isEmpty ? "Nama tidak boleh kosong" : null,
              ),
              TextFormField(
                controller: hargaCtrl,
                decoration: const InputDecoration(labelText: "Harga"),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v!.isEmpty ? "Harga tidak boleh kosong" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: simpan,
                child: Text(isUpdate ? "Ubah" : "Simpan"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
