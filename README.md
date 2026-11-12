# MXLIB

Library UI Roblox satu file (MX HUB). Tidak ada backend, tidak ada panggilan jaringan, tidak ada `loadstring` di dalam lib.

```lua
local MXLIB = loadstring(game:HttpGet("https://raw.githubusercontent.com/MXHUBOFCL/MXHUB/refs/heads/main/MXLIB.lua"))()
```

## Struktur

```
MXLIB.lua        hasil build, ini yang dipakai lewat loadstring
build.py         gabungkan src/ menjadi MXLIB.lua
manifest.json    urutan modul
MXLIB.d.luau     tipe API
LICENSE          MIT
THIRD_PARTY_NOTICES.md  lisensi Lucide dan lucide-roblox
assets/          rounded-slice.png untuk aset sendiri
examples/        contoh pemakaian
src/
  api/           CreateWindow, tab, bahasa
  core/          bootstrap, input, config manager, viewport, dragging
  utility/       helper, tombol, primitif UI
  themes/        base.lua, accents.lua, presets/ (satu file per tema)
  icons/         resolver ikon dan data/
  i18n/          kamus terjemahan
  components/    popup, watermark, glass blur
  pages/         Community dan Home
  window/        engine jendela, tab/, items/, builtin/
```

Build: `python3 build.py`

## Window

```lua
local window = MXLIB:CreateWindow({
	name = "Example",
	version = "1.0.0",
	theme = "cobalt",
	menuKey = Enum.KeyCode.F3,
	community = true,
	home = true,
	settings = true,
})
```

| Opsi | Fungsi |
| --- | --- |
| `name` | Nama hub (footer, folder config) |
| `version` | Versi yang tampil di Home |
| `theme` | Preset awal. Dipakai hanya jika pemain belum memilih tema sendiri |
| `accent` | Warna aksen window |
| `menuKey` | Tombol buka/tutup, default `F3` |
| `community` `home` `settings` | `false` menyembunyikan tab bawaan. Urutan: Community, Home, Settings |
| `discord` `donate` | Tautan di tab Community dan Home |
| `icon` `image` `background` `logo` | Gambar tombol, window, latar, dan logo Home |
| `iconRail` | Sidebar ikon saja |
| `toggleKeybinds` | Tampilkan keybind di semua toggle |
| `translations` | `{ fr = { ["Teks"] = "Terjemahan" } }` |
| `language` | Bahasa awal, misalnya `"fr"` |
| `configFolder` | Folder config di `MX HUB/` |

Tab Settings berisi Interface (Lock UI, Watermark), Tools (Anti AFK, FPS Boost), Theme, dan Config. Handle resize tidak terlihat, tetapi jendela bisa diubah ukurannya dari tepi kanan, tepi bawah, dan pojok kanan bawah.

Kartu pengguna di sidebar (avatar, nama, `@username`) membuka panel di sampingnya:

| Baris | Isi |
| --- | --- |
| Language | Daftar bahasa dengan kolom pencarian |
| Menu Scale | Slider 50 sampai 150, diterapkan saat dilepas; chip `AUTO` mengembalikan ke otomatis |
| Style | Warna aksen |
| Theme | Daftar preset dengan titik warna |
| Menu Key | Tombol buka/tutup jendela |
| Unload | Menutup MXLIB |

Menekan baris yang sedang terbuka menutup sub-menunya.

### Config

Tab Settings, sub-tab Configs: Profile (pilih, simpan, muat, timpa, hapus), Automation (Auto Save menyimpan config aktif 1,5 detik setelah perubahan; Load on Start), Share (salin dan impor JSON), dan Reset.

## Tab dan grup

```lua
window:CreateSection({ name = "General" })
local main = window:CreateTab({ name = "Home", icon = 93364949241311 })
window:CreateTab({ name = "Combat" })
```

`window:CreateSection` membuat judul grup di sidebar untuk tab sesudahnya. Di dalam tab, `tab:CreateSection({ name, side = "full" | "left" | "right", open })` membuat kotak. Tanpa itu, elemen masuk ke satu kotak penuh bernama tab.

## Ikon dan gambar

Semua bentuk ini diterima di setiap opsi `icon`:

```lua
icon = 93364949241311
icon = "rbxassetid://93364949241311"
icon = getcustomasset("my-icons/alert.png")
icon = MXLIB.Image.Thumbnail("AvatarHeadShot", game.Players.LocalPlayer.UserId, 150)
icon = "zap"
```

Angka dan string angka otomatis menjadi `rbxassetid://`. Nama ikon memakai 1.573 ikon Lucide yang sudah tertanam di lib (tanpa unduhan). `MXLIB.Image.Normalize(value)` mengembalikan string asset hasil normalisasi, atau `nil` bila tidak valid.

Ikon didukung pada: tab, section, tombol, toggle, slider, dropdown, input, keybind, color picker, paragraf, dan kotak popup. Semuanya dirender lewat `ImageLabel` pada `.Image`.

Gambar yang gagal dimuat diganti ikon `image-off`. Nilai kosong atau tidak valid tidak menimbulkan error.

Pembaruan setelah dibuat:

```lua
local toggle = tab:CreateToggle({ name = "ESP", icon = "eye" })
toggle:SetIcon("rbxassetid://123")
toggle:SetIconColor(Color3.fromRGB(96, 205, 255))
tab:SetIcon("settings")
tab:SetSectionIcon("palette")
```

Catatan: Decal ID biasanya ikut dirender Roblox lewat `rbxassetid://`, tapi jika gambar tampil kosong gunakan Image ID dari decal itu.

## Gambar besar dan karakter

```lua
local banner = tab:CreateImage({
	image = 93364949241311,
	height = 160,
	fit = "cover",
	cornerRadius = 10,
	transparency = 0,
	border = true,
})
banner:SetImage("rbxassetid://123")
banner:SetFit("contain")
banner:SetAspectRatio(16 / 9)
banner:SetSize(200, 120)

tab:CreateCharacter({ side = "right", height = 260 })
```

`CreateImage`: `image`, `height`, `width`, `fit` (`"contain"` atau `"cover"`), `align`, `aspectRatio`, `cornerRadius`, `transparency`, `color`, `border`, `background`. `CreateCharacter`: `side`, `height`, `target` (pemain, UserId, atau nama), `label`. Karakter 3D bisa diputar dengan drag dan diperbarui otomatis saat respawn.

## Elemen

`CreateButton` `CreateToggle` `CreateSlider` `CreateDropdown` `CreateInput` `CreateKeybind` `CreateColorPicker` `CreateParagraph` `CreateLabel` `CreateDivider` `CreateImage` `CreateCharacter`

Opsi umum: `name`, `flag` (disimpan di config), `value`, `callback`, `description`, `icon`. Elemen dengan `flag` bisa dibaca lewat `window:GetFlag("Nama")` atau `window.flags.Nama`.

Catatan perilaku:
- Color picker tidak punya slider alpha, `alpha` selalu `1`.
- `numeric = true` pada input menolak teks bukan angka dan mengembalikan nilai terakhir.

## Popup, tema, bahasa

```lua
window:Popup({ title = "What's new", subtitle = "2.1", boxes = { { title = "A", description = "B" } }, options = { { text = "Got it", style = "primary" } } })
window:ChangeTheme("ember")
window:SetLanguage("fr")
window:Destroy()
```

Tema dan aksen di tab Settings langsung berlaku saat dipilih, tanpa tombol Apply.

Style tombol popup: `primary`, `danger`, atau kosong. Tema bawaan: lihat `MXLIB.Theme.Names()`. Tema baru = satu file di `src/themes/presets/` ditambah ke `manifest.json`.

## Keamanan

Lib tidak membuat permintaan HTTP dan tidak mengeksekusi kode dari luar. Yang ditulis ke disk hanya konfigurasi lokal di folder `MX HUB/` (config, `ui.json`, `theme.json`).

## Lisensi

MXLIB berlisensi MIT (`LICENSE`). Data ikon Lucide dan koordinat sprite dari lucide-roblox ada di `THIRD_PARTY_NOTICES.md` beserta lisensinya. Proyek ini tidak berafiliasi dengan Roblox Corporation.

## Aset

Semua id aset Roblox yang dimuat lib ada di `src/core/assets.lua`. Untuk memakai aset milik sendiri, unggah `assets/rounded-slice.png` dan logo Anda ke akun Roblox Anda, lalu ganti id-nya di file itu dan jalankan `python3 build.py`.

## Blur sidebar

Sidebar mengaburkan game di belakangnya lewat `DepthOfFieldEffect` dan satu `Part` tipis di depan kamera. Efek ini ikut mati saat jendela disembunyikan, di-unload, atau FPS Boost aktif. Area blur berbentuk persegi, jadi sudut membulat sidebar bisa menampakkan sedikit tepi kabur.
