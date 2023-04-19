class UserModelS {
   int id;
   String tel;
   String name;
   String code;
   String gr_cost;

  UserModelS({required  this.id,required this.code, required this.gr_cost, required this.name,required this.tel });

  factory UserModelS.fromJson(Map<String, dynamic> json) {
    return UserModelS(
      id: json["id"],
      name: json["name"],
      tel: json['tel'],
      gr_cost: json['gr_cost'],
      code: json['code']

    );
  }

  static List<UserModelS> fromJsonList(List list) {
    return list.map((item) => UserModelS.fromJson(item)).toList();
  }

   @override
   String toString() => name;

   @override
   operator ==(o) => o is UserModelS && o.id == id;

   @override
   int get hashCode => id.hashCode^name.hashCode^code.hashCode;


}