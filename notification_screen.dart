import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DelayNotificationsScreen extends StatefulWidget {
  @override
  _DelayNotificationsScreenState createState() => _DelayNotificationsScreenState();
}

class _DelayNotificationsScreenState extends State<DelayNotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Delay Notifications")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('bus_delays').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No delay notifications."));
          }

          var delayDocs = snapshot.data!.docs;

          return ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: delayDocs.length,
            itemBuilder: (context, index) {
              var data = delayDocs[index].data() as Map<String, dynamic>;

              // Ensure fields exist before accessing
              String busId = data.containsKey('bus_id') ? data['bus_id'] : "Unknown";
              
              // Extract bus number from "bus6" → "6", fallback to "Unknown"
              String busNumber = data.containsKey('bus_number')
                  ? data['bus_number']
                  : (RegExp(r'\d+').hasMatch(busId) ? RegExp(r'\d+').firstMatch(busId)!.group(0)! : "Unknown");

              String delayReason = data.containsKey('reason') ? data['reason'] : "No reason provided";
              Timestamp timestamp = data.containsKey('timestamp') ? data['timestamp'] : Timestamp.now();

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8),
                elevation: 3,
                child: ListTile(
                  title: Text(
                    "Bus Number: $busNumber",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5),
                      Text("Delay Reason: $delayReason", style: TextStyle(color: Colors.red)),
                      SizedBox(height: 5),
                      Text("Reported at: ${timestamp.toDate().toLocal()}", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}