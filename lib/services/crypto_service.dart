import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter/foundation.dart';

class CryptoService {
  final Map<String, String> coins = {
    'BTC': 'Bitcoin',
    'ETH': 'Ethereum',
    'LTC': 'Litecoin',
    'XRP': 'Ripple',
    'ADA': 'Cardano',
    'DOT': 'Polkadot',
    'LINK': 'Chainlink',
    'BCH': 'Bitcoin Cash',
    'XLM': 'Stellar',
    'TRX': 'Tron',
    'DOGE': 'Dogecoin',
    'SOL': 'Solana',
    'MATIC': 'Polygon',
    'ZEC': 'Zcash',
    // 'NEO': 'Neo',
    // 'VET': 'VeChain',
    'FIL': 'Filecoin',
    'AAVE': 'Aave',
    'UNI': 'Uniswap',
    'ATOM': 'Cosmos',
    'ALGO': 'Algorand',
    'FTT': 'FTX Token',
    'AVAX': 'Avalanche',
    'XMR': 'Monero',
    'BTT': 'BitTorrent',
    'WAVES': 'Waves',
    'LUNA': 'Terra',
    'XTZ': 'Tezos',
    'ENJ': 'Enjin Coin',
    'MKR': 'Maker',
    'COMP': 'Compound',
    'KSM': 'Kusama',
    'SUSHI': 'SushiSwap',
    'YFI': 'Yearn.finance',
    'REN': 'Ren',
    'ZRX': '0x',
    'SNX': 'Synthetix',
    'CHZ': 'Chiliz',
    'RUNE': 'ThorChain',
    'HNT': 'Helium',
    'GRT': 'The Graph',
    'FTM': 'Fantom',
    'RAY': 'Raydium',
    'SRM': 'Serum',
    'LPT': 'Livepeer',
    'CRO': 'Crypto.com Coin',
    'KNC': 'Kyber Network',
    // 'BAL': 'Balancer',
    'SAND': 'The Sandbox',
    'MANA': 'Decentraland',
    'CVC': 'Civic',
    'ANKR': 'Ankr',
    '1INCH': '1inch',
    'OMG': 'OMG Network',
    // Add more coins as needed
  };

  final Map<String, WebSocketChannel> _channels = {};

  // Connect to Binance WebSocket API for a specific coin
  void connectToWebSocket(String symbol, Function(String) onUpdate) {
    if (_channels.containsKey(symbol)) {
      return; // Already connected
    }

    final channel = WebSocketChannel.connect(
      Uri.parse('wss://stream.binance.com:9443/ws/${symbol.toLowerCase()}usdt@trade'),
    );

    channel.stream.listen((message) {
      final data = json.decode(message);
      final price = data['p']; // Price is in 'p' field for trade updates
      onUpdate(price);
    }, onDone: () {
      _channels.remove(symbol);
    }, onError: (error) {
      print('WebSocket error for $symbol: $error');
      _channels.remove(symbol);
    });

    _channels[symbol] = channel;
  }

  // Disconnect from WebSocket for a specific coin
  void disconnectFromWebSocket(String symbol) {
    if (_channels.containsKey(symbol)) {
      _channels[symbol]?.sink.close();
      _channels.remove(symbol);
    }
  }

  // Example method to fetch live prices
  Future<Map<String, String>> fetchLivePrices() async {
    final Map<String, String> prices = {};
    for (final symbol in coins.keys) {
      connectToWebSocket(symbol, (price) {
        prices[symbol] = price;
      });
    }
    await Future.delayed(Duration(seconds: 10)); // Wait for some data to accumulate
    return prices;
  }
}
