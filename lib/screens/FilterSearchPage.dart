import 'package:flutter/material.dart';

class FilterSearchPage extends StatefulWidget {
  final Function(String, String, String) onSearch;

  FilterSearchPage({required this.onSearch});

  @override
  _FilterSearchPageState createState() => _FilterSearchPageState();
}

class _FilterSearchPageState extends State<FilterSearchPage> {
  String searchText = '';
  List<String> makeOptions = [
    '',
    'toyota',
    'suzuki',
    // Other make options...
  ];

  List<String> typeOptions = [
    '',
    'cars',
    'vans',
    // Other type options...
  ];

  List<String> cityOptions = [
    '',
    'Colombo District',
    'colombo',
    // Other city options...
  ];

  String selectedMake = '';
  String selectedType = '';
  String selectedCity = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filter and Search'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      // Implement search functionality
                    },
                  ),
                  SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: selectedMake,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedMake = newValue!;
                      });
                    },
                    items: makeOptions.map((String make) {
                      return DropdownMenuItem<String>(
                        value: make,
                        child: Text(make),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Select Make',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: selectedType,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedType = newValue!;
                      });
                    },
                    items: typeOptions.map((String type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Select Type',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: selectedCity,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCity = newValue!;
                      });
                    },
                    items: cityOptions.map((String city) {
                      return DropdownMenuItem<String>(
                        value: city,
                        child: Text(city),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Select City',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: () {
                // Pass the selected filter data back to the home screen
                widget.onSearch(selectedMake, selectedType, selectedCity);
                Navigator.pop(context); // Close the filter page
              },

              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF4FAEAC)),
                shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Search',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
