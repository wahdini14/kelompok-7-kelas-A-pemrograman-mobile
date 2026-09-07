void main() {
  Map<String, double> hargaBarang = {
    "Baju": 150000,
    "Celana": 50000,
    "Tas": 100000,
    "Sepatu": 250000,
  };

  List<String> daftarBelanjaan = [
    "Baju",
    "Celana",
    "Tas",
    "Sepatu"
  ];

  double totalBelanja = hitungTotal(hargaBarang, daftarBelanjaan);
  double diskon = hitungDiskon(totalBelanja);
  double totalAkhir = totalBelanja - diskon;

  print("===== STRUK BELANJA =====");

  print("Daftar Belanja:");
  for (String barang in daftarBelanjaan) {
    print("- $barang : Rp${hargaBarang[barang]}");
  }

  print("-------------------------");
  print("Total Belanja : Rp$totalBelanja");
  print("Diskon        : Rp$diskon");
  print("Total Akhir   : Rp$totalAkhir");
}


double hitungTotal(
    Map<String, double> harga,
    List<String> belanjaan) {

  double total = 0;

  for (String barang in belanjaan) {
    total += harga[barang]!;
  }

  return total;
}


double hitungDiskon(double total) {
  double diskon;

  if (total >= 500000) {
    // Diskon 20% jika belanja >= Rp500.000
    diskon = total * 0.20;
  } else if (total >= 300000) {
    // Diskon 15% jika belanja >= Rp300.000
    diskon = total * 0.15;
  } else if (total >= 100000) {
    // Diskon 10% jika belanja >= Rp100.000
    diskon = total * 0.10;
  } else {
    // Tidak mendapatkan diskon
    diskon = 0;
  }

  return diskon;
}