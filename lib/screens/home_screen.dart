import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;
import 'FilterSearchPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> adsData = [];
  var selectedMake = '';
  var selectedType = '';
  var selectedCity= '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      await fetchIkmanAds(selectedMake ,'', 'colombo',selectedMake+' '+selectedType);
      await  fetchRiyasewanaAds(selectedMake ,selectedType, 'colombo','');
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  Future<void> fetchIkmanAds(String selectedMake, String selectedType, String selectedCity,String quary) async {
    print('running----------1');
    try {
      var encodedCity = Uri.encodeComponent(selectedCity);
      var encodedType = Uri.encodeComponent(selectedType);
      var encodedMake = Uri.encodeComponent(selectedMake);
      var encodedQuary = Uri.encodeComponent(quary);
      var response = await http.get(Uri.parse(
          'https://ikman.lk/en/ads/$encodedCity/vehicles?sort=relevance&buy_now=0&urgent=0&query=$quary&page=1'));
      if (response.statusCode == 200) {
        final document = parser.parse(response.body);
        List<Map<String, dynamic>> ikmanAds = extractIkmanAds(document);
        setState(() {
          adsData.addAll(ikmanAds);
        });
      }
    } catch (e) {
      print("Error fetching Ikman ads: $e");
    }
  }

  List<Map<String, dynamic>> extractIkmanAds(dom.Document document) {
    List<Map<String, dynamic>> ads = [];
    var adElements = document.querySelectorAll('li.normal--2QYVk');
    for (var adElement in adElements) {
      Map<String, dynamic> adData = {};
      adData['title'] =
          adElement.querySelector('h2.heading--2eONR')?.text ?? 'Title Not Available';
      adData['price'] =
          adElement.querySelector('div.price--3SnqI')?.text ?? 'Price Not Available';
      adData['location'] =
          adElement.querySelector('div.description--2-ez3')?.text ?? 'Location Not Available';
      adData['time_date'] =
          adElement.querySelector('div.updated-time--1DbCk')?.text ?? 'Time and Date Not Available';
      adData['image_url'] = adElement.querySelector('img.normal-ad--1TyjD')?.attributes['src'] ??
          'Image Not Available';
      adData['source'] = 'ikman.lk';
      ads.add(adData);
    }
    return ads;
  }

  Future<void> fetchRiyasewanaAds(String selectedMake, String selectedType, String selectedCity,String search) async {
    print('running----------2');
    try {
      var encodedCity = Uri.encodeComponent(selectedCity);
      var encodedType = Uri.encodeComponent(selectedType);
      var encodedMake = Uri.encodeComponent(selectedMake);
      var encodedSearch = Uri.encodeComponent(search);

      var response = await http.get(Uri.parse(
          'https://riyasewana.com/search/$encodedType/$encodedMake/$encodedSearch/$encodedCity'));

      if (response.statusCode == 200) {
        final document = parser.parse(response.body);
        List<Map<String, dynamic>> riyasewanaAds = extractRiyasewanaAds(document);
        setState(() {
          adsData.addAll(riyasewanaAds);
        });
      }
    } catch (e) {
      print("Error scraping Riyasewana: $e");
    }
  }


  List<Map<String, dynamic>> extractRiyasewanaAds(dom.Document document) {
    List<Map<String, dynamic>> ads = [];
    var adElements = document.querySelectorAll('li.item.round');
    for (var adElement in adElements) {
      Map<String, dynamic> adData = {};
      adData['title'] = adElement.querySelector('h2.more a')?.attributes['title'] ??
          'Title Not Available';
      adData['link'] =
          adElement.querySelector('h2.more a')?.attributes['href'] ?? 'Link Not Available';
      adData['date_time'] =
          adElement.querySelector('h2[style="font-size:13px;text-align:center;color:#636b75;'
              'font-weight:normal;padding:0 0 5px 0;line-height:1.3em;"]')
              ?.text ??
              'Date and Time Not Available';
      adData['price'] = adElement.querySelector('div.boxintxt.b')?.text ?? 'Price Not Available';
      adData['location'] = adElement.querySelector('div.boxintxt')?.text ?? 'Price Not Available';
      adData['image_url'] = 'https:' +
          (adElement.querySelector('img')?.attributes['src'] ?? 'Image Not Available');
      adData['source'] = 'riyasewana';
      ads.add(adData);
    }
    return ads;
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
          title: Text('Home',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,),),
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
                  setState(() {
                    adsData.clear(); // Clear the existing ads data
                    selectedMake = '';
                    selectedType='';// Reset selected make
                    //selectedType = null; // Reset selected type
                    //selectedCity = null; // Reset selected city
                  });
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
            maxCrossAxisExtent: MediaQuery.of(context).size.width / 2, // Adjust this value as needed
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
                            // Text(adsData[index]['source'] ?? ''),


                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  adsData[index]['price'] ?? '',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                // Text(
                                //   adsData[index]['source'] ?? '',
                                //   style: TextStyle(fontSize: 12),
                                // ),
                                if (adsData[index]['source'] == 'riyasewana')
                                  Container(
                                   height: 30,
                                    child: Image.asset('lib/assets/riyasewana.png'),
                                  ),
                                if (adsData[index]['source'] == 'ikman.lk')
                                  Container(
                                    width: 30,
                                    child: Image.asset('lib/assets/ikman.png'),
                                  ),


                              ],
                            ),


                            Text(adsData[index]['location'] ?? ''),
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
                  setState(() {
                    this.selectedMake = selectedMake;
                    this.selectedType = selectedType;
                    // Perform filtering based on the selected filters
                    _refreshAds();
                  });
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
