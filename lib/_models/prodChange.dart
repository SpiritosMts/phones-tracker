import 'buySellProd.dart';

class ProdChange {
  String? time;
  String? workSpace;


  double? sellPrice;
  double? buyPrice;
  int? qty;

  ProdChange({
    this.time='',
    this.workSpace='',
    this.sellPrice=0.0,
    this.buyPrice=0.0,
    this.qty=0,
  });

  factory ProdChange.fromJson(Map<String, dynamic> json) {
    return ProdChange(
      time: json['time'],
      workSpace: json['workSpace'],
      sellPrice: json['price'].toDouble(),
      buyPrice: (json['buyPrice']??88888.0).toDouble(),//if this field doesnt exist in db make it zero
      qty: json['qty'].toInt(),
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'workSpace': workSpace,
      'price': sellPrice,
      'buyPrice': buyPrice,
      'qty': qty,
    };
  }
}
