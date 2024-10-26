import 'package:flutter/material.dart';

class DepositWithdrawScreen extends StatefulWidget {
  @override
  _DepositWithdrawScreenState createState() => _DepositWithdrawScreenState();
}

class _DepositWithdrawScreenState extends State<DepositWithdrawScreen> {
  double _balance = 1000.0; // Example starting balance
  final TextEditingController _amountController = TextEditingController();

  void _performTransaction(String type) {
    final double? amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      _showMessage('Please enter a valid amount.');
      return;
    }

    setState(() {
      if (type == 'Deposit') {
        _balance += amount;
      } else if (type == 'Withdraw') {
        if (_balance < amount) {
          _showMessage('Insufficient balance.');
          return;
        }
        _balance -= amount;
      }
      _amountController.clear();
      _showMessage('$type successful.');
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deposit/Withdraw'),
        backgroundColor: Colors.grey[850], // Dark gray for the AppBar
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900], // Slightly lighter dark gray
        ),
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Account Balance: ₹${_balance.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16.0),
            _buildTextField(
              label: 'Amount',
              controller: _amountController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  text: 'Deposit',
                  color: Colors.tealAccent,
                  onPressed: () => _performTransaction('Deposit'),
                ),
                _buildActionButton(
                  text: 'Withdraw',
                  color: Colors.deepOrangeAccent,
                  onPressed: () => _performTransaction('Withdraw'),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey[850], // Dark gray for the BottomAppBar
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.home, color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, '/cryptoList');
              },
            ),
            IconButton(
              icon: Icon(Icons.settings, color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
            IconButton(
              icon: Icon(Icons.account_balance_wallet, color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, '/portfolio');
              },
            ),
            IconButton(
              icon: Icon(Icons.person, color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
            IconButton(
              icon: Icon(Icons.attach_money, color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, '/depositWithdraw');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required String label, required TextEditingController controller, TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white70),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[800],
      ),
      style: TextStyle(color: Colors.white),
      keyboardType: keyboardType,
    );
  }

  Widget _buildActionButton({required String text, required Color color, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 5,
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
