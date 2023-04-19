class InvoiceModel {
  int id;
  String docno;
  String proid;
  String sku;
  String name;
  int qty;
  int price;
  int totprice;
  int status;
  int cancel;
  String wh;
  String row;
  String rowLevel;
  String rowSection;
  String pid;
  String stockname;

  InvoiceModel(
      {  required this.id,
         required this.docno,
        required this.proid,
        required this.sku,
        required this.name,
        required this.qty,
        required this.price,

        required this.totprice,
        required this.status,
        required this.cancel,
        required this.wh,
        required this.row,
        required this.rowLevel,
        required this.rowSection,
        required this.pid,
        required this.stockname,


      });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) => InvoiceModel(
    id: json["id"],
    docno: json["docno"],
    proid: json["proid"],
    sku: json["sku"],
    name: json["name"],
    qty: json["qty"],
    price: json["price"],

    totprice: json["totprice"],
    status: json["status"],
    cancel: json["cancel"],
    wh: json["wh"],
    row: json["row"],
    rowLevel: json["row_level"],
    rowSection: json["row_section"],
    pid: json["pid"],
    stockname: json["stockname"],


  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "docno": docno,
    "proid": proid,
    "sku": sku,
    "name": name,
    "qty": qty,
    "price": price,

    "totprice": totprice,
    "status": status,
    "cancel": cancel,
    "wh": wh,
    "row": row,
    "row_level": rowLevel,
    "row_section": rowSection,
    "pid": pid,
    "stockname": stockname,


  };
}
