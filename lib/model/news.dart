class news{
  int id;
  String nama_user;
  String nama_file;
  String link_file;
  String timestamp;

  news(
      this.id,
      this.nama_user,
      this.nama_file,
      this.link_file,
      this.timestamp,
      );

  factory news.fromJson(Map<String,dynamic>json){
    return news(
      json['id'] as int,
      json['nama_user'] as String,
      json['nama_file'] as String,
      json['link_file'] as String,
      json['timestamp'] as String,

    );
  }
  Map<String,dynamic> toJson()=>{
    'id':id ,
    'nama_user':nama_user,
    'nama_file':nama_file,
    'link_file':link_file,
    'timestamp':timestamp,
  };
}