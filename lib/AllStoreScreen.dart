import 'package:ass2/SignInScreen.dart';
import 'package:ass2/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:ass2/provider/store_provider.dart';
import 'package:provider/provider.dart';

class AllStoresScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignInScreen()),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'All Stores',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.indigo,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back), 
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SignInScreen()),
              );
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.favorite),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
            ),
          ],
        ),
        body: Consumer<StoreProvider>(
          builder: (context, storeProvider, _) {
            final stores = storeProvider.stores; 

            return ListView.builder(
              itemCount: stores.length,
              itemBuilder: (context, index) {
                final store = stores[index];

                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  child: ListTile(
                    title: Text(
                      store.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Longitude: ${store.longitude}'),
                        Text('Latitude: ${store.latitude}'),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
