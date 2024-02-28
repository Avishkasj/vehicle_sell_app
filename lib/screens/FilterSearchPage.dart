import 'package:flutter/material.dart';

class FilterSearchPage extends StatefulWidget {
  @override
  _FilterSearchPageState createState() => _FilterSearchPageState();
}

class _FilterSearchPageState extends State<FilterSearchPage> {
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filter and Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search...',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) {
            setState(() {
              searchText = value;
            });
            // Implement search functionality
          },
        ),
      ),
    );
  }
}
