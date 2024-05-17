class InvProd {
  String? name;
  int? qty;
  double? priceSell;
  double? priceBuy;
  double? totalSell;
  double? totalBuy;
  double? income;

  InvProd({
    this.name='',
    this.qty=0,
    this.priceSell=0.0,
    this.priceBuy =0.0,
    this.totalSell=0.0,
    this.totalBuy=0.0,
    this.income=0.0,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'qty': qty,
      'priceSell': priceSell,
      'priceBuy': priceBuy,
      'totalSell': totalSell,
      'totalBuy': totalBuy,
      'income': income,
    };
  }

  factory InvProd.fromJson(Map<String, dynamic> json) {
    return InvProd(
      name: json['name'],
      qty: json['qty'].toInt(),
      priceSell: json['priceSell'].toDouble(),
      priceBuy: json['priceBuy'].toDouble(),
      totalSell: json['totalSell'].toDouble(),
      totalBuy: json['totalBuy'].toDouble(),
      income: json['income'].toDouble(),
    );
  }
}
