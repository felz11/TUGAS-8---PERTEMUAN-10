import 'package:flutter/material.dart';
import '../api/api_service.dart';
import '../model/produk.dart';
import 'produk_detail.dart';
import 'produk_form.dart';

class ProdukPage extends StatefulWidget {
  const ProdukPage({super.key});

  @override
  State<ProdukPage> createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {
  late Future<List<Produk>> futureProduk;

  @override
  void initState() {
    super.initState();
    futureProduk = ApiService.getProduk();
  }

  void refreshList() {
    setState(() {
      futureProduk = ApiService.getProduk();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Produk"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProdukForm(onSaved: refreshList),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Produk>>(
        future: futureProduk,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Tidak ada data"));
          }

          final produkList = snapshot.data!;

          return ListView.builder(
            itemCount: produkList.length,
            itemBuilder: (context, index) {
              final p = produkList[index];

              return ListTile(
                title: Text(p.namaProduk ?? ""),
                subtitle: Text(
                  "Kode: ${p.kodeProduk} — Harga: ${p.hargaProduk}",
                ),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ProdukDetail(produk: p, refresh: refreshList),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
