import 'package:flutter/material.dart';
import '../_manager/styles.dart';
import '../_models/note.dart';

class NoteInfo extends StatefulWidget {
  final Note note;

  const NoteInfo({Key? key, required this.note}) : super(key: key);

  @override
  State<NoteInfo> createState() => _NoteInfoState();
}

class _NoteInfoState extends State<NoteInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: appBarBgColor,
        title: Text(widget.note.type!,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: appBarTitleColor,
          ),
        ),
        bottom: appBarUnderline(),

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           // buildDetailItem('ID', widget.note.id),
            buildDetailItem('Workspace', widget.note.workSpace),
            buildDetailItem('Worker Name', widget.note.workerName),
           // buildDetailItem('Worker ID', widget.note.workerID),
          if(widget.note.clientName!.isNotEmpty)  buildDetailItem('Client Name', widget.note.clientName),
            buildDetailItem('Description', widget.note.description),
            buildDetailItem('Date', widget.note.date),
            //buildDetailItem('Type', widget.note.type),
          ],
        ),
      ),
    );
  }

  Widget buildDetailItem(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'N/A',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
