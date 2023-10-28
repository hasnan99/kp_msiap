class sheet{
  String? id;
  String nama_asset;
  String? merk;
  String? tipe_mesin;
  String? kategori_fungsi_mesin;
  String? raw_material;
  String? jenis_asset;
  String? kondisi;
  String? status_pemakaian;
  int? utilisasi;
  int? tahun_perolehan;
  int? umur_teknis;
  String? sumber_dana;
  int? nilai_perolehan;
  int? nilai_perolehan_dollar;
  int? nilai_buku;
  String? rencana_optimisasi;
  String? lokasi;
  String? gambar;
  String? data_sheet;
  String? kartu_mesin;
  String? kartu_elektronik;
  String? user_edit;
  String? date_edit;

  sheet(
      this.id,
      this.nama_asset,
      this.merk,
      this.tipe_mesin,
      this.kategori_fungsi_mesin,
      this.raw_material,
      this.jenis_asset,
      this.kondisi,
      this.status_pemakaian,
      this.utilisasi,
      this.tahun_perolehan,
      this.umur_teknis,
      this.sumber_dana,
      this.nilai_perolehan,
      this.nilai_perolehan_dollar,
      this.nilai_buku,
      this.rencana_optimisasi,
      this.lokasi,
      this.gambar,
      this.data_sheet,
      this.kartu_mesin,
      this.kartu_elektronik,
      this.user_edit,
      this.date_edit
      );

  factory sheet.fromJson(Map<String,dynamic>json){
    return sheet(
      json['id'] as String,
      json['nama_asset'] as String,
      json['merk'] as String?,
      json['tipe_mesin'] as String?,
      json['kategori_fungsi_mesin'] as String?,
      json['raw_material'] as String?,
      json['jenis_asset'] as String?,
      json['kondisi'] as String?,
      json['status_pemakaian'] as String?,
      int.tryParse(json['utilisasi'].toString())??0,
      int.tryParse(json['tahun_perolehan'].toString()) ?? 0,
      int.tryParse(json['umur_teknis'].toString())??0,
      json['sumber_dana'] as String?,
      int.tryParse(json['nilai_perolehan'].toString())??0,
      int.tryParse(json['nilai_perolehan_dollar'].toString())??0,
      int.tryParse(json['nilai_buku'].toString())??0,
      json['rencana_optimisasi'] as String?,
      json['lokasi'] as String?,
      json['gambar'] as String?,
      json['data_sheet'] as String?,
      json['kartu_mesin'] as String?,
      json['kartu_elektronik'] as String?,
      json['user_edit'] as String?,
      json['date_edit'] as String?,
    );
  }
  Map<String,dynamic> toJson()=>{
      'id':id??'',
      'nama_asset':nama_asset ?? [''],
      'merk':merk ?? [''],
      'tipe_mesin':tipe_mesin ?? [''],
      'kategori_fungsi_mesin':kategori_fungsi_mesin ?? [''],
      'jenis_asset':jenis_asset ?? [''],
      'kondisi':kondisi ?? [''],
      'status_pemakaian':status_pemakaian ?? [''],
      'utilisasi':utilisasi??0,
      'tahun_perolehan':tahun_perolehan ??  0,
      'umur_teknis':umur_teknis ?? 0,
      'sumber_dana':sumber_dana??[''],
      'nilai_perolehan':nilai_perolehan??0,
      'nilai_perolehan_dollar':nilai_perolehan_dollar??0,
      'nilai_buku':nilai_buku??0,
      'rencana_optimisasi':rencana_optimisasi??[''],
      'lokasi':lokasi??[''],
      'gambar':gambar??[''],
      'data_sheet':data_sheet??[''],
      'kartu_mesin':kartu_mesin??[''],
      'kartu_elektronik':kartu_elektronik??[''],
      'user_edit':user_edit??[''],
      'date_edit':date_edit??[''],
    };
}