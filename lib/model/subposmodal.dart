class SubPosModal {
  int id;
  String name;
  num qty;
  num price;
  num disconut;
  num totprice;

  SubPosModal({required  this.id,required this.name, required this.qty,required this.price,  required this.disconut,required this.totprice });

  factory SubPosModal.fromJson(Map<String, dynamic> json) {
    return SubPosModal(
        id: json["id"],
        name: json["name"],
        price: json['price'],
        qty: json['qty'],
        disconut: json['dicount'],
        totprice: json['totprice']

    );
  }

  static List<SubPosModal> fromJsonList(List list) {
    return list.map((item) => SubPosModal.fromJson(item)).toList();
  }
}