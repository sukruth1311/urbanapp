import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:urban_gardening/Recommendations/recommendation.dart';


class GardenRecommendationScreen extends StatefulWidget {
  @override
  _GardenRecommendationScreenState createState() => _GardenRecommendationScreenState();
}

class _GardenRecommendationScreenState extends State<GardenRecommendationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _squareFeetController = TextEditingController();

  String? _selectedLocation;
  String? _selectedSeason;
  String? _selectedSunlight;
  String? _selectedPlant;

  List<String> _locations = ['Indoor', 'Outdoor'];
  List<String> _seasons = ['Winter', 'Spring', 'Summer', 'Autumn'];
  List<String> _sunlightLevels = ['Full Sun', 'Partial Sun', 'Shade'];


  // Method to recommend plants based on input
  List<String> _recommendPlants(double squareFeet, String location, String season, String sunlight) {
  List<String> plants = [];

  if (location == 'Indoor') {
    if (sunlight == 'Shade') {
      plants = ['Lettuce', 'Spinach', 'Mint']; // Indoor, low light plants
    } else if (sunlight == 'Partial Sun') {
      plants = ['Coriander', 'Fenugreek', 'Chili']; // Indoor, partial sun plants
    }
  } else if (location == 'Outdoor') {
    if (sunlight == 'Full Sun') {
      if (season == 'Summer') {
        plants = [
          'Tomatoes', 'Brinjal', 'Okra', 'Mango', 'Guava', 
          'Bell Peppers', 'Basil', 'Marigold'
        ]; // Outdoor, summer plants
      } else if (season == 'Winter') {
        plants = [
          'Carrot', 'Cauliflower', 'Beetroot', 'Peas', 'Orange', 
          'Kale', 'Cabbage', 'Broccoli'
        ]; // Outdoor, winter plants
      }
    } else if (sunlight == 'Partial Sun') {
      plants = ['Cucumber', 'Radish', 'Spinach']; // Outdoor, partial sun plants
    }
  }

  // Further refine based on square feet available
  if (squareFeet < 10) {
    plants = plants.where((plant) => plant != 'Tomatoes' && plant != 'Brinjal').toList(); // For smaller spaces
  }

  return plants;
}

  // Method to get detailed growing instructions
  String _getInstructions(String plant) {
    Map<String, Map<String, String>> detailedInstructions = {
      'Lettuce': {
        'Planting Depth': '1/4 inch',
        'Spacing': '6-12 inches',
        'Watering': 'Water regularly, keep soil moist but not soggy.',
        'Harvesting': 'Harvest leaves when they reach desired size.',
      },
      'Spinach': {
        'Planting Depth': '1/2 inch',
        'Spacing': '3-5 inches',
        'Watering': 'Water frequently, especially in warm weather.',
        'Harvesting': 'Harvest outer leaves regularly to encourage new growth.',
      },
      'Mint': {
        'Planting Depth': 'Surface sow and lightly cover with soil.',
        'Spacing': '12-18 inches',
        'Watering': 'Keep soil consistently moist.',
        'Harvesting': 'Harvest leaves regularly to encourage bushy growth.',
      },
      'Coriander': {
        'Planting Depth': '1/4 inch',
        'Spacing': '4-6 inches',
        'Watering': 'Water moderately; allow soil to dry out between watering.',
        'Harvesting': 'Harvest leaves early before they flower for best flavor.',
      },
      'Fenugreek': {
        'Planting Depth': '1/4 inch',
        'Spacing': '6 inches',
        'Watering': 'Water regularly; prefers well-drained soil.',
        'Harvesting': 'Harvest leaves when young for best flavor.',
      },
      'Chili': {
        'Planting Depth': '1/4 inch',
        'Spacing': '12-18 inches',
        'Watering': 'Water deeply and regularly; keep soil well-drained.',
        'Harvesting': 'Harvest when fruits turn red for most heat.',
      },
      'Tomatoes': {
        'Planting Depth': '1/2 inch',
        'Spacing': '24-36 inches',
        'Watering': 'Water deeply and regularly; keep soil moist.',
        'Harvesting': 'Harvest when fruits are fully ripe and red.',
      },
      'Brinjal': {
        'Planting Depth': '1/2 inch',
        'Spacing': '18-24 inches',
        'Watering': 'Water regularly; prefers fertile, well-drained soil.',
        'Harvesting': 'Harvest when fruits are glossy and firm.',
      },
      'Okra': {
        'Planting Depth': '1 inch',
        'Spacing': '12-18 inches',
        'Watering': 'Water regularly; keep soil well-drained.',
        'Harvesting': 'Harvest pods when they are tender and about 3 inches long.',
      },
      'Mango': {
        'Planting Depth': 'Plant grafted saplings, not seeds.',
        'Spacing': '15-20 feet',
        'Watering': 'Water regularly; requires well-drained soil.',
        'Harvesting': 'Harvest fruits when they change color and soften.',
      },
      'Guava': {
        'Planting Depth': 'Plant saplings, ensure root ball is well-covered.',
        'Spacing': '10-15 feet',
        'Watering': 'Water regularly; prefers well-drained soil.',
        'Harvesting': 'Harvest when fruits soften and change color.',
      },
      'Carrot': {
        'Planting Depth': '1/4 inch',
        'Spacing': '2-3 inches',
        'Watering': 'Water regularly; keep soil loose and moist.',
        'Harvesting': 'Harvest when roots reach desired size.',
      },
      'Cauliflower': {
        'Planting Depth': '1/2 inch',
        'Spacing': '18-24 inches',
        'Watering': 'Water regularly; keep soil moist and well-drained.',
        'Harvesting': 'Harvest heads when they are firm and white.',
      },
      'Beetroot': {
        'Planting Depth': '1/2 inch',
        'Spacing': '4-6 inches',
        'Watering': 'Water regularly; keep soil well-drained.',
        'Harvesting': 'Harvest when roots reach 2-3 inches in diameter.',
      },
      'Peas': {
        'Planting Depth': '1 inch',
        'Spacing': '2-3 inches',
        'Watering': 'Water regularly; provide support for climbing.',
        'Harvesting': 'Harvest pods when they are plump and green.',
      },
      'Orange': {
        'Planting Depth': 'Plant saplings, ensure root ball is well-covered.',
        'Spacing': '12-15 feet',
        'Watering': 'Water regularly; prefers well-drained soil.',
        'Harvesting': 'Harvest when fruits are firm and orange in color.',
      },
      'Cucumber': {
        'Planting Depth': '1 inch',
        'Spacing': '12-18 inches',
        'Watering': 'Water regularly; provide support for climbing.',
        'Harvesting': 'Harvest when fruits are firm and green.',
      },
      'Radish': {
        'Planting Depth': '1/2 inch',
        'Spacing': '1-2 inches',
        'Watering': 'Water regularly; keep soil loose and moist.',
        'Harvesting': 'Harvest when roots reach desired size.',
      },
    };

    StringBuffer sb = StringBuffer();
    sb.writeln('$plant:');
    detailedInstructions[plant]?.forEach((key, value) {
      sb.writeln('  $key: $value');
    });
    sb.writeln();
    return sb.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Color.fromARGB(255, 243, 153, 153)),
        centerTitle: true,
        title: Text(
          "Recommendation",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color.fromRGBO(88, 140, 108, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _squareFeetController,
                      decoration: InputDecoration(
                        labelText: 'Available Square Feet',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Color.fromRGBO(88, 140, 108, 1),
                            width: 4,
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the available square feet';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Location',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Color.fromRGBO(88, 140, 108, 1),
                            width: 4,
                          ),
                        ),
                      ),
                      value: _selectedLocation,
                      items: _locations.map((String location) {
                        return DropdownMenuItem<String>(
                          value: location,
                          child: Text(location),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedLocation = newValue;
                        });
                      },
                      validator: (value) => value == null ? 'Please select a location' : null,
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Season',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Color.fromRGBO(88, 140, 108, 1),
                            width: 4,
                          ),
                        ),
                      ),
                      value: _selectedSeason,
                      items: _seasons.map((String season) {
                        return DropdownMenuItem<String>(
                          value: season,
                          child: Text(season),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedSeason = newValue;
                        });
                      },
                      validator: (value) => value == null ? 'Please select a season' : null,
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Sunlight Availability',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Color.fromRGBO(88, 140, 108, 1),
                            width: 4,
                          ),
                        ),
                      ),
                      value: _selectedSunlight,
                      items: _sunlightLevels.map((String sunlight) {
                        return DropdownMenuItem<String>(
                          value: sunlight,
                          child: Text(sunlight),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedSunlight = newValue;
                        });
                      },
                      validator: (value) => value == null ? 'Please select sunlight availability' : null,
                    ),
                    SizedBox(height: 24),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            double squareFeet = double.parse(_squareFeetController.text);
                            String location = _selectedLocation!;
                            String season = _selectedSeason!;
                            String sunlight = _selectedSunlight!;

                            List<String> recommendedPlants = _recommendPlants(squareFeet, location, season, sunlight);

                            Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => RecommendationsScreen(
      recommendedPlants: recommendedPlants,
      initialInstructions: _selectedPlant != null ? _getInstructions(_selectedPlant!) : '',
      onEdit: () {
        Navigator.pop(context);
      },
    ),
  ),
);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(88, 140, 108, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          'Get Recommendations',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}