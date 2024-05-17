class Note {
  String? id;
  String? workSpace;
  String? workerName;
  String? workerID;
  String? clientName;
  String? description;
  String? date;
  String? type;

  Note({
    this.id = '',
    this.workSpace = '',
    this.workerName = '',
    this.workerID = '',
    this.clientName = '',
    this.description = '',
    this.date = '',
    this.type = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'workSpace': workSpace,
      'workerName': workerName,
      'workerID': workerID,
      'clientName': clientName,
      'description': description,
      'date': date,
      'type': type,
    };
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      workSpace: json['workSpace'],
      workerName: json['workerName'],
      workerID: json['workerID'],
      clientName: json['clientName'],
      description: json['description'],
      date: json['date'],
      type: json['type'],
    );
  }
}
