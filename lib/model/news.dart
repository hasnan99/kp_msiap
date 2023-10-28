class news{
  int? id_surat;
  String? nomor_surat;
  String? link_file;
  String? nama_file;
  String? mime_type;
  String? url;
  String? date_edit;

  news(
      this.id_surat,
      this.nomor_surat,
      this.link_file,
      this.nama_file,
      this.mime_type,
      this.url,
      this.date_edit,
      );

  factory news.fromJson(Map<String,dynamic>json){
    return news(
      json['id_surat'] as int ?,
      json['nomor_surat'] as String?,
      json['link_file'] as String?,
      json['nama_file'] as String?,
      json['mime_type'] as String?,
      json['url'] as String?,
      json['date_edit'] as String?,

    );
  }
  Map<String,dynamic> toJson()=>{
    'id_surat':id_surat ,
    'nomor_surat':nomor_surat,
    'link_file':link_file,
    'nama_file':nama_file,
    'mime_type':mime_type,
    'url':url,
    'date_edit':date_edit,
  };
}