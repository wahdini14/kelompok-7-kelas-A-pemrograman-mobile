void main() {
  // Daftar harga barang
  Map<String, int> harga = {
    'Buku': 20000,
    'Pulpen': 5000,
    'Tas': 100000,
    'Sepatu': 250000,
  };

  // Daftar belanjaan
  List<String> belanjaan = [
    'Buku',
    'Pulpen',
    'Tas',
    'Sepatu'
  ];

  // Menghitung total harga
  int total = hitungTotal(harga, belanjaan);

  // Menentukan diskon
  double diskon = hitungDiskon(total);

  // Menghitung total akhir
  double totalAkhir = total - (total * diskon);

  print('=== STRUK BELANJA ===');

  print('Daftar Belanja:');
  for (String barang in belanjaan) {
    print('$barang = Rp${harga[barang]}');
  }

  print('\nTotal belanja : Rp$total');
  print('Diskon        : ${(diskon * 100).toInt()}%');
  print('Total akhir   : Rp$totalAkhir');
}


// Function untuk menghitung total belanja
int hitungTotal(
    Map<String, int> harga,
    List<String> belanjaan) {
  int total = 0;

  for (String barang in belanjaan) {
    total += harga[barang]!;
  }

  return total;
}


// Function untuk menentukan diskon
double hitungDiskon(int total) {
  if (total >= 300000) {
    return 0.20; // 20%
  } else if (total >= 200000) {
    return 0.10; // 10%
  } else if (total >= 100000) {
    return 0.05; // 5%
  } else {
    return 0.0; // Tidak ada diskon
  }
}