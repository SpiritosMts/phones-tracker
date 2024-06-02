// affected_dev.dart

class AffectedDev {
  String id;
  String name;
  String model;
  String imei;
  String desc;
  String state;
  String time;
  String wrkSpace;

  AffectedDev({
     this.id='',
     this.name='',
     this.model='',
     this.imei='',
     this.desc='',
     this.time='',
     this.state='',
     this.wrkSpace='',
  });

  // Method to convert a JSON object into an AffectedDev instance
  factory AffectedDev.fromJson(Map<String, dynamic> json) {
    return AffectedDev(
      id: json['id'],
      name: json['name'],
      model: json['model'],
      time: json['time'],
      imei: json['imei'],
      desc: json['desc'],
      state: json['state'],
      wrkSpace: json['wrkSpace'],
    );
  }

  // Method to convert an AffectedDev instance into a JSON object
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'time': time,
      'name': name,
      'model': model,
      'imei': imei,
      'desc': desc,
      'state': state,
      'wrkSpace': wrkSpace,
    };
  }
}
