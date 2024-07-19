import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String cityName = "London";
  String weatherCondition = "Light rain";
  int temperature = 7;
  String weatherIconUrl =
      "https://cdn.weatherapi.com/weather/64x64/day/116.png";

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  fetchWeather() async {
    final response = await http.get(Uri.parse(
        'https://api.weatherapi.com/v1/current.json?key=f4a15d79178d417bb9a110956241707&q=London'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        cityName = data['location']['name'];
        weatherCondition = data['current']['condition']['text'];
        temperature = data['current']['temp_c'].toInt();
        weatherIconUrl = "https:${data['current']['condition']['icon']}";
      });
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Weather App',
                  style: TextStyle(color: Colors.white, fontSize: 24)),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Hourly Forecast'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HourlyForecastScreen()),
                );
              },
            ),
            ListTile(
              title: Text('Daily Forecast'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DailyForecastScreen()),
                );
              },
            ),
            ListTile(
              title: Text('Places'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PlacesScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              cityName,
              style: TextStyle(fontSize: 32),
            ),
            Image.network(
              weatherIconUrl,
              height: 100,
              width: 100,
            ),
            Text(
              '$temperature°C',
              style: TextStyle(fontSize: 48),
            ),
            Text(
              weatherCondition,
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}

class PlacesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> cities = [
    {
      "name": "City 0",
      "temp": 25,
      "icon": "https://cdn.weatherapi.com/weather/64x64/day/113.png"
    },
    {
      "name": "City 1",
      "temp": 25,
      "icon": "https://cdn.weatherapi.com/weather/64x64/day/113.png"
    },
    {
      "name": "City 2",
      "temp": 25,
      "icon": "https://cdn.weatherapi.com/weather/64x64/day/113.png"
    },
    {
      "name": "City 3",
      "temp": 25,
      "icon": "https://cdn.weatherapi.com/weather/64x64/day/113.png"
    },
    {
      "name": "City 4",
      "temp": 25,
      "icon": "https://cdn.weatherapi.com/weather/64x64/day/113.png"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('City Weather'),
      ),
      body: ListView.builder(
        itemCount: cities.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Image.network(cities[index]['icon']),
            title: Text(cities[index]['name']),
            subtitle: Text('${cities[index]['temp']}°C'),
            trailing: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CityDetailScreen(city: cities[index])),
                );
              },
              child: Text('More Info'),
            ),
          );
        },
      ),
    );
  }
}

class CityDetailScreen extends StatelessWidget {
  final Map<String, dynamic> city;

  CityDetailScreen({required this.city});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(city['name']),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.network(
              city['icon'],
              height: 100,
              width: 100,
            ),
            Text(
              city['name'],
              style: TextStyle(fontSize: 32),
            ),
            Text(
              '${city['temp']}°C',
              style: TextStyle(fontSize: 48),
            ),
          ],
        ),
      ),
    );
  }
}

class HourlyForecastScreen extends StatelessWidget {
  final List<Map<String, dynamic>> hourlyForecast = List.generate(
      24,
      (index) => {
            "time": "${index}:00",
            "temp": 25,
            "icon": "https://cdn.weatherapi.com/weather/64x64/day/113.png",
          });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hourly Forecast'),
      ),
      body: ListView.builder(
        itemCount: hourlyForecast.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Image.network(hourlyForecast[index]['icon']),
            title: Text(hourlyForecast[index]['time']),
            subtitle: Text('${hourlyForecast[index]['temp']}°C'),
          );
        },
      ),
    );
  }
}

class DailyForecastScreen extends StatelessWidget {
  final List<Map<String, dynamic>> dailyForecast = List.generate(
      7,
      (index) => {
            "day": "Day $index",
            "high": 30,
            "low": 20,
            "icon": "https://cdn.weatherapi.com/weather/64x64/day/113.png",
          });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Forecast'),
      ),
      body: ListView.builder(
        itemCount: dailyForecast.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Image.network(dailyForecast[index]['icon']),
            title: Text(dailyForecast[index]['day']),
            subtitle: Text(
                'High: ${dailyForecast[index]['high']}°C\nLow: ${dailyForecast[index]['low']}°C'),
          );
        },
      ),
    );
  }
}
