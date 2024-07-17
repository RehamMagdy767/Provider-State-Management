import 'package:ass2/home_screen.dart';
import 'package:ass2/provider/Location_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ass2/provider/store_provider.dart';

class StoreListWithDistance extends StatelessWidget {
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
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Favorite Stores with Distance',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.indigo,
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
        body: Consumer2<StoreProvider, LocationProvider>(
          builder: (context, storeProvider, locationProvider, _) {
            final favoriteStores = storeProvider.favoriteStores;
            final currentLocation = locationProvider.currentPosition;

            if (currentLocation == null) {
              // If location data is not available, provide an option to fetch it
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Location data not available. Please enable location services.',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        locationProvider
                            .getCurrentLocation(); // Request location update
                      },
                      child: const Text(
                        'Get Current Location',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            // If the location is available, calculate distances for favorite stores
            return ListView.builder(
              itemCount: favoriteStores.length,
              itemBuilder: (context, index) {
                final store = favoriteStores[index];
                double distance = locationProvider.calculateDistance(
                  currentLocation,
                  store.latitude!,
                  store.longitude!,
                );

                return Card(
                  elevation: 3,
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
                        if (distance >= 0) Text('Distance: $distance km'),
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
