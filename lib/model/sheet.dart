
class sheet{
  int Id;
  String nama_aset;
  String jenis_aset;
  String kondisi;
  String status_pemakaian;
  int utilisasi;
  int tahun_perolehan;
  int umur_teknis;
  String sumber_dana;
  int nilai_perolehan;
  int nilai_buku;
  String rencana_optimisasi;
  String lokasi;
  String gambar;
  String user;
  String timestamp;

  sheet(
      this.Id,
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
      this.gambar,
      this.user,
      this.timestamp);

  factory sheet.fromJson(Map<String,dynamic>json){
    return sheet(
      json['Id'] as int,
      json['nama_asset'] as String,
      json['jenis_asset'] as String,
      json['kondisi'] as String,
      json['status_pemakaian'] as String,
      json['utilisasi'] as int,
      json['tahun_perolehan'] as int,
      json['umur_teknis'] as int,
      json['sumber_dana'] as String,
      json['nilai_perolehan'] as int,
      json['nilai_buku'] as int,
      json['rencana_optimisasi'] as String,
      json['lokasi'] as String,
      json['gambar'] as String,
      json['user_edit'] as String,
      json['date_edit'] as String,
    );
  }
  Map<String,dynamic> toJson()=>{
      'Id':Id ,
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
      'user':user,
      'timestamp':timestamp
    };
}