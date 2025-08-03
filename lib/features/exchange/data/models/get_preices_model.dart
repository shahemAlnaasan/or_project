// To parse this JSON data, do
//
//     final getPricesResponse = getPricesResponseFromJson(jsonString);

import 'dart:convert';

GetPricesResponse getPricesResponseFromJson(String str) => GetPricesResponse.fromJson(json.decode(str));

String getPricesResponseToJson(GetPricesResponse data) => json.encode(data.toJson());

class GetPricesResponse {
  String time;
  Map<String, PriceValue> prices;
  List<Currency> curs;
  int id;

  GetPricesResponse({required this.time, required this.prices, required this.curs, required this.id});

  factory GetPricesResponse.fromJson(Map<String, dynamic> json) => GetPricesResponse(
    time: json["time"],
    prices: Map.from(json["prices"]).map((k, v) => MapEntry<String, PriceValue>(k, PriceValue.fromJson(v))),
    curs: List<Currency>.from(json["curs"].map((x) => Currency.fromJson(x))),
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "time": time,
    "prices": Map.from(prices).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    "curs": List<dynamic>.from(curs.map((x) => x.toJson())),
    "id": id,
  };
}

class Currency {
  String id;
  String name;
  String op;
  String price;
  String? img;

  Currency({required this.id, required this.name, required this.op, required this.price, required this.img});

  factory Currency.fromJson(Map<String, dynamic> json) =>
      Currency(id: json["id"], name: json["name"], op: json["op"], price: json["price"], img: json["img"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name, "op": op, "price": price, "img": img};
}

class PriceValue {
  String curfrom;
  String curto;
  String price;
  String op;
  String img;
  String catagory;
  String? dir;

  PriceValue({
    required this.curfrom,
    required this.curto,
    required this.price,
    required this.op,
    required this.img,
    required this.catagory,
    this.dir,
  });

  factory PriceValue.fromJson(Map<String, dynamic> json) => PriceValue(
    curfrom: json["curfrom"],
    curto: json["curto"],
    price: json["price"].toString(),
    op: json["op"],
    img: json["img"],
    catagory: json["catagory"],
    dir: json["dir"],
  );

  Map<String, dynamic> toJson() => {
    "curfrom": curfrom,
    "curto": curto,
    "price": price,
    "op": op,
    "img": img,
    "catagory": catagory,
    "dir": dir,
  };
}
