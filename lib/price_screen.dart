import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
import 'dart:convert';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'INR';
  String cryptoCurrencyBTC = 'BTC';
  String cryptoCurrencyETH = 'ETH';
  String cryptoCurrencyLTC = 'LTC';
  double doubleRateOfTheCoins;
  int indexNumber;
  int intRate = 0;
  var api = 'AA342CA7-DD55-442C-B3FA-19928E98FBC1';

  Future<dynamic> getCoinPricingData(String currencyCode) async {
    http.Response response = await http.get(
        'https://rest.coinapi.io/v1/exchangerate/USD/$selectedCurrency?apikey=$api');

    setState(() {
      if (response.statusCode == 200) {
        String data = response.body;
        doubleRateOfTheCoins = jsonDecode(data)['rate'];
        intRate = doubleRateOfTheCoins.toInt();
        print(intRate);
        return intRate;
      } else {
        return response.statusCode;
      }
    });
  }

  CupertinoPicker iosPicker() {
    List<Widget> pickerItem = [];

    for (String currency in currenciesList) {
      var newItem = Text('$currency');
      pickerItem.add(newItem);
    }

    return CupertinoPicker(
      itemExtent: 35,
      onSelectedItemChanged: (selectedIndex) {
        indexNumber = selectedIndex;
      },
      children: pickerItem,
    );
  }

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropDownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropDownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          print(selectedCurrency);
           getCoinPricingData(value);
          getCoinPricingData(value);
           getCoinPricingData(value);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          NewCard(cryptoCurrency: 'BTC',intRate: intRate, selectedCurrency: selectedCurrency),
          NewCard(intRate: intRate, selectedCurrency: selectedCurrency, cryptoCurrency: 'ETH'),
          NewCard(intRate: intRate, selectedCurrency: selectedCurrency, cryptoCurrency: 'LTC'),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iosPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}

class NewCard extends StatelessWidget {
  const NewCard({
    Key key,
    @required this.intRate,
    @required this.selectedCurrency,
    @required this.cryptoCurrency,
  }) ;

  final int intRate;
  final String selectedCurrency;
  final String cryptoCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoCurrency = $intRate $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
