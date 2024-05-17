class BuySellProd {
  String? time;
  int? qty;
  int? restQty;
  double? price;
  String? society;
  String? workSpace;
  String? mf;
  String? to;
  //bool? isSell;
  String? driver;
  String? invID;
  double? total;
  double? income;

  BuySellProd({
    this.time='',
    this.workSpace='',
    this.qty=0,
    this.restQty=0,
    this.price=0.0,
    this.income=0.0,
    this.society='',
    this.mf='',
    this.to='',
    //this.isSell=false,
    this.driver='',
    this.invID='',
    this.total=0.0,
  });

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'workSpace': workSpace,
      'qty': qty,
      'restQty': restQty,
      'price': price,
      'society': society,
      'mf': mf,
      //'isSell': mf,
      'to': to,
      'driver': driver,
      'income': income,
      'invID': invID,
      'total': total,
    };
  }

  factory BuySellProd.fromJsonOfProdChange(Map<String, dynamic> json) {
    return BuySellProd(
      time: json['time'],
      workSpace: json['workSpace'],
      qty: json['qty'].toInt(),
      restQty: 0,
      income: 0.0,
      price: json['price']?.toDouble(),
      society: '',
      mf: '',
      to: '',
      driver: '',
      invID: '',
      total: 0.0,
    );
  }

  factory BuySellProd.fromJson(Map<String, dynamic> json) {
    return BuySellProd(
      time: json['time'],
      workSpace: json['workSpace'],
      qty: json['qty'].toInt(),
      restQty: json['restQty'].toInt(),
      income: json['income']?.toDouble(),
      price: json['price']?.toDouble(),
      society: json['society'],
      //isSell: json['isSell'],
      mf: json['mf'],
      to: json['to'],
      driver: json['driver'],
      invID: json['invID'],
      total: json['total'].toDouble(),
    );
  }
}
