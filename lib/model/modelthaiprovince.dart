
class Thaiprovice {
  Thaiprovice({
    required this.district,
    required this.amphoe,
    required this.province,
    required this.zipcode,
    required this.districtCode,
    required this.amphoeCode,
    required this.provinceCode,
  });

  dynamic district;
  dynamic amphoe;
  dynamic province;
  dynamic zipcode;
  dynamic districtCode;
  dynamic amphoeCode;
  dynamic provinceCode;

  factory Thaiprovice.fromJson(Map<String, dynamic> json) => Thaiprovice(
    district: json["district"],
    amphoe: json["amphoe"],
    province: json["province"],
    zipcode: json["zipcode"],
    districtCode: json["district_code"],
    amphoeCode: json["amphoe_code"],
    provinceCode: json["province_code"],
  );

  Map<String, dynamic> toJson() => {
    "district": district,
    "amphoe": amphoe,
    "province": province,
    "zipcode": zipcode,
    "district_code": districtCode,
    "amphoe_code": amphoeCode,
    "province_code": provinceCode,
  };
}
