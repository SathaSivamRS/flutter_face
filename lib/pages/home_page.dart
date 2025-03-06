import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LatLng _markerPosition = const LatLng(12.9607, 80.0527);
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await _showLogoutConfirmation(context);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple,
          title: const Text("Home"),
        ),
        body: Column(
          children: [
            _buildMap(),
            const SizedBox(height: 20),

            // ✅ Buttons - Perfect Alignment
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  _buildButtonRow([
                    _buildRoundButton(
                      Icons.location_searching,
                      "Track Phone",
                      () {
                        _navigateToPage(context, const TrackPhonePage());
                      },
                    ),
                    _buildRoundButton(Icons.search, "Find Device", () {
                      _navigateToPage(context, const FindDevicePage());
                    }),
                    _buildRoundButton(Icons.devices, "Register Device", () {
                      _navigateToPage(context, const RegisterDevicePage());
                    }),
                  ]),
                  const SizedBox(height: 15),
                  _buildButtonRow([
                    _buildRoundButton(Icons.face, "Add Face Data", () {
                      _navigateToPage(context, const AddFaceDataPage());
                    }),
                    _buildRoundButton(Icons.person_add, "Add Nominees", () {
                      _navigateToPage(context, const AddNomineesPage());
                    }),
                    _buildRoundButton(Icons.security, "App Protection", () {
                      _navigateToPage(context, const AppProtectionPage());
                    }),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Map Widget
  Widget _buildMap() {
    return Container(
      width: double.infinity,
      height: 250,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(center: _markerPosition, zoom: 15),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _markerPosition,
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.location_pin,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 15,
            right: 15,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              mini: true,
              onPressed: () {
                _mapController.move(_markerPosition, 15);
              },
              child: const Icon(Icons.my_location, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Arrange buttons in a row
  Widget _buildButtonRow(List<Widget> buttons) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons,
    );
  }

  // ✅ Updated Round Buttons (Uniform Size & Navigation)
  Widget _buildRoundButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap, // Navigate when tapped
      child: Column(
        children: [
          Container(
            width: 60, // Consistent Size
            height: 60,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.purple,
            ),
            child: Icon(icon, size: 40, color: Colors.white),
          ),
          const SizedBox(height: 6), // Small space between icon & text
          SizedBox(
            width: 90,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Page Navigation
  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  // Logout Confirmation Dialog
  Future<bool> _showLogoutConfirmation(BuildContext context) async {
    return await showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text("Logout"),
                content: const Text("Are you sure you want to logout?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text("Logout"),
                  ),
                ],
              ),
        ) ??
        false;
  }
}

// ✅ Dummy Pages for Navigation
class TrackPhonePage extends StatelessWidget {
  const TrackPhonePage({super.key});
  @override
  Widget build(BuildContext context) {
    return _buildPage("Track Phone");
  }
}

class FindDevicePage extends StatelessWidget {
  const FindDevicePage({super.key});
  @override
  Widget build(BuildContext context) {
    return _buildPage("Find Device");
  }
}

class RegisterDevicePage extends StatelessWidget {
  const RegisterDevicePage({super.key});
  @override
  Widget build(BuildContext context) {
    return _buildPage("Register Device");
  }
}

class AddFaceDataPage extends StatelessWidget {
  const AddFaceDataPage({super.key});
  @override
  Widget build(BuildContext context) {
    return _buildPage("Add Face Data");
  }
}

class AddNomineesPage extends StatelessWidget {
  const AddNomineesPage({super.key});
  @override
  Widget build(BuildContext context) {
    return _buildPage("Add Nominees");
  }
}

class AppProtectionPage extends StatelessWidget {
  const AppProtectionPage({super.key});
  @override
  Widget build(BuildContext context) {
    return _buildPage("App Protection");
  }
}

// ✅ Common Page UI
Widget _buildPage(String title) {
  return Scaffold(
    appBar: AppBar(title: Text(title), backgroundColor: Colors.purple),
    body: Center(
      child: Text(
        "$title Page",
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    ),
  );
}

