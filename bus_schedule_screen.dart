import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BusScheduleScreen extends StatelessWidget {
   BusScheduleScreen({super.key});

  

  // 📌 Function to call driver
  final Map<String, String> driverPhoneNumbers = {
  '1': '+917559886264',
  '2': '+917510210481',
  '3': '+918089866264',
  '4': '+919745634661',
  '5': '+919946332526',
  '6': '+917306212373',
  '7':'+918606417493',
  '12': '+919567017978',
  '13': '+917025907560',
  '14': '+918590527903',
};

void _callDriver(String busNumber) {
  // 🔹 Extract only digits from "Bus X"
  String formattedBusNumber = busNumber.replaceAll(RegExp(r'[^0-9]'), '');

  if (driverPhoneNumbers.containsKey(formattedBusNumber)) {
    final Uri phoneUri = Uri.parse("tel:${driverPhoneNumbers[formattedBusNumber]}");
    launchUrl(phoneUri);
  } else {
    print("❌ Phone number not found for bus $busNumber.");
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bus Schedules')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('bus_schedules').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No bus schedules available."));
          }

         return ListView(
            children: snapshot.data!.docs.map((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

              // ✅ Extract bus number from document ID
              String busNumber = doc.id; // Document ID is the bus number

              // ✅ Extract route name
              String routeName = data['route_name'] ?? "Unknown Route";

              // ✅ Ensure 'stops' exists and is a List
              List<dynamic> stops = (data['stops'] is List) ? data['stops'] : [];


              return Card(
                margin: const EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          
                          IconButton(
                            icon: const Icon(Icons.phone, color: Colors.green), // 📌 Phone icon
                            onPressed: () => _callDriver(busNumber), // 📌 Call driver
                          ),
                        ],
                      ),
                      Text(busNumber,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)),
                      Text('Route: $routeName',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5),
                      ...stops.isNotEmpty
                          ? stops.map((stop) {
                              if (stop is Map<String, dynamic>) {
                                // ✅ Extract stop name dynamically (ignoring "time" key)
                                String stopName = stop.entries.firstWhere(
                                  (entry) => entry.key != 'time',
                                  orElse: () => const MapEntry('Unknown Stop', ''),
                                ).value;

                                String time = stop['time'] ?? "Unknown Time";

                                return Text('$stopName - $time');
                              }
                              return const Text("Invalid stop data.");
                            }).toList()
                          : [const Text("No stops available.")],

                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}