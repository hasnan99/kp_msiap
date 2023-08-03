class sheet_add{
  String nama_aset;
  String jenis_aset;
  String kondisi;
  String status_pemakaian;
  String utilisasi;
  String tahun_perolehan;
  String umur_teknis;
  String sumber_dana;
  String nilai_perolehan;
  String nilai_buku;
  String rencana_optimisasi;
  String lokasi;
  String gambar;

  sheet_add(
      this.nama_aset,
      this.jenis_aset,
      this.kondisi,
      this.status_pemakaian,
      this.utilisasi,
      this.tahun_perolehan,
      this.umur_teknis,
      this.sumber_dana,
      this.nilai_perolehan,
      this.nilai_buku,
      this.rencana_optimisasi,
      this.lokasi,
      this.gambar);

  factory sheet_add.fromJson(Map<String,dynamic>json){
    return sheet_add(
        "${json['Nama_Aset'].toString()}",
        "${json['Jenis_Aset'].toString()}",
        "${json['Kondisi'].toString()}",
        "${json['Status_Pemakaian'].toString()}",
        "${json['Utilisasi'].toString()}",
        "${json['Tahun_Perolehan'].toString()}",
        "${json['Umur_teknis'].toString()}",
        "${json['Sumber_Dana'].toString()}",
        "${json['Nilai_Perolehan'].toString()}",
        "${json['Nilai_Buku'].toString()}",
        "${json['Rencana_Optimisasi'].toString()}",
        "${json['Lokasi'].toString()}",
        "${json['gambar'].toString()}");
  }
  Map<String,dynamic> toJson()=>{
    'nama_aset':nama_aset,
    'jenis_aset':jenis_aset,
    'kondisi':kondisi,
    'status_pemakaian':status_pemakaian,
    'utilisasi':utilisasi,
    'tahun_perolehan':tahun_perolehan,
    'umur_teknis':umur_teknis,
    'sumber_dana':sumber_dana,
    'nilai_perolehan':nilai_perolehan,
    'nilai_buku':nilai_buku,
    'rencana_optimisasi':rencana_optimisasi,
    'lokasi':lokasi,
    'gambar':gambar,
  };
}