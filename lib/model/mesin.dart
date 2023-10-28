class Mesin{
  String fungsi;
  String? jenis_material;
  String? metode;
  num? dimensi_kecil_panjang;
  num? dimensi_kecil_lebar;
  num? dimensi_kecil_tebal;
  num? dimensi_kecil_diameter;
  num? dimensi_besar_panjang;
  num? dimensi_besar_lebar;
  num? dimensi_besar_tebal;
  num? dimensi_besar_diameter;
  num? berat_kecil;
  num? berat_besar;
  num? panjang_kabel_pendek;
  num? panjang_kabel_panjang;
  num? kapasitas_daya_kecil;
  num? kapasitas_daya_besar;
  num? ketinggian_jatuh_kecil;
  num? ketinggian_jatuh_besar;
  num? frekwensi_kecil;
  num? frekwensi_besar;
  num? acceleration_kecil;
  num? acceleration_besar;
  num? lima_gram_kecil;
  num? lima_gram_besar;
  num? sepuluh_gram_kecil;
  num? sepuluh_gram_besar;
  num? dua_puluh_gram_kecil;
  num? dua_puluh_gram_besar;
  num? tiga_puluh_gram_kecil;
  num? tiga_puluh_gram_besar;
  num? temperature_kecil;
  num? temperature_besar;
  num? humidity_kecil;
  num? humidity_besar;
  num? pulsa_kecil;
  num? pulsa_besar;

  Mesin(
      this.fungsi,
      this.jenis_material,
      this.metode,
      this.dimensi_kecil_panjang,
      this.dimensi_kecil_lebar,
      this.dimensi_kecil_tebal,
      this.dimensi_kecil_diameter,
      this.dimensi_besar_panjang,
      this.dimensi_besar_lebar,
      this.dimensi_besar_tebal,
      this.dimensi_besar_diameter,
      this.berat_kecil,
      this.berat_besar,
      this.panjang_kabel_pendek,
      this.panjang_kabel_panjang,
      this.kapasitas_daya_kecil,
      this.kapasitas_daya_besar,
      this.ketinggian_jatuh_kecil,
      this.ketinggian_jatuh_besar,
      this.frekwensi_kecil,
      this.frekwensi_besar,
      this.acceleration_kecil,
      this.acceleration_besar,
      this.lima_gram_kecil,
      this.lima_gram_besar,
      this.sepuluh_gram_kecil,
      this.sepuluh_gram_besar,
      this.dua_puluh_gram_kecil,
      this.dua_puluh_gram_besar,
      this.tiga_puluh_gram_kecil,
      this.tiga_puluh_gram_besar,
      this.temperature_kecil,
      this.temperature_besar,
      this.humidity_kecil,
      this.humidity_besar,
      this.pulsa_kecil,
      this.pulsa_besar,
      );
  factory Mesin.fromJson(Map<String,dynamic>json){
    return Mesin(
      json['fungsi'] as String,
      json['jenis_material'] as String?,
      json['metode'] as String?,
      json['dimensi-kecil-panjang'] as num?,
      json['dimensi-kecil-lebar'] as num?,
      json['dimensi-kecil-tebal'] as num?,
      json['dimensi-kecil-diameter'] as num?,
      json['dimensi-besar-panjang'] as num?,
      json['dimensi-besar-lebar'] as num?,
      json['dimensi-besar-tebal'] as num?,
      json['dimensi-besar-diameter'] as num?,
      json['berat-kecil'] as num?,
      json['berat-besar'] as num?,
      json['panjang_kabel-pendek'] as num?,
      json['panjang_kabel-panjang'] as num?,
      json['kapasitas_daya-kecil'] as num?,
      json['kapasitas_daya-besar'] as num?,
      json['ketinggian_jatuh-kecil'] as num?,
      json['ketinggian_jatuh-besar'] as num?,
      json['frekwensi_kecil'] as num?,
      json['frekwensi_besar'] as num?,
      json['acceleration_kecil'] as num?,
      json['acceleration_besar'] as num?,
      json['load-5g-kecil'] as num?,
      json['load-5g-besar'] as num?,
      json['load-10g-kecil'] as num?,
      json['load-10g-besar'] as num?,
      json['load-20g-kecil'] as num?,
      json['load-20g-besar'] as num?,
      json['load-30g-kecil'] as num?,
      json['load-30-besar'] as num?,
      json['temperature-kecil'] as num?,
      json['temperature-besar'] as num?,
      json['humidity-kecil'] as num?,
      json['humidity-besar'] as num?,
      json['pulsa-kecil'] as num?,
      json['pulsa-besar'] as num?,
    );
  }

  Map<String,dynamic> toJson()=>{
    'fungsi':fungsi,
    'jenis_material':jenis_material,
    'metode':metode,
    'dimensi-kecil-panjang':dimensi_kecil_panjang,
    'dimensi-kecil-lebar':dimensi_kecil_lebar,
    'dimensi-kecil-tebal':dimensi_kecil_tebal,
    'dimensi-kecil-diameter':dimensi_kecil_diameter,
    'dimensi-besar-panjang':dimensi_besar_panjang,
    'dimensi-besar-lebar':dimensi_besar_lebar,
    'dimensi-besar-tebal':dimensi_besar_tebal,
    'dimensi-besar-diameter':dimensi_besar_diameter,
    'berat-kecil':berat_kecil,
    'berat-besar':berat_besar,
    'panjang_kabel-pendek':panjang_kabel_pendek,
    'panjang_kabel-panjang':panjang_kabel_panjang,
    'kapasitas_daya-kecil':kapasitas_daya_kecil,
    'kapasitas_daya-besar':kapasitas_daya_besar,
    'ketinggian_jatuh-kecil':ketinggian_jatuh_kecil,
    'ketinggian_jatuh-besar':ketinggian_jatuh_besar,
    'frekwensi_kecil':frekwensi_kecil,
    'frekwensi_besar':frekwensi_besar,
    'acceleration_kecil':acceleration_kecil,
    'acceleration_besar':acceleration_besar,
    'lima_gram_kecil':lima_gram_kecil,
    'lima_gram_besar':lima_gram_besar,
    'sepuluh_gram_kecil':sepuluh_gram_kecil,
    'sepuluh_gram_besar':sepuluh_gram_besar,
    'dua_puluh_gram_kecil':dua_puluh_gram_kecil,
    'dua_puluh_gram_besar':dua_puluh_gram_besar,
    'tiga_puluh_gram_kecil':tiga_puluh_gram_kecil,
    'tiga_puluh_gram_besar':tiga_puluh_gram_besar,
    'temperature_kecil':temperature_kecil,
    'temperature_besar':temperature_besar,
    'humidity_kecil':humidity_kecil,
    'humidity_besar':humidity_besar,
    'pulsa_kecil':pulsa_kecil,
    'pulsa_besar':pulsa_besar,
  };
}
