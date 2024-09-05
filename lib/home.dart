import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:urban_gardening/Chat/chat.dart';
import 'package:urban_gardening/Community.dart';
import 'package:urban_gardening/Recommendations/plantrec.dart';
import 'package:weather/weather.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

const API = '56a80719fea91ea930b265cdf9baa4fa';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _searchController = TextEditingController();
  final WeatherFactory _wf = WeatherFactory(API);
  Weather? _weather;

  @override
  void initState() {
    super.initState();
    _getLocationAndFetchWeather();
  }

  Future<void> _getLocationAndFetchWeather() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showErrorDialog('Location services are disabled.');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showErrorDialog('Location permission denied.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showErrorDialog('Location permissions are permanently denied.');
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    _fetchWeatherByCoordinates(position.latitude, position.longitude);
  }

  void _fetchWeatherByCoordinates(double latitude, double longitude) {
    _wf.currentWeatherByLocation(latitude, longitude).then((w) {
      setState(() {
        _weather = w;
      });
    }).catchError((error) {
      print('Error fetching weather: $error');
      _showErrorDialog(
          'Failed to fetch weather data. Please enter the correct location.');
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDetailedWeather() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DetailedWeatherScreen(weather: _weather)),
    );
  }

void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  String getNameFromEmail(String email) {
    return email.split('@').first;
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromRGBO(17, 138, 178, 1),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person, size: 80, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    user != null
                        ? getNameFromEmail(user!.email ?? 'No mail')
                        : 'No mail',
                    // user?.email. ?? 'No Email',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // ListTile(
            //   leading: Icon(Icons.payment),
            //   title: Text('Payments'),
            //   onTap: () {},
            // ),
            // ListTile(
            //   leading: Icon(Icons.card_giftcard),
            //   title: Text('Refer and Earn'),
            //   onTap: () {},
            // ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {},
            ),
            // ListTile(
            //   leading: Icon(Icons.history),
            //   title: Text('History'),
            //   onTap: () {},
            // ),
            ListTile(
              leading: Icon(Icons.help),
              title: Text('Help'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Log Out'),
              onTap: signUserOut,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildUI(),
          ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GardenRecommendationScreen()),
    );
  },
  child: Text("Plant"),
),
          ElevatedButton(onPressed: (){
            Navigator.push(context,MaterialPageRoute(builder: (context)=>ChatPage()));
          }, child: Text("Chat")),
          ElevatedButton(onPressed: (){
            Navigator.push(context,MaterialPageRoute(builder: (context)=>Community()));
          }, child: Text("Community")),
          
        ],

      ),
    );
  }

  Widget _buildUI() {
    if (_weather == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return GestureDetector(
      onTap: _showDetailedWeather,
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.symmetric(
              vertical: 5, horizontal: 5), // Adjusted padding
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height *
              0.2, // Half the previous height
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey[200],
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _locationAndTemperature(),
              const SizedBox(height: 5), // Reduced the gap
              _extraInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _locationAndTemperature() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 10),
        Text(
          _weather?.areaName ?? "",
          style: GoogleFonts.poppins(
            color: Colors.blue,
            fontSize: 18, // Smaller font size for the location
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(width: 10), // Reduced the gap
        Text(
          "${_weather?.temperature?.celsius?.toStringAsFixed(0)}℃",
          style: GoogleFonts.poppins(
            color: Colors.blue,
            fontSize: 30, // Reduced the font size to fit better
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 10), // Reduced the gap
        Image.network(
          "https://openweathermap.org/img/wn/${_weather?.weatherIcon}@4x.png",
          scale: 2.5, // Reduced the scale to fit better
        ),
      ],
    );
  }

  Widget _extraInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Icon(
              WeatherIcons.humidity,
              size: 20, // Reduced size
              color: Colors.black,
            ),
            const SizedBox(height: 3), // Reduced gap
            Text(
              "${_weather?.humidity?.toStringAsFixed(0)}%",
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 12, // Reduced font size
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              "Humidity",
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 10, // Reduced font size
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        Column(
          children: [
            Icon(
              WeatherIcons.day_windy,
              size: 20, // Reduced size
              color: Colors.black,
            ),
            const SizedBox(height: 3), // Reduced gap
            Text(
              "${_weather?.windSpeed?.toStringAsFixed(1)} m/s",
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 12, // Reduced font size
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              "Wind Speed",
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 10, // Reduced font size
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        Column(
          children: [
            Icon(
              WeatherIcons.thermometer,
              size: 20, // Reduced size
              color: Colors.black,
            ),
            const SizedBox(height: 3), // Reduced gap
            Text(
              "${_weather?.tempFeelsLike?.celsius?.toStringAsFixed(0)}℃",
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 12, // Reduced font size
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              "Feels Like",
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 10, // Reduced font size
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class DetailedWeatherScreen extends StatelessWidget {
  final Weather? weather;

  const DetailedWeatherScreen({Key? key, this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detailed Weather",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Location: ${weather?.areaName ?? "N/A"}",
              style: GoogleFonts.poppins(fontSize: 18),
            ),
            Text(
              "Temperature: ${weather?.temperature?.celsius?.toStringAsFixed(0)}℃",
              style: GoogleFonts.poppins(fontSize: 18),
            ),
            Text(
              "Humidity: ${weather?.humidity?.toStringAsFixed(0)}%",
              style: GoogleFonts.poppins(fontSize: 18),
            ),
            Text(
              "Wind Speed: ${weather?.windSpeed?.toStringAsFixed(1)} m/s",
              style: GoogleFonts.poppins(fontSize: 18),
            ),
            Text(
              "Feels Like: ${weather?.tempFeelsLike?.celsius?.toStringAsFixed(0)}℃",
              style: GoogleFonts.poppins(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}