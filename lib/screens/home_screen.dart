import 'package:flutter/material.dart';
import 'FilterSearchPage.dart';
// Import the filter search page if not already imported

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0), // Adjust the height as per your requirement
        child: AppBar(
          backgroundColor: Color(0xFF4FAEAC),
          title: Text('Home',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            Container(
              margin: EdgeInsets.all(8), // Adjust the margin to control the size of the circle
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: IconButton(
                icon: Icon(Icons.search, color: Color(0xFF4FAEAC)), // Adjust the search icon color
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: Duration(milliseconds: 500),
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return FadeTransition(
                          opacity: animation,
                          child: FilterSearchPage(),
                        );
                      },
                    ),
                  );
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
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Two cards in each row
          crossAxisSpacing: 5.0, // Spacing between columns
          mainAxisSpacing: 5.0, // Spacing between rows
        ),
        itemCount: 10, // Adjust according to your data
        itemBuilder: (context, index) {
          return Container(
            height: 150, // Set the desired height of the card
            child: Card(
              child: ListTile(
                title: Text('Ad Title $index'),
                subtitle: Text('Ad Description $index'),
                onTap: () {
                  // Add onTap functionality for the card
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}
