class Invoice {
  String? id;
  String? clientName;
  String? clientPhone;
  String? index;
  String? worker;
  String? workSpace;

  String? timeOut;//time when inv added at first (means when you add the inv after choosing its type 'multiple,client or delivery')
  String? timeReturn;//time when inv added when check (here timeOut == timeReturn)

  Map<String, dynamic>? productsOut;//products added to inv at first
  double? outTotal;//the total at first


  Map<String, dynamic>? productsReturned;
  double? returnTotal;//the total when check the inv
  double? income;

  bool? verified;//false at pending // check at the end
  bool? totalChanged; //if outTotal != returnTotal its 'true' it means the total changed
  bool? isBuy;//if inv


  Invoice({
    this.id='',
    this.clientName='',
    this.timeOut='',
    this.timeReturn='',
    this.worker='',
    this.workSpace='',
    this.index='',
    this.verified=false,
    this.totalChanged=false,
    this.isBuy=false,
    this.clientPhone='',
    this.productsOut=const{},
    this.productsReturned = const{},
    this.outTotal=0.0,
    this.returnTotal=0.0,
    this.income=0.0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientName': clientName,
      'deliveryPhone': clientPhone,
      'worker': worker,
      'index': index,
      'workSpace': workSpace,

      'totalChanged': totalChanged,

      'timeOut': timeOut,
      'timeReturn': timeReturn,
      'verified': verified,
      'isBuy': isBuy,

      'productsOut': productsOut,
      'productsReturned': productsReturned,

      'outTotal': outTotal,
      'returnTotal': returnTotal,
      'income': income,
    };
  }

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'],
      clientName: json['clientName'],
      timeOut: json['timeOut'],
      workSpace: json['workSpace'],
      worker: json['worker'],
      
      isBuy: json['isBuy'] ?? false,//this is used when field do not exist in db
      totalChanged: json['totalChanged'],
      timeReturn: json['timeReturn'],
      verified: json['verified'],
      index: json['index'],
      clientPhone: json['deliveryPhone'],
      productsOut: json['productsOut'],
      productsReturned: json['productsReturned'],
      outTotal: json['outTotal'].toDouble(),
      returnTotal: json['returnTotal'].toDouble(),
      income: json['income'].toDouble(),
    );
  }


}
