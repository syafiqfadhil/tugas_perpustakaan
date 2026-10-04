# Latihan — Sistem Perpustakaan 📚

**Nama:** Fadhil Hidayattulloh  
**NIM:** 1124160087  

---

## Bagian A: Dokumen Analisis

### 1. Problem Statement
Sistem perpustakaan membutuhkan program untuk mengelola proses peminjaman dan pengembalian buku. Mahasiswa hanya diperbolehkan meminjam maksimal 3 buku dalam satu waktu. Buku yang berstatus sedang dipinjam tidak dapat dipinjam oleh mahasiswa lain. Waktu maksimal peminjaman adalah 3 hari. Jika mahasiswa mengembalikan buku melewati batas waktu tersebut, sistem akan menghitung dan mengenakan denda sebesar Rp1.000 per hari keterlambatan.

### 2. Actor
Actor utama yang berinteraksi dengan sistem adalah **Sistem/Petugas Perpustakaan** dan **Mahasiswa**.
Input yang diproses oleh sistem meliputi:
* Aksi meminjam buku.
* Aksi mengembalikan buku beserta durasi lama pinjam (dalam hari).
* Pengecekan status buku saat ini di rak.

### 3. Input & Output
**Input**
| Data | Tipe Data | Keterangan |
| :--- | :--- | :--- |
| `durasiPinjam` | `int` | Jumlah hari buku dipinjam (dimasukkan saat proses pengembalian). |

**Output**
| Hasil | Tipe Data | Keterangan |
| :--- | :--- | :--- |
| `Pesan Status` | `String` | Menampilkan hasil transaksi (berhasil/gagal) beserta nilai denda (jika ada). |

### 4. Functional Requirement
1. Sistem dapat mengecek ketersediaan status buku sebelum proses peminjaman.
2. Sistem dapat memvalidasi sisa kuota pinjaman mahasiswa (maksimal 3 buku).
3. Sistem dapat memproses peminjaman, menambah kuota mahasiswa, dan mengubah status buku menjadi dipinjam.
4. Sistem dapat memproses pengembalian buku, memulihkan status buku ke rak, dan mengurangi kuota mahasiswa.
5. Sistem dapat menghitung nominal denda keterlambatan jika durasi pinjam melebihi aturan batas waktu (3 hari).

### 5. Business Rules
| Kode | Business Rule |
| :---: | :--- |
| **BR-01** | Anggota hanya dapat meminjam maksimal 3 buku secara bersamaan. |
| **BR-02** | Buku yang sedang dipinjam tidak dapat dipinjam kembali. |
| **BR-03** | Denda keterlambatan dikenakan sebesar Rp1.000 per hari keterlambatan. |
| **BR-04** | Batas waktu peminjaman buku normal adalah 3 hari. |

### 6. Decomposition
Pemecahan masalah (*decomposition*) dibagi menjadi 4 fungsi utama:
* `hitungDenda` → Menghitung selisih hari dan nominal uang denda.
* `pinjamBuku` → Melakukan validasi awal (*guard clause*) dan mengubah data saat meminjam.
* `kembalikanBuku` → Memulihkan data buku/kuota dan memanggil perhitungan denda.
* `cekStatusBuku` → Mengecek kondisi buku secara *real-time*.

### 7. Pattern Recognition
* **Pola Validasi (Guard Clause):** Setiap proses transaksi selalu mengecek kondisi gagal/penolakan di awal. Jika gagal, eksekusi langsung dihentikan (*early return*).
* **Pola Modifikasi Data (State Mutation):** Peminjaman selalu **menambah (+)** `jumlahPinjamBuku` dan mengubah status menjadi `dipinjam`. Pengembalian melakukan sebaliknya, yaitu **mengurangi (-)** `jumlahPinjamBuku` dan mengubah status menjadi `tersedia`.

### 8. Abstraction
Sistem menyembunyikan kompleksitas data menggunakan tipe data statis dan **Enum**:
* **Enum:** `enum StatusBuku { tersedia, dipinjam }`
* **Variabel Final:** `final int batasHariPinjam = 3` 
* **State Data:** `StatusBuku statusBukuA` dan `int jumlahPinjamBuku`.

### 9. Algorithm
**Algoritma Peminjaman Buku:**
1. Cek status buku. Jika `dipinjam`, return "Gagal: Buku tidak tersedia".
2. Cek kuota buku mahasiswa. Jika >= 3, return "Gagal: Maksimal 3 buku".
3. Jika lolos validasi, tambah `jumlahPinjamBuku` sebanyak 1.
4. Ubah status buku menjadi `dipinjam`.
5. Return "Berhasil Pinjam Buku".

**Algoritma Pengembalian Buku:**
1. Terima input durasi peminjaman (hari).
2. Kurangi `jumlahPinjamBuku` sebanyak 1.
3. Ubah status buku kembali menjadi `tersedia`.
4. Hitung denda: Jika durasi melebihi batas waktu (3 hari), kalikan selisihnya dengan 1000.
5. Jika ada denda, kembalikan pesan info denda. Jika tidak, kembalikan pesan tepat waktu.

### 10. Flowchart (Proses Peminjaman)
```text
[ START ]
    │
    ▼
[ Fungsi pinjamBuku() Dipanggil ]
    │
    ▼
Apakah statusBuku == dipinjam ? ──(YA)──► [ Return: Gagal, Buku Tidak Tersedia ] ──┐
    │                                                                              │
   (TIDAK)                                                                         │
    │                                                                              │
    ▼                                                                              │
Apakah kuotaMahasiswa >= 3 ? ─────(YA)──► [ Return: Gagal, Kuota Maksimal ] ───────┤
    │                                                                              │
   (TIDAK)                                                                         │
    │                                                                              │
    ▼                                                                              │
kuotaMahasiswa = kuotaMahasiswa + 1                                                │
statusBuku = dipinjam                                                              │
    │                                                                              │
    ▼                                                                              │
[ Return: Berhasil Pinjam Buku ]                                                   │
    │                                                                              │
    ├◄─────────────────────────────────────────────────────────────────────────────┘
    ▼
 [ END ]
```

### 11. Pseudocode
```text
START

ENUM StatusBuku { tersedia, dipinjam }
FINAL batasHariPinjam = 3
SET statusBukuA = tersedia
SET jumlahPinjamBuku = 2

FUNCTION hitungDenda(durasiPinjam)
    IF durasiPinjam > batasHariPinjam THEN
        FINAL hariTerlambat = durasiPinjam - batasHariPinjam
        RETURN hariTerlambat * 1000
    ELSE
        RETURN 0
    END IF
END FUNCTION

FUNCTION pinjamBuku()
    IF statusBukuA == dipinjam THEN
        RETURN "Gagal: BUKU TIDAK TERSEDIA"
    END IF
    
    IF jumlahPinjamBuku >= 3 THEN
        RETURN "Gagal: MAKSIMAL PINJAM 3 BUKU"
    END IF

    jumlahPinjamBuku = jumlahPinjamBuku + 1
    statusBukuA = dipinjam
    RETURN "Berhasil Pinjam Buku"
END FUNCTION

FUNCTION kembalikanBuku(durasiPinjam)
    jumlahPinjamBuku = jumlahPinjamBuku - 1
    statusBukuA = tersedia
    
    FINAL denda = CALL hitungDenda(durasiPinjam)
    
    IF denda > 0 THEN
        RETURN "Anda terlambat! Denda: Rp" + denda
    END IF
    
    RETURN "Dikembalikan tepat waktu."
END FUNCTION

END
```

---

## Bagian B: Implementasi Dart (Source Code)

```dart
// =============================================
// HW 2 - Perpustakaan
// Nama : Fadhil Hidayattulloh
// NIM  : 1124160087
// =============================================

// --- Abstraction ---
enum StatusBuku { tersedia, dipinjam }

// Pakai final karena batas hari pinjam adalah aturan tetap 
final int batasHariPinjam = 3; 

StatusBuku statusBukuA = StatusBuku.tersedia; 
int jumlahPinjamBuku = 2; 

// --- Decomposition & Algorithm ---

// Function hitung denda jika telat mengembalikan
int hitungDenda(int durasiPinjam) {
  if (durasiPinjam > batasHariPinjam) {
    // Pakai final karena nilai telat tidak diubah lagi setelah dihitung
    final int hariTerlambat = durasiPinjam - batasHariPinjam;
    return hariTerlambat * 1000;
  } 
  return 0;
}

// Function pinjam buku dan pengecekan BR-01 & BR-02
String pinjamBuku() {
  // Cek ketersediaan buku dulu (Guard Clause)
  if (statusBukuA == StatusBuku.dipinjam) {
    return "Gagal: MAAF BUKU TIDAK TERSEDIA";
  }
  // Lalu cek kuota meminjam
  if (jumlahPinjamBuku >= 3) {
    return "Gagal: MAKSIMAL PINJAM 3 BUKU";
  }

  jumlahPinjamBuku += 1;
  statusBukuA = StatusBuku.dipinjam;
  return "Berhasil Pinjam Buku";
}

// Function kembalikan buku dan cek denda
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

// Function cek status buku saat ini di rak
String cekStatusBuku() {
  if (statusBukuA == StatusBuku.tersedia) {
    return "Info: Buku saat ini TERSEDIA di rak.";
  } else {
    return "Info: Buku saat ini sedang DIPINJAM.";
  }
}

// --- Test Scenario ---
void main() {
  print('--- Simulasi Perpustakaan Mulai ---');

  // Skenario 1: Berhasil meminjam buku
  print('1. ' + pinjamBuku()); 

  // Skenario 2: Gagal karena buku tidak tersedia (sedang dipinjam di skenario 1)
  print('2. ' + pinjamBuku()); 

  // Skenario 3: Mengecek status buku saat ini
  print('3. ' + cekStatusBuku()); 

  // Skenario 4: Berhasil dikembalikan (parameter 5 adalah durasi hari meminjam)
  print('4. ' + kembalikanBuku(5)); 
  
  // Skenario 5: Simulasi kuota habis karena maksimal pinjam 3 buku
  jumlahPinjamBuku = 3; 
  print('5. ' + pinjamBuku());

  print('--- SIMULASI SELESAI ---');
}
```

---

## Bagian C: Hasil Pengujian (Output)
Ketika program dijalankan, sistem menghasilkan output yang sesuai dengan *Business Rules* dan skenario uji yang telah ditetapkan:

```text
--- Simulasi Perpustakaan Mulai ---
1. Berhasil Pinjam Buku
2. Gagal: MAAF BUKU TIDAK TERSEDIA
3. Info: Buku saat ini sedang DIPINJAM.
4. Berhasil dikembalikan. Kamu terlambat! Denda: Rp2000
5. Gagal: MAKSIMAL PINJAM 3 BUKU
--- SIMULASI SELESAI ---
```
