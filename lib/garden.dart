// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class GardenRecommendationScreen extends StatefulWidget {
//   @override
//   _GardenRecommendationScreenState createState() => _GardenRecommendationScreenState();
// }

// class _GardenRecommendationScreenState extends State<GardenRecommendationScreen> {
//   final _formKey = GlobalKey<FormState>();
//   String? _selectedLocation;
//   String? _selectedSeason;
//   String? _selectedSunlight;
//   String? _selectedPlant;

//   List<String> _locations = ['Indoor', 'Outdoor'];
//   List<String> _seasons = ['Winter', 'Spring', 'Summer', 'Autumn'];
//   List<String> _sunlightLevels = ['Full Sun', 'Partial Sun', 'Shade'];

//   List<String> _recommendedPlants = [];
//   String _instructions = '';

//   Future<List<String>> _fetchRecommendedPlants(String location, String season, String sunlight) async {
//     final querySnapshot = await FirebaseFirestore.instance.collection('plants')
//       .where('location', isEqualTo: location)
//       .where('season', isEqualTo: season)
//       .where('sunlight', isEqualTo: sunlight)
//       .get();

//     return querySnapshot.docs.map((doc) => doc['name'] as String).toList();
//   }

//   Future<String> _getInstructions(String plant) async {
//     final doc = await FirebaseFirestore.instance.collection('plants')
//       .where('name', isEqualTo: plant)
//       .limit(1)
//       .get();

//     if (doc.docs.isNotEmpty) {
//       final data = doc.docs.first.data();
//       StringBuffer sb = StringBuffer();
//       sb.writeln('$plant:');
//       sb.writeln('  Planting Depth: ${data['plantingDepth']}');
//       sb.writeln('  Spacing: ${data['spacing']}');
//       sb.writeln('  Watering: ${data['watering']}');
//       sb.writeln('  Harvesting: ${data['harvesting']}');
//       return sb.toString();
//     } else {
//       return 'Instructions not available.';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Urban Gardening Recommendations'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     DropdownButtonFormField<String>(
//                       decoration: InputDecoration(
//                         labelText: 'Location',
//                         border: OutlineInputBorder(),
//                       ),
//                       value: _selectedLocation,
//                       items: _locations.map((String location) {
//                         return DropdownMenuItem<String>(
//                           value: location,
//                           child: Text(location),
//                         );
//                       }).toList(),
//                       onChanged: (newValue) {
//                         setState(() {
//                           _selectedLocation = newValue;
//                         });
//                       },
//                       validator: (value) => value == null ? 'Please select a location' : null,
//                     ),
//                     SizedBox(height: 16),
//                     DropdownButtonFormField<String>(
//                       decoration: InputDecoration(
//                         labelText: 'Season',
//                         border: OutlineInputBorder(),
//                       ),
//                       value: _selectedSeason,
//                       items: _seasons.map((String season) {
//                         return DropdownMenuItem<String>(
//                           value: season,
//                           child: Text(season),
//                         );
//                       }).toList(),
//                       onChanged: (newValue) {
//                         setState(() {
//                           _selectedSeason = newValue;
//                         });
//                       },
//                       validator: (value) => value == null ? 'Please select a season' : null,
//                     ),
//                     SizedBox(height: 16),
//                     DropdownButtonFormField<String>(
//                       decoration: InputDecoration(
//                         labelText: 'Sunlight Availability',
//                         border: OutlineInputBorder(),
//                       ),
//                       value: _selectedSunlight,
//                       items: _sunlightLevels.map((String sunlight) {
//                         return DropdownMenuItem<String>(
//                           value: sunlight,
//                           child: Text(sunlight),
//                         );
//                       }).toList(),
//                       onChanged: (newValue) {
//                         setState(() {
//                           _selectedSunlight = newValue;
//                         });
//                       },
//                       validator: (value) => value == null ? 'Please select sunlight availability' : null,
//                     ),
//                     SizedBox(height: 24),
//                     Center(
//                       child: ElevatedButton(
//                         onPressed: () async {
//                           if (_formKey.currentState!.validate()) {
//                             String location = _selectedLocation!;
//                             String season = _selectedSeason!;
//                             String sunlight = _selectedSunlight!;

//                             List<String> recommendedPlants = await _fetchRecommendedPlants(location, season, sunlight);

//                             setState(() {
//                               _recommendedPlants = recommendedPlants;
//                               _selectedPlant = null;
//                               _instructions = '';
//                             });
//                           }
//                         },
//                         child: Text('Get Recommendations'),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 24),
//               if (_recommendedPlants.isNotEmpty) ...[
//                 Text(
//                   'Recommended Plants:',
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   _recommendedPlants.join(', '),
//                   style: TextStyle(fontSize: 16),
//                 ),
//                 SizedBox(height: 24),
//                 DropdownButtonFormField<String>(
//                   decoration: InputDecoration(
//                     labelText: 'Select a Plant',
//                     border: OutlineInputBorder(),
//                   ),
//                   value: _selectedPlant,
//                   items: _recommendedPlants.map((String plant) {
//                     return DropdownMenuItem<String>(
//                       value: plant,
//                       child: Text(plant),
//                     );
//                   }).toList(),
//                   onChanged: (newValue) async {
//                     setState(() {
//                       _selectedPlant = newValue;
//                     });
//                     if (newValue != null) {
//                       String instructions = await _getInstructions(newValue);
//                       setState(() {
//                         _instructions = instructions;
//                       });
//                     }
//                   },
//                   validator: (value) => value == null ? 'Please select a plant' : null,
//                 ),
//               ],
//               SizedBox(height: 24),
//               if (_instructions.isNotEmpty) ...[
//                 Text(
//                   'Growing Instructions:',
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                 ),
//                 SizedBox(height: 8),
//                 Container(
//                   padding: const EdgeInsets.all(8.0),
//                   decoration: BoxDecoration(
//                     color: Colors.grey[200],
//                     borderRadius: BorderRadius.circular(8.0),
//                   ),
//                   child: Text(
//                     _instructions,
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 ),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
