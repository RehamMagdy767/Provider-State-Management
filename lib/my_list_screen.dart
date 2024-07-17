import 'package:ass2/home_screen.dart';
import 'package:ass2/provider/store_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyListScreen extends StatelessWidget {
  const MyListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        return false; // Return false to avoid the default behavior
      },
      child:Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Favorite Stores',
          style: TextStyle(color: Colors.white), 
        ),
        backgroundColor: Colors.indigo, 
        centerTitle: true, 
      iconTheme: const IconThemeData(
          color: Colors.white, 
        ),
      ),
      body: Consumer<StoreProvider>(
        builder: (context, storeProvider, _) {
          final favoriteStores = storeProvider.favoriteStores;

          if (favoriteStores.isEmpty) {
            return Center(
              child: Text(
                'No favorite stores yet.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            itemCount: favoriteStores.length,
            itemBuilder: (context, index) {
              final store = favoriteStores[index];

              return Card(
                elevation: 3, 
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16), 
                child: ListTile(
                  title: Text(
                    store.name,
                    style: TextStyle(fontWeight: FontWeight.bold), 
                  ),
                  subtitle: Text(
                    'Tap the heart to remove from favorites', 
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.red), 
                    onPressed: () {
                      storeProvider.removeFromFavorites(store);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    ),);
  }
}
