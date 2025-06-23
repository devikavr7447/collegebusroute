import 'bus_schedule_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';
import 'signup.dart';
import 'bus_route_screen.dart';
import 'manage_buses.dart';
import 'manage_routes.dart';
import 'manage_driver.dart';
import 'notification_screen.dart'; // Ensure this import is correct



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'College Bus App',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginScreen(),
      routes: {
        '/signup': (context) => const SignupScreen(),
        '/user_home': (context) => UserHomeScreen(),
        '/driver_home': (context) => DriverHomeScreen(),
        '/admin_home': (context) => AdminHomeScreen(key: UniqueKey()),
        '/manage_buses': (context) => ManageBusesScreen(),
        '/manage_routes': (context) => ManageRoutesScreen(),
        '/manage_drivers': (context) => ManageDriversScreen(),
        '/select_bus_tracking': (context) => SelectBusTrackingScreen(),
        '/select_bus_routes': (context) => SelectBusRoutesScreen(),
        '/delay_notifications': (context) => DelayNotificationsScreen(),
         '/bus_schedule':(context) => BusScheduleScreen(),

      },
    );
  }
}


class UserHomeScreen extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome", style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.yellow.shade700,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.yellow.shade700),
              child: const Text("Menu", style: TextStyle(fontSize: 24, color: Colors.black)),
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout"),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacementNamed('/login');
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              "Welcome!",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Image.asset('assets/bus_image.png', height: 150), // Ensure you add an image asset
            const SizedBox(height: 30),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildMenuButton(context, "Live Track", '/select_bus_tracking', Icons.location_on),
                  _buildMenuButton(context, "Bus Routes", '/select_bus_routes', Icons.route),
                  _buildMenuButton(context, "Bus Schedule", '/bus_schedule', Icons.schedule),
                  _buildMenuButton(context, "Notifications", '/delay_notifications', Icons.notifications),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String text, String route, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.grey.shade300, blurRadius: 5, spreadRadius: 2),
        ],
      ),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.yellow.shade700),
            const SizedBox(height: 10),
            Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}





class SelectBusTrackingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<String> busIds = [
      "bus1",
      "bus2",
      "bus3",
      "bus4",
      "bus5",
      "bus6",
      "bus7",
      "bus12",
      "bus13",
      "bus14"
    ]; // ✅ Updated list of buses

    return Scaffold(
      appBar: AppBar(title: const Text("Select Bus for Live Tracking")),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // ✅ 3 buttons per row
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 2.5, // ✅ Adjust button size
          ),
          itemCount: busIds.length,
          itemBuilder: (context, index) {
            String busId = busIds[index];

            return ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/map', arguments: busId);
              },
              child: Text("Live Tracking - ${busId.toUpperCase()}"),
            );
          },
        ),
      ),
    );
  }
}

class SelectBusRoutesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<String> busIds = [
      "bus1",
      "bus2",
      "bus3",
      "bus4",
      "bus5",
      "bus6",
      "bus7",
      "bus12",
      "bus13",
      "bus14"
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Select Bus Route")),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 3 buttons per row
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 2.5, // Adjust button size
          ),
          itemCount: busIds.length,
          itemBuilder: (context, index) {
            String busId = busIds[index];

            return ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BusRouteScreen(busId: busId)),
                );
              },
              child: Text(busId.toUpperCase(),
                  style:
                      const TextStyle(color: Color.fromARGB(193, 98, 11, 212))),
            );
          },
        ),
      ),
    );
  }
}

class DriverHomeScreen extends StatefulWidget {
  @override
  _DriverHomeScreenState createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  bool _isSharingLocation = false;
  String? _busId;

  @override
  void initState() {
    super.initState();
    _busId = FirebaseAuth.instance.currentUser?.uid;
  }

  Future<void> _startSharingLocation() async {
    setState(() {
      _isSharingLocation = true;
    });
  }

  Future<void> _stopSharingLocation() async {
    setState(() {
      _isSharingLocation = false;
    });
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Driver Home"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Live Location Sharing: ${_isSharingLocation ? "ON" : "OFF"}"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isSharingLocation
                  ? _stopSharingLocation
                  : _startSharingLocation,
              child: Text(_isSharingLocation
                  ? "Stop Sharing Location"
                  : "Start Sharing Location"),
            ),
          ],
        ),
      ),
    );
  }
}

class AdminHomeScreen extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Home")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome, ${'Admin'}!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Manage Bus Routes"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Manage Drivers"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Manage Buses"),
            ),
          ],
        ),
      ),
    );
  }
}