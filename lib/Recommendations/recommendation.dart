import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecommendationsScreen extends StatefulWidget {
  final List<String> recommendedPlants;
  final String initialInstructions;
  final VoidCallback onEdit;

  RecommendationsScreen({
    required this.recommendedPlants,
    required this.initialInstructions,
    required this.onEdit,
  });

  @override
  _RecommendationsScreenState createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> {
  String? _selectedPlant;
  String _instructions = '';

  @override
  void initState() {
    super.initState();
    _instructions = widget.initialInstructions;
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
          "Recommendations",
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
              if (widget.recommendedPlants.isNotEmpty) ...[
                Text(
                  'Recommended Plants:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  widget.recommendedPlants.join(', '),
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 24),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Select a Plant',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Color.fromRGBO(88, 140, 108, 1),
                        width: 4,
                      ),
                    ),
                  ),
                  value: _selectedPlant,
                  items: widget.recommendedPlants.map((String plant) {
                    return DropdownMenuItem<String>(
                      value: plant,
                      child: Text(plant),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedPlant = newValue;
                      _instructions = newValue != null ? _getInstructions(newValue) : '';
                    });
                  },
                  validator: (value) => value == null ? 'Please select a plant' : null,
                ),
              ] else ...[
                Text(
                  'No recommendations available.',
                  style: TextStyle(fontSize: 16),
                ),
              ],
              SizedBox(height: 24),
              if (_instructions.isNotEmpty) ...[
                Text(
                  'Growing Instructions:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    _instructions,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
              SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: widget.onEdit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(88, 140, 108, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Edit Input',
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
      ),
    );
  }
}
