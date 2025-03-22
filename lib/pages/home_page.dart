import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login/pages/track_phone_page.dart';
import 'package:login/pages/find_device_page.dart';
import 'package:login/pages/register_device_page.dart';
import 'package:login/pages/face_data_page.dart';
import 'package:login/pages/nominee_page.dart';
import 'package:login/pages/app_protection_page.dart';
import 'package:login/pages/subscription_page.dart';
import 'package:login/pages/profile_page.dart';
import 'package:login/pages/faq_page.dart';
import 'package:login/screens/login_screen.dart'; // For logout navigation

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    HomePageContent(),
    SubscriptionPage(),
    ProfilePage(),
    FAQPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // ✅ Firebase Logout
  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          bool shouldExit = await _showLogoutConfirmation(context);
          if (shouldExit) {
            _logout();
          }
        }
      },
      child: Scaffold(
        appBar:
            _selectedIndex == 0
                ? AppBar(
                  backgroundColor: Colors.purple,
                  title: const Text("Home"),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: _logout,
                    ),
                  ],
                )
                : null, // 🔥 No AppBar for other pages
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
              icon: Icon(Icons.subscriptions),
              label: "Subscription",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
            BottomNavigationBarItem(icon: Icon(Icons.help), label: "FAQ"),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.purple,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  // ✅ Logout Confirmation Dialog
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

// ✅ Home Page Content with Map & Buttons
class HomePageContent extends StatelessWidget {
  final LatLng _markerPosition = const LatLng(12.9607, 80.0527);
  final MapController _mapController = MapController();

  HomePageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildMap(),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              _buildButtonRow(context, [
                _buildRoundButton(
                  context,
                  Icons.location_searching,
                  "Track Phone",
                  const TrackPhonePage(),
                ),
                _buildRoundButton(
                  context,
                  Icons.search,
                  "Find Device",
                  const FindDevicePage(),
                ),
                _buildRoundButton(
                  context,
                  Icons.devices,
                  "Register Device",
                  const RegisterDevicePage(),
                ),
              ]),
              const SizedBox(height: 15),
              _buildButtonRow(context, [
                _buildRoundButton(
                  context,
                  Icons.face,
                  "Add Face Data",
                  const FaceDataPage(),
                ),
                _buildRoundButton(
                  context,
                  Icons.person_add,
                  "Add Nominees",
                  const NomineePage(),
                ),
                _buildRoundButton(
                  context,
                  Icons.security,
                  "App Protection",
                  const AppProtectionPage(),
                ),
              ]),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMap() {
    return Container(
      width: double.infinity,
      height: 200,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _markerPosition,
                initialZoom: 15,
              ),
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
            bottom: 10,
            right: 10,
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

  Widget _buildButtonRow(BuildContext context, List<Widget> buttons) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons,
    );
  }

  Widget _buildRoundButton(
    BuildContext context,
    IconData icon,
    String label,
    Widget page,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.purple,
            ),
            child: Icon(icon, size: 40, color: Colors.white),
          ),
          const SizedBox(height: 6),
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
}
