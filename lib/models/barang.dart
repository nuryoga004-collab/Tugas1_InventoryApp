
class Barang {
  final int? id;
  final String kode;
  final String nama;
  final String kategori;
  final int jumlah;
  final double harga;
  final String? lokasi;
  final String? tanggal;

  Barang({
    this.id,
    required this.kode,
    required this.nama,
    required this.kategori,
    required this.jumlah,
    required this.harga,
    this.lokasi,
    this.tanggal,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'kode': kode,
      'nama': nama,
      'kategori': kategori,
      'jumlah': jumlah,
      'harga': harga,
      'lokasi': lokasi,
      'tanggal': tanggal,
    };
  }

  factory Barang.fromMap(Map<String, dynamic> map) {
    return Barang(
      id: map['id'] as int?,
      kode: map['kode'] as String,
      nama: map['nama'] as String,
      kategori: map['kategori'] as String,
      jumlah: map['jumlah'] as int,
      harga: (map['harga'] as num).toDouble(),
      lokasi: map['lokasi'] as String?,
      tanggal: map['tanggal'] as String?,
    );
  }
}
