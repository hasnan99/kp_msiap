class Log{
  String user_edit;
  String keterangan;
  String date_Edit;

  Log(
      this.user_edit,
      this.keterangan,
      this.date_Edit
      );
  factory Log.fromJson(Map<String,dynamic>json){
    return Log(
      json['user_edit'] as String,
      json['keterangan'] as String,
      json['date_edit'] as String,
    );
  }
  Map<String,dynamic>toJson()=>{
    'user_edit':user_edit,
    'keterangan':keterangan,
    'date_edit':date_Edit,
  };
}