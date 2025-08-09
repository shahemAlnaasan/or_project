// To parse this JSON data, do
//
//     final getSyPricesResponse = getSyPricesResponseFromJson(jsonString);

import 'dart:convert';

GetSyPricesResponse getSyPricesResponseFromJson(String str) => GetSyPricesResponse.fromJson(json.decode(str));

String getSyPricesResponseToJson(GetSyPricesResponse data) => json.encode(data.toJson());

class GetSyPricesResponse {
  String time;
  Map<String, Price> prices;

  GetSyPricesResponse({required this.time, required this.prices});

  factory GetSyPricesResponse.fromJson(Map<String, dynamic> json) => GetSyPricesResponse(
    time: json["time"],
    prices: Map.from(json["prices"]).map((k, v) => MapEntry<String, Price>(k, Price.fromJson(v))),
  );

  Map<String, dynamic> toJson() => {
    "time": time,
    "prices": Map.from(prices).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
  };
}

class Price {
  String name;
  String priceUsd;
  String priceEur;
  String priceTl;

  Price({required this.name, required this.priceUsd, required this.priceEur, required this.priceTl});

  factory Price.fromJson(Map<String, dynamic> json) =>
      Price(name: json["name"], priceUsd: json["price_usd"], priceEur: json["price_eur"], priceTl: json["price_tl"]);

  Map<String, dynamic> toJson() => {"name": name, "price_usd": priceUsd, "price_eur": priceEur, "price_tl": priceTl};
}
