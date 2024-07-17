import 'package:ass2/AllStoreScreen.dart';
import 'package:ass2/StoreListWithDistance.dart';
import 'package:flutter/material.dart';
import 'package:ass2/my_list_screen.dart';
import 'package:ass2/provider/store_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch initial data when the widget is initialized
    Provider.of<StoreProvider>(context, listen: false).fetchInitialData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AllStoresScreen()),
        );
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Stores List',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.indigo,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AllStoresScreen()),
              );
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.location_on, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StoreListWithDistance(),
                  ),
                );
              },
            ),
          ],
        ),
        body: Consumer<StoreProvider>(
          builder: (context, storeProvider, _) {
            final stores = storeProvider.stores;
            final favoriteStores = storeProvider.favoriteStores;

            return ListView.builder(
              itemCount: stores.length,
              itemBuilder: (context, index) {
                final store = stores[index];
                final isFavorite = favoriteStores.any((s) => s.id == store.id);

                return Card(
                  elevation: 2,
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(store.name,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("ID: ${store.id}"),
                    trailing: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : null,
                      ),
                      onPressed: () async {
                        if (!isFavorite) {
                          storeProvider.addToFavorites(store);
                        } 
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.indigo,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MyListScreen(),
              ),
            );
          },
          label: Text(
            'My Favorites',
            style: TextStyle(color: Colors.white),
          ),
          icon: Icon(Icons.favorite, color: Colors.white),
        ),
      ),
    );
  }
}
