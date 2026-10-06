enum StatusBuku { tersedia, dipinjam }

// Pakai final karena batas hari pinjam adalah aturan tetap 
final int batasHariPinjam = 3;

StatusBuku statusBukuA = StatusBuku.tersedia; // saya masih pakai data manual
int jumlahPinjamBuku = 2;

// function hitung denda kalo telat balikin
int hitungDenda(int durasiPinjam) {
  if (durasiPinjam > batasHariPinjam) {
    // Pakai final karena nilai telat tidak diubah lagi setelah dihitung
    final int hariTerlambat = durasiPinjam - batasHariPinjam;
    return hariTerlambat * 1000;
  } 
    return 0;
}

// --function dibawah adalah function buat pinjam buku sekalian ngecek br-01 dan br-02---
String pinjamBuku() {
  // Cek ketersediaan buku dulu
  if (statusBukuA == StatusBuku.dipinjam) {
    return "Gagal: MAAF BUKU TIDAK TERSEDIA";
  }
  // Lalu cek kuota minjam
  if (jumlahPinjamBuku >= 3) {
    return "Gagal: MAKSIMAL PINJAM 3 BUKU";
  }

  jumlahPinjamBuku += 1;
  statusBukuA = StatusBuku.dipinjam;
  return "Berhasil Pinjam Buku";
}

// function dibawah buat balikin buku dan ngecek kena denda atau ngga
String kembalikanBuku(int durasiPinjam) {
  jumlahPinjamBuku -= 1;
  statusBukuA = StatusBuku.tersedia;

  // Pakai final karena nilai denda tidak diubah lagi setelah memanggil hitungDenda
  final int denda = hitungDenda(durasiPinjam);
  if (denda > 0) {
    return "Berhasil dikembalikan. Kamu terlambat! Denda: Rp${denda}";
  }
  return "Berhasil dikembalikan tepat waktu.";
}

//function buat ngecek status bukunya ada di rak atau ngga
String cekStatusBuku() {
  if (statusBukuA == StatusBuku.tersedia) {
    return "Info: Buku saat ini TERSEDIA di rak.";
  } 
    return "Info: Buku saat ini sedang DIPINJAM.";
}

void main() {
  print(' Simulasi Perpustakaan Mulai ');

  print('1. ' + pinjamBuku()); // Berhasil Pinjam Buku

  print('2. ' + pinjamBuku()); // buku gak tersedia

  print('3. ' + cekStatusBuku()); // buku lagi di pinjam

  print('4. ' + kembalikanBuku(5)); // ini berhasil di kembalikan dan angka di situ buat parameter hari dia pinjem nya
  
  jumlahPinjamBuku = 3; // simulasi kuota habis karna maks pinjam 3 buku
  print('5. ' + pinjamBuku());

  print('--- SIMULASI SELESAI ---');
}
