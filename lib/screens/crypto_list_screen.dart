import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:syncfusion_flutter_charts/charts.dart'; // Import Syncfusion Charts package
import '../services/crypto_service.dart';

class CryptoListScreen extends StatefulWidget {
  final Function(bool) onThemeChange;

  CryptoListScreen({required this.onThemeChange});

  @override
  _CryptoListScreenState createState() => _CryptoListScreenState();
}

class _CryptoListScreenState extends State<CryptoListScreen> {
  final CryptoService _cryptoService = CryptoService();
  final Map<String, double> _prices = {};
  final Map<String, double> _previousPrices = {};
  final Map<String, WebSocketChannel> _channels = {};
  final Duration _updateInterval = Duration(seconds: 2); // Update interval
  Timer? _updateTimer;

  String _selectedTimeRange = '1d'; // Default time range

  final List<String> _coinOrder = [
    'BTC', 'ETH', 'LTC', 'XRP', 'ADA', 'DOT', 'LINK', 'BCH', 'XLM', 'TRX',
    'DOGE', 'SOL', 'MATIC', 'DASH', 'ZEC',  'FIL', 'AAVE'
  ];

  @override
  void initState() {
    super.initState();
    _initializeWebSockets();
    _startThrottling();
  }

  void _startThrottling() {
    _updateTimer = Timer.periodic(_updateInterval, (timer) {
      setState(() {}); // Trigger a rebuild at the specified interval
    });
  }

  Future<void> _initializeWebSockets() async {
    for (final symbol in _coinOrder) {
      final channel = WebSocketChannel.connect(
        Uri.parse('wss://stream.binance.com:9443/ws/${symbol.toLowerCase()}usdt@trade'),
      );

      channel.stream.listen((message) {
        final data = json.decode(message);
        final price = double.parse(data['p'].toString());
        setState(() {
          if (_prices.containsKey(symbol)) {
            _previousPrices[symbol] = _prices[symbol]!;
          } else {
            _previousPrices[symbol] = price;
          }
          _prices[symbol] = price;
        });
      }, onDone: () {
        _channels.remove(symbol);
      }, onError: (error) {
        print('WebSocket error for $symbol: $error');
        _channels.remove(symbol);
      });

      _channels[symbol] = channel;
    }
  }

  void _refreshRates() {
    setState(() {
      _prices.clear(); // Clear existing prices
      _previousPrices.clear(); // Clear previous prices
    });
    _initializeWebSockets();
  }

  void _showTransactionBottomSheet(String coin, double rate) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        final List<ChartData> chartData = _generateChartData(_selectedTimeRange);

        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    coin,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Price:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\$${rate.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 18,
                        color: rate > (_previousPrices[coin] ?? rate) ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 200,
                child: SfCartesianChart(
                  primaryXAxis: DateTimeAxis(),
                  primaryYAxis: NumericAxis(),
                  series: <ChartSeries>[
                    LineSeries<ChartData, DateTime>(
                      dataSource: chartData,
                      xValueMapper: (ChartData data, _) => data.time,
                      yValueMapper: (ChartData data, _) => data.price,
                      color: Colors.blue,
                      width: 2,
                    )
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _timeRangeButton('1m'),
                  _timeRangeButton('5m'),
                  _timeRangeButton('1h'),
                  _timeRangeButton('1d'),
                  _timeRangeButton('1y'),
                  _timeRangeButton('5y'),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Buy $coin action confirmed!')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                    child: Text('Buy'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Sell $coin action confirmed!')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                    child: Text('Sell'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _timeRangeButton(String range) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedTimeRange = range;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: _selectedTimeRange == range ? Colors.blue : Colors.grey,
      ),
      child: Text(range),
    );
  }

  List<ChartData> _generateChartData(String timeRange) {
    // Placeholder function to generate chart data
    // You should replace this with real data based on `timeRange`
    DateTime now = DateTime.now();
    return List.generate(10, (index) {
      return ChartData(
        time: now.subtract(Duration(minutes: 10 - index * 2)),
        price: 100 + (index * 5), // Example data
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TRADE X'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshRates,
          ),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[200],
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Top Cryptocurrencies',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[700],
                ),
              ),
            ),
            Container(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _coinOrder.length,
                itemBuilder: (context, index) {
                  final coin = _coinOrder[index];
                  final rate = _prices[coin] ?? double.nan;

                  return GestureDetector(
                    onTap: () {
                      _showTransactionBottomSheet(coin, rate);
                    },
                    child: Container(
                      width: 150,
                      margin: EdgeInsets.only(right: 10),
                      child: Card(
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _cryptoService.coins[coin] ?? coin,
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              Text(
                                rate.isNaN ? 'Error' : '\$${rate.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: rate > (_previousPrices[coin] ?? rate) ? Colors.green : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Other Cryptocurrencies',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[700],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: _coinOrder.map((coin) {
                  final rate = _prices[coin] ?? double.nan;

                  return GestureDetector(
                    onTap: () {
                      _showTransactionBottomSheet(coin, rate);
                    },
                    child: Card(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      elevation: 5,
                      child: ListTile(
                        title: Text(
                          _cryptoService.coins[coin] ?? coin,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          rate.isNaN ? 'Error' : '\$${rate.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 18,
                            color: rate > (_previousPrices[coin] ?? rate) ? Colors.green : Colors.red,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet),
            label: 'Wallet',
          ),
        ],
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/cryptoList');
              break;
            case 1:
              Navigator.pushNamed(context, '/settings');
              break;
            case 2:
              Navigator.pushNamed(context, '/profile');
              break;
            case 3:
              Navigator.pushNamed(context, '/portfolio');
              break;
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _updateTimer?.cancel();
    _channels.forEach((_, channel) => channel.sink.close());
  }
}

class ChartData {
  ChartData({required this.time, required this.price});
  final DateTime time;
  final double price;
}
