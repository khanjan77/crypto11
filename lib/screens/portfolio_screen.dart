import 'package:flutter/material.dart';
import 'profile_screen.dart'; // Import the ProfileScreen

class PortfolioScreen extends StatefulWidget {
  @override
  _PortfolioScreenState createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  double _balance = 10000.00; // Initial balance

  void _updateBalance(double amount) {
    setState(() {
      _balance += amount;
    });
  }

  void _showDepositWithdrawDialog(String action) {
    final TextEditingController _amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$action Funds'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                Navigator.of(context).pop();
                final double amount = double.tryParse(_amountController.text) ?? 0;
                if (action == 'Withdraw' && _balance < amount) {
                  _showMessage('Insufficient balance.');
                  return;
                }
                _updateBalance(action == 'Withdraw' ? -amount : amount);
                _showMessage('$action successful.');
              },
            ),
          ],
        );
      },
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Main Portfolio'),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _showDepositWithdrawDialog('Deposit');
            },
          ),
          IconButton(
            icon: Icon(Icons.remove),
            onPressed: () {
              _showDepositWithdrawDialog('Withdraw');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account Balance
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 15,
                  ),
                ],
              ),
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Account Balance',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '\$${_balance.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
            ),
            // Portfolio Balance
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '\$5,276.39',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '+192% all time',
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            // Assets List
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top 4 coins
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 0),
                    title: Text(
                      'Assets',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 5,
                          blurRadius: 15,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildCryptoTile('Bitcoin', 0.5, -4.43, context),
                        _buildCryptoTile('Ethereum', 0.75, 5.79, context),
                        _buildCryptoTile('Chainlink', 9.45, 8.07, context),
                        _buildCryptoTile('Litecoin', 2.76, 9.98, context),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  // Recommended to Buy
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 0),
                    title: Text(
                      'Recommend to Buy',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildRecommendCard('Cardano', '\$1.23', '5.81%', context),
                      _buildRecommendCard('Binance Coin', '\$309.41', '16.21%', context),
                      _buildRecommendCard('Tron', '\$0.060', '12.0%', context),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
          }
        },
      ),
    );
  }

  Widget _buildCryptoTile(String name, double amount, double change, BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blueAccent,
        child: Text(name[0], style: TextStyle(color: Colors.white)),
      ),
      title: Text(name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
      subtitle: Text('${amount.toStringAsFixed(2)} BTC', style: TextStyle(color: Colors.grey[600])),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '\$${(amount * 60000).toStringAsFixed(2)}',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Text(
            '${change.toStringAsFixed(2)}%',
            style: TextStyle(color: change >= 0 ? Colors.green : Colors.red),
          ),
        ],
      ),
      onTap: () {
        // Implement the navigation to a detailed screen
      },
    );
  }

  Widget _buildRecommendCard(String name, String price, String change, BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.28,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 15,
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blueAccent,
            child: Text(name[0], style: TextStyle(color: Colors.white)),
          ),
          SizedBox(height: 10),
          Text(name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          SizedBox(height: 5),
          Text(price, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          Text(
            change,
            style: TextStyle(color: change.contains('-') ? Colors.red : Colors.green),
          ),
        ],
      ),
    );
  }
}
