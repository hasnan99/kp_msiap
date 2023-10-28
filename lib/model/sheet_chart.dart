class sheet_chart{
  String? Id;
  String? nama_aset;
  String? jenis_aset;
  String? kondisi;
  String? status_pemakaian;
  int? utilisasi;
  int? tahun_perolehan;
  int? umur_teknis;
  String? sumber_dana;
  int? nilai_perolehan;
  int? nilai_buku;
  String? rencana_optimisasi;

  sheet_chart(
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
      this.rencana_optimisasi,);

  factory sheet_chart.fromJson(Map<String,dynamic>json){
    return sheet_chart(
      json['id'] as String,
      json['nama_asset'] as String?,
      json['jenis_asset'] as String?,
      json['kondisi'] as String?,
      json['status_pemakaian'] as String?,
      json['utilisasi'] as int?,
      int.tryParse(json['tahun_perolehan'].toString()) ?? 0,
      json['umur_teknis'] as int?,
      json['sumber_dana'] as String?,
      json['nilai_perolehan'] as int?,
      json['nilai_buku'] as int?,
      json['rencana_optimisasi'] as String?,
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
  };

  @override
  String toString() {
    return 'id: $Id, nama_aset: $nama_aset, jenis_aset: $jenis_aset, kondisi: $kondisi, status_pemakaian: $status_pemakaian, utilisasi: $utilisasi, tahun_perolehan: $tahun_perolehan, umur_teknis: $umur_teknis, sumber_dana: $sumber_dana, nilai_perolehan: $nilai_perolehan, nilai_buku: $nilai_buku, rencana_optimisasi: $rencana_optimisasi';
  }

  int countData(List<sheet_chart> data, String property, Object value) {
    return data.where((item) => item.getProperty(property) == value).length;
  }

  Object? getProperty(String attribute) {
    switch (attribute) {
      case 'nama_aset':
        return nama_aset ?? "";
      case 'jenis_aset':
        return jenis_aset ?? "";
      case 'kondisi':
        return kondisi ?? "";
      case 'status_pemakaian':
        return status_pemakaian ?? "";
      case 'utilisasi':
        return utilisasi??0;
      case 'tahun_perolehan':
        return tahun_perolehan??0;
      case 'umur_teknis':
        return umur_teknis??0;
      case 'sumber_dana':
        return sumber_dana ?? "";
      case 'nilai_perolehan':
        return nilai_perolehan??0;
      case 'nilai_buku':
        return nilai_buku??0;
      case 'rencana_optimisasi':
        return rencana_optimisasi??"";

      default:
        return '';
    }
  }
}