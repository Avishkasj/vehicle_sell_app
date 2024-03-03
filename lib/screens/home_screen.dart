import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'FilterSearchPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> adsData = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      // Fetch data from the first API
      var response1 = await http.get(Uri.parse(
          'https://vehicle.futuretechbay.com/myapp/ikman_ads?region&category=&query=vehicles'));
      if (response1.statusCode == 200) {
        List<dynamic> data1 = json.decode(response1.body);
        List<Map<String, dynamic>> formattedData1 =
            data1.cast<Map<String, dynamic>>();
        setState(() {
          adsData.addAll(formattedData1);
        });
      }

      // Fetch data from the second API
      var response2 = await http.get(Uri.parse(
          'https://vehicle.futuretechbay.com/myapp/scrape?city=&type_of_car=&make=&registration=registered'));
      if (response2.statusCode == 200) {
        Map<String, dynamic> data2 = json.decode(response2.body);
        List<Map<String, dynamic>> formattedData2 =
            data2['results'].cast<Map<String, dynamic>>();
        setState(() {
          adsData.addAll(formattedData2);
        });
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  Future<void> _refreshAds() async {
    setState(() {
      adsData.clear(); // Clear the existing ads data
    });
    await fetchData(); // Fetch new ads data
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          backgroundColor: Color(0xFF4FAEAC),
          title: Text('Home'),
          actions: [
            Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: IconButton(
                icon: Icon(Icons.refresh, color: Color(0xFF4FAEAC)),
                onPressed: () {
                  _refreshAds();
                },
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Drawer Item 1'),
              onTap: () {
                // Add your drawer item 1 functionality
              },
            ),
            ListTile(
              title: Text('Drawer Item 2'),
              onTap: () {
                // Add your drawer item 2 functionality
              },
            ),
            // Add more list tiles for other drawer items
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshAds,
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 5.0,
          ),
          itemCount: adsData.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // Handle ad tap
              },
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(10.0)),
                        child: Image.network(
                          adsData[index]['image_url'] ?? '',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: ListView(
                          children: [
                            Text(
                              adsData[index]['title'] ?? '',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(adsData[index]['date_time'] ?? ''),
                            Text(adsData[index]['price'] ?? ''),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF4FAEAC),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FilterSearchPage(
                onSearch: (selectedMake, selectedType, selectedCity) {
                  // Implement your filtering logic here
                  print('Selected Make: $selectedMake');
                  print('Selected Type: $selectedType');
                  print('Selected City: $selectedCity');

                  // Check if the selected city is 'aa'
                  if (selectedCity != 'Any City' || selectedType != 'Any Type' || selectedMake != 'Select Make' ) {
                    _refreshAds();
                    // Perform actions specific to the selected city 'aa'
                  } else {
                    // Perform actions for other selected cities
                  }
                },
              ),
            ),
          );
        },

        child: Icon(Icons.search,color:Colors.white,size: 40,),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}
