class mailbox{
  int? id_in;
  int? id_out;
  String dokumen;

  mailbox(
      this.id_in,
      this.id_out,
      this.dokumen
      );

  factory mailbox.fromJson(Map<String,dynamic>json){
    return mailbox(
      json['id_in'] as int ?,
      json['id_out']as int ?,
      json['dokumen'] as String,
    );
  }
  Map<String,dynamic> toJson()=>{
    'id_in':id_in ,
    'id_out':id_out ,
    'dokumen':dokumen,
  };
}