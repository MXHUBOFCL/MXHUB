# Changelog

## 4.2.0

- Lib dinamai MXLIB; hasil build menjadi `MXLIB.lua` dan tipe menjadi `MXLIB.d.luau`; `getgenv().MXLIB` ditambahkan sebagai alias `getgenv().MXHUB`
- Lisensi MIT dan `THIRD_PARTY_NOTICES.md` (Lucide ISC/MIT dan lucide-roblox MIT)
- Semua id aset Roblox dipusatkan di `src/core/assets.lua`; `assets/rounded-slice.png` untuk membuat salinan sendiri
- Dihapus: dua bayangan jendela yang sudah tak terlihat (memuat aset pihak lain), ikon dan nama bermerek (Discord, Spotify), folder `backend` kosong, file konfigurasi linter yang tidak dipakai
- Preset tema `Spotify` dan `Discord` dinamai `Emerald` dan `Indigo`
- Dua penghitung FPS digabung menjadi satu koneksi `RenderStepped`

## 4.1.1

Perbaikan
- Label toggle tidak lagi hilang saat ON (warna teks ikut aksen putih, kini selalu terbaca)
- Area konten kembali opaque; hanya sidebar yang semi-transparan dengan gradasi kaca
- Scrollbar tipis di sisi kanan area konten
- Titik handle resize di pojok dihapus; resize tetap bisa lewat tepi kanan, tepi bawah, dan pojok
- Menekan opsi yang sedang terbuka di panel profil menutup sub-menunya (termasuk Menu Key)
- Opsi Blur dihapus dari Settings, termasuk efek blur layar
- Settings: tambah Anti AFK dan FPS Boost (lokal, dipulihkan saat dimatikan atau unload)
- Palet MX HUB disesuaikan agar kartu dan baris lebih terpisah dari latar

## 4.1.0

Baru
- Ikon di semua komponen (toggle, slider, dropdown, input, keybind, color picker, tombol, paragraf, notifikasi, tab, section) lewat satu resolver, dengan `SetIcon` dan `SetIconColor` untuk pembaruan dinamis
- `MXHUB.Image.Thumbnail` dan `MXHUB.Image.Normalize`; id angka, string, `rbxassetid://`, `rbxthumb://`, dan `getcustomasset`
- Fallback otomatis ke ikon `image-off` bila gambar gagal dimuat
- `tab:CreateImage` (contain/cover, aspect ratio, sudut, transparansi, border) dan `tab:CreateCharacter` (kotak karakter 3D, kiri atau kanan)
- 1.573 ikon Lucide ditanam sebagai data lokal; ikon yang hilang di 4.0.0 kembali

Perubahan tampilan
- Header hanya teks "MX HUB" tanpa logo; judul dan watermark dipaksa "MX HUB"
- Panel profil terbuka di samping sidebar, sejajar kartu pengguna; pratinjau karakter dipindah menjadi komponen terpisah
- Tema MX HUB: gelap netral dengan aksen putih; toggle dan slider mengikuti aksen
- Jendela dan baris lebih transparan (efek kaca)
- Tema, aksen, mode, dan hex di Settings langsung berlaku tanpa tombol Apply

## 4.0.0

Breaking
- API baru: `MXHUB:CreateWindow`, `window:CreateSection/CreateTab`, `tab:Create*`, `window:Notify/Popup/ChangeTheme`
- Semua backend dihapus: key, role, premium/donator, presence, pengumuman, admin, forum, kick/ban
- Fitur lock donator pada elemen dihapus; `Dropdown:Set` dan `Slider:Set` tidak lagi menerima argumen `force`
- Fungsi global `mxhub()` dihapus, pakai `window:Notify`
- Tool hub dihapus dari Settings: FPS Boost, Anti AFK, Mute, Auto Rejoin, Server

Baru
- Tab bawaan Community, Home, Settings bisa dimatikan lewat `community`, `home`, `settings`
- `window:Popup` (dialog modal dengan boxes dan options)
- Ikon: angka asset id, `rbxassetid://`, `getcustomasset`, atau nama Lucide; tombol mendukung ikon
- Sufiks slider, `translations` per window, `MXHUB.Theme`, `MXHUB.Version`
- Tema `Cobalt` dan `Ember`; nama tema tidak peka huruf besar

Perbaikan
- Tidak ada `loadstring` maupun HTTP di dalam lib; paket ikon jarak jauh dihapus
- Lima fungsi global yang bocor dijadikan lokal
- Id ikon 15 digit tidak lagi rusak menjadi notasi ilmiah
- Kode mati dan duplikat dibuang; bundle 574 KB menjadi 389 KB
- Struktur dipecah menjadi modul di `src/`, dibangun ulang dengan `build.py`
