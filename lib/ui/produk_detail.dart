import 'package:flutter/material.dart';
import '../model/produk.dart';
import '../api/api_service.dart';
import 'produk_form.dart';

class ProdukDetail extends StatelessWidget {
  final Produk produk;
  final Function() refresh;

  const ProdukDetail({super.key, required this.produk, required this.refresh});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Produk")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Kode : ${produk.kodeProduk}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text("Nama Produk : ${produk.namaProduk}"),
            Text("Harga : ${produk.hargaProduk}"),
            const SizedBox(height: 30),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ProdukForm(produk: produk, onSaved: refresh),
                      ),
                    );

                    refresh();
                    Navigator.pop(context);
                  },
                  child: const Text("EDIT"),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (c) {
                        return AlertDialog(
                          title: const Text("Konfirmasi"),
                          content: const Text("Yakin hapus data ini?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(c, false),
                              child: const Text("Batal"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(c, true),
                              child: const Text("Hapus"),
                            ),
                          ],
                        );
                      },
                    );

                    if (confirm == true) {
                      await ApiService.deleteProduk(int.parse(produk.id!));
                      refresh();
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("HAPUS"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // (tidak ada fungsi API di sini; gunakan ApiService untuk operasi jaringan)
}
