import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddPlantScreen extends StatefulWidget {
  @override
  _AddPlantScreenState createState() => _AddPlantScreenState();
}

class _AddPlantScreenState extends State<AddPlantScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _plantingDepthController = TextEditingController();
  final TextEditingController _spacingController = TextEditingController();
  final TextEditingController _wateringController = TextEditingController();
  final TextEditingController _harvestingController = TextEditingController();

  String? _selectedLocation;
  String? _selectedSeason;
  String? _selectedSunlight;

  List<String> _locations = ['Indoor', 'Outdoor'];
  List<String> _seasons = ['Winter', 'Spring', 'Summer', 'Autumn'];
  List<String> _sunlightLevels = ['Full Sun', 'Partial Sun', 'Shade'];

  Future<void> _addPlant() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance.collection('plants').add({
        'name': _nameController.text,
        'plantingDepth': _plantingDepthController.text,
        'spacing': _spacingController.text,
        'watering': _wateringController.text,
        'harvesting': _harvestingController.text,
        'location': _selectedLocation,
        'season': _selectedSeason,
        'sunlight': _selectedSunlight,
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Plant'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Plant Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the plant name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
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
                  border: OutlineInputBorder(),
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
                  border: OutlineInputBorder(),
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
              SizedBox(height: 16),
              TextFormField(
                controller: _plantingDepthController,
                decoration: InputDecoration(
                  labelText: 'Planting Depth',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _spacingController,
                decoration: InputDecoration(
                  labelText: 'Spacing',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _wateringController,
                decoration: InputDecoration(
                  labelText: 'Watering',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _harvestingController,
                decoration: InputDecoration(
                  labelText: 'Harvesting',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: _addPlant,
                  child: Text('Add Plant'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
